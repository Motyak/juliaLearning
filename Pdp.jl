module Pdp
    using JuMP      #ilp/mip model
    using GLPK      #optimizer
    using Dates     #timestamp

    struct Input
        m::UInt16           #nombre de véhicules/transporteurs
        n::UInt16           #nombre de paires origine;destination (clients)
        c::Array{UInt16, 2} #matrice représentant la distance entre un sommet i et j
        t::Array{UInt16, 2} #matrice des durées de trajet du sommet i à j (en minutes)
        e::Array{UInt16}    #temps au plus tot pour commencer le service au sommet i
        l::Array{UInt16}    #temps au plus tard pour commencer le service au sommet i
    end

    struct Output
        objectiveValue::UInt16  #distance totale parcourue
        objectiveTimes::Array{UInt16, 2}    #temps prévus chaque sommet chaque vehicule
        timestamp::DateTime
        solveTime::Float32
        res::Array{Bool, 3} # = 1 si le véhicule k parcourt l'arc allant du sommet i à j
    end

    # retourne une Output
    function solve(input)
        timestamp = now()
        # m, n, c = input.m, input.n, input.c
        m, n, c, t, e, l = input.m, input.n, input.c, input.t, input.e, input.l

        #nb de sommets (total points départs véhicules + origines + destinations)
        N = 2*n+m

        model = Model(GLPK.Optimizer)

        # = 1 si le véhicule k a traversé la route (i,j), 0 sinon
        @variable(model, x[1:N,1:N,1:m], Bin)

        # debut du service au sommet i par le vehicule k
        # (temps = nb de minutes écoulées depuis minuit)
        @variable(model, 0 <= B[1:N,1:m] <= 2879, Int)

        # minimiser la distance totale parcourue par les véhicules
        @objective(model, Min, sum(c[i,j]*x[i,j,k] for i in 1:N, j in 1:N, k in 1:m))

        # chaque paire origine/destination doit être traversée exactement une fois 
        # par un seul véhicule <=> contrainte 14
        @constraint(model, [i in m+1:m+n], sum(x[i,j,k] for k in 1:m, j = i + n) == 1)

        # faire une contrainte specifiant qu'au moins un des sommets 
        # entre 1 et m doit obligatoirement être emprunté ? <=> a celle du dessous

        # Pour chaque destination, il y a exactement un véhicule entrant
        @constraint(model, [j in m+1:N], sum(x[i,j,k] for i in 1:N, k in 1:m) == 1)

        # # conservation du flot dans le reseau (theorie des graphes) <=> contrainte 17
        # @constraint(model, [j in m+1:N, k in 1:m], 
        #         sum(x[i,j,k] for i in m+1:N) - sum(x[j,i,k] for i in m+1:N) == 0)

        # # empecher les détours et faciliter contraintes de temps <=> contrainte 18
        # @constraint(model, [i in m+1:N, j in m+1:N, k in 1:m], 
        #         x[i,j,k]*(B[i,k]+t[i,j]) <= B[j,k])

        # # a la fois l'origine et la destination doivent être servies 
        # # par un meme vehicule <=> contrainte 22
        # @constraint(model, [i in m+1:m+n, k in 1:m], 
        #         sum(x[i,j,k] for j in m+1:N) - sum(x[i+n,j,k] for j in m+1:N) == 0)

        # # le temps prévu pour l'origine doit être inférieur au temps prévu 
        # # pour la destination <=> contrainte 23
        # @constraint(model, [i in m+1:m+n, k in 1:m], B[i,k] <= B[i+n,k])

        # # respect des fenetres de temps <=> contrainte 25
        # @constraint(model, [i in m+1:N, k in 1:m], e[i] <= B[i,k] <= l[i])

        optimize!(model)

        return Output(objective_value(model), value.(B), timestamp, 
                solve_time(model), value.(x))
    end

    # test unitaire
    function test()
        c = [10000 10000 20 10000 10000 10000;
            10000 10000 10000 257 10000 10000;
            20 10000 10000 312 312 10000;
            10000 257 10000 10000 130 140;
            10000 10000 312 130 10000 10000;
            10000 10000 10000 140 10000 10000]

        t = [1440 1440 2 1440 1440 1440;
            1440 1440 1440 31 1440 1440;
            2 1440 1440 37 37 1440;
            1440 31 1440 1440 16 17;
            1440 1440 37 16 1440 1440;
            1440 1440 1440 17 1440 1440]

        e = [0, 0, 750, 825, 0, 0]

        l = [2879, 2879, 765, 840, 2879, 2879]

        input = Input(2, 2, c, t, e, l)

        output = solve(input)

        println("obj value = ", output.objectiveValue)
        println("obj times = ", output.objectiveTimes)
        println("timestamp = ", output.timestamp)
        println("solve time = ", output.solveTime)
        println("res = ", output.res)
    end
end