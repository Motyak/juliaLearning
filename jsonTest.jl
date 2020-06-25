jsonStr = "{\"m\":2,\"n\":2,\"c\":[[10000,10000,20,10000,10000,10000],[10000,10000,10000,257,10000,10000],[20,10000,10000,312,312,10000],[10000,257,10000,10000,130,140],[10000,10000,312,130,10000,10000],[10000,10000,10000,140,10000,10000]]}"
data = JSON.parse(jsonStr)

#nb de voitures
m = data["m"]
#nb d'origines/destinations (appairés donc même nombre)
n = data["n"]
#nb de sommets (total point départ véhicules + origines + destinations)
N = 2*n+m
# distance entre les sommets i et j
c_arrOfAny = data["c"]
c = Array{Int64, 2}(undef, N, N)
for i = 1:N
    for j = 1:N
        c[i,j] = c_arrOfAny[i][j]
    end
end

model = Model(GLPK.Optimizer)

# = 1 si le véhicule k a traversé la route (i,j), 0 sinon
@variable(model, x[1:N,1:N,1:m], Bin)

# minimiser la distance totale parcourue par les véhicules
@objective(model, Min, sum(c[i,j]*x[i,j,k] for i in 1:N, j in 1:N, k in 1:m))

# chaque paire origine/destination doit être traversée exactement une fois 
# par un seul véhicule <=> contrainte 14
@constraint(model, [i in m+1:m+n], sum(x[i,j,k] for k in 1:m, j = i + n) == 1)

# Pour chaque destination, il y a exactement un véhicule entrant
@constraint(model, [j in m+1:N], sum(x[i,j,k] for i in 1:N, k in 1:m) == 1)

optimize!(model)

println("Objective value: ", objective_value(model))
println("Solve time: ", solve_time(model))
# println("x = ", value.(x))

res = Array{Bool, 3}(undef, m, N, N)
for k = 1:m
    for j = 1:N
        for i = 1:N
            # on inverse l'ordre des indices car [k,j,i] => [i][j][k] en json
            res[k,j,i] = value.(x[i,j,k])
        end
    end
end

println("res = \n", res)
println("res as json = \n", JSON.json(res))