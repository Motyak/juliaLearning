m = Model(GLPK.Optimizer)

@variable(m, x1, Int)
@variable(m, x2, Int)

@objective(m, Max, 2x1 + 3x2)

@constraint(m, 5x1 + 3x2 <= 16)
@constraint(m, 4x1 + 2x2 <= 12)
@constraint(m, x1 <= 8)
@constraint(m, x1 >= 0)
@constraint(m, x2 >= 0)

println("The optimization problem to be solved is:")
print(m)

optimize!(m)
status = termination_status(m) #

write_to_file(m, "exampleModel.mps")

println("Objective value: ", objective_value(m))
println("Solve time: ", solve_time(m))
println("x1 = ", value(x1))
println("x2 = ", value(x2))