n = 4
INF = 500
c = [   INF 1   1   1;
        1   INF 1   1;
        1   1   INF 1;
        1   1   1   INF ]

model = Model(GLPK.Optimizer)

@variable(model, x[1:n,1:n],Bin)
@variable(model, u[1:n] <=n)

@objective(model, Min, sum(c[i,j]*x[i,j] for i in 1:n, j in 1:n))

@constraint(model, [i=1:n], sum(x[i,j] for j in 1:n) == 1)
@constraint(model, [i=1:n], sum(x[j,i] for j in 1:n) == 1)

@constraint(model, u[1] == 1)
@constraint(model, [i=2:n], u[i] >= 2)
@constraint(model, [i=2:n, j=2:n; i!=j], u[i]-u[j]+1 <= n*(1-x[i,j]))

optimize!(model)

println("Objective value: ", objective_value(model))
println("Solve time: ", solve_time(model))
