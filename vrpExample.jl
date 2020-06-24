INF = 10000

#nb de voitures
m = 2
#nb d'origines/destinations (appairés donc même nombre)
n = 2
#nb de sommets (total point départ véhicules + origines + destinations)
N = m+2n

# Soit point = T1   T2  C1.1    C2.1    C1.2    C2.2
#     sommet = 1    2   3       4       5       6 
# distance entre les sommets i et j
c = [   INF INF 20  INF INF INF;
        INF INF INF 257 INF INF;
        20  INF INF INF 312 INF;
        INF 257 312 INF 130 140;
        INF INF 312 130 INF INF;
        INF INF INF 140 INF INF ]

model = Model(GLPK.Optimizer)

# = 1 si le véhicule k a traversé la route (i,j), 0 sinon
@variable(model, x[1:N,1:N,1:m], Bin)

# minimiser la distance totale parcourue par les véhicules
@objective(model, Min, sum(c[i,j]*x[i,j,k] for i in 1:N, j in 1:N, k in 1:m))

# # chaque sommet doit être servi exactement une fois <=> contrainte 14
# @constraint(model, [i in m+1:N], sum(x[i,j,k] for k in 1:m, j in m+1:N) == 1)

# chaque paire origine/destination doit être traversée exactement une fois 
# par un seul véhicule <=> contrainte 14
@constraint(model, [i in m+1:m+n], sum(x[i,j,k] for k in 1:m, j = i + n) == 1)





# Pour chaque destination, il y a exactement un véhicule entrant
@constraint(model, [j in m+1:N], sum(x[i,j,k] for i in 1:N, k in 1:m) == 1)







# # Il y a au moins un véhicule monopolisé, partant de son point de départ vers 
# # une origine (point de chargement) <=> contrainte 15
# @constraint(model, sum(x[i,j,k] for k in 1:m, j in m+1:m+n, i = k) >= 1)

# # Tout véhicule entrant doit sortir (Flot réseau -> théorie graphes) <=> contrainte 17
# @constraint(model, [j in 1:N, k in 1:m], 
#         sum(x[i,j,k] for i in 1:N) - sum(x[j,i,k] for i in 1:N) == 0)

optimize!(model)

println("Objective value: ", objective_value(model))
println("Solve time: ", solve_time(model))
println("x = ", value.(x))