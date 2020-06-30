module Pdp
    using JuMP      #ilp/mip model
    using GLPK      #optimizer
    using Dates     #timestamp

    struct Input
        m::UInt16
        n::UInt16
        c::Array{UInt16, 2}
    end

    struct Output
        objectiveValue::Float32
        timestamp::DateTime
        solveTime::Float32
        res::Array{Bool, 3}
    end

    # m : nombre de véhicules/transporteurs
    # n : nombre de paires origine/destination, soit nb de clients à servir
    # c_param : matrice représentant la distance entre un sommet i et j
    # 
    # retourne x, matrice tridimensionnelle binaire indiquant si
    #   le véhicule k a parcouru l'arc allant du sommet i à j
    function solve(input)
        timestamp = now()
        m, n, c = input.m, input.n, input.c

        #nb de sommets (total points départs véhicules + origines + destinations)
        N = 2*n+m

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

        return Output(objective_value(model), timestamp, solve_time(model), value.(x))
    end

    function test()
        c = [10000 10000 20 10000 10000 10000;
            10000 10000 10000 257 10000 10000;
            20 10000 10000 312 312 10000;
            10000 257 10000 10000 130 140;
            10000 10000 312 130 10000 10000;
            10000 10000 10000 140 10000 10000]

        input = Input(2, 2, c)

        output = solve(input)

        println("obj value = ", output.objectiveValue)
        println("timestamp = ", output.timestamp)
        println("solve time = ", output.solveTime)
        println("res = ", output.res)
    end
end