module Test

    include("../Pdp.jl")
    using .Pdp

    using Dates
    using Random

    mutable struct Coord
        x::Int32
        y::Int32
    end

    struct RandomInstance
        population::Int16
        minPerClass::Int16
        maxPerClass::Int16
    end

    function performTesting()
        INSTANCES = 
                [
                RandomInstance(5, 1, 4),        #Nmin = 6   Nmax = 9
                # RandomInstance(20, 4, 16),      #Nmin = 24  Nmax = 36
                # RandomInstance(80, 16, 64)      #Nmin = 96  Nmax = 144
                ]

        for instance in INSTANCES
            println("starting tests with instance ", instance)

            # generate random input from instance parameters
            input = genInput(instance)

            # start exec time
            start = now()

            # exec and measure solve method while passing generated input
            output = Pdp.solve(input)

            # end exec time
            elapsed = (now() - start) / Millisecond(1000)

            if functionalTest(output)
                println("Functional test passed ! (1/3 test passed)")
            else
                println("Functional test failed ! (0/3 test passed)")
                return
            end

            if qualityTest(input, output)
                println("Quality test passed ! (2/3 tests passed)")
            else
                println("Quality test failed ! (1/3 test passed)")
                return
            end

            if perfTest(input, elapsed)
                println("Performance test passed ! (3/3 tests passed)")
            else
                println("Performance test failed ! (2/3 tests passed)")
                return
            end
        end
    end

    function genInput(instance)
        MAX_DIST = 1000
        PLAN_SIZE = MAX_DIST / sqrt(2)
        TIME_CYCLE = 1679 #3h59 le lendemain
        MIN_WAITING_TIME = 5
        MAX_WAITING_TIME = 30
        MAX_RIDE_TIME = 180 #3 hours
        INF = 99999
        m = rand(instance.minPerClass:instance.maxPerClass)
        n = instance.population - m
        N = 2*n + m
        
        # generer N paires d'entiers générés dans le plan
        rands = rand(0:PLAN_SIZE, (2*N))
        coords = Array{Coord, 1}(undef, N)
        for i in 1:N
            coords[i] = Coord(rands[i], rands[i+N])
        end

        # calculer les distances entre chaque sommet et temps necessaire
        c = fill(INF, (N,N))
        t = fill(INF, (N,N))
        for i in 1:N
            for j in i+1:N
                c[i,j] = c[j,i] = Int(round(sqrt((coords[j].x-coords[i].x)^2+(coords[j].y-coords[i].y)^2)))
                t[i,j] = t[j,i] = Int(round(c[i,j] * MAX_RIDE_TIME / MAX_DIST))
            end
        end

        # calculer les temps au plus tot et au plus tard
        e = fill(0, N)
        l = fill(INF, N)
        for i in m+1:m+n
            e[i] = rand(0:TIME_CYCLE)
            l[i] = e[i] + rand(MIN_WAITING_TIME:MAX_WAITING_TIME)
        end
        for i in m+n+1:N
            l[i] = l[i-n] + rand(t[i-n,i]:t[i-n,i]+MAX_WAITING_TIME)
        end

        return Pdp.Input(m, n, c, t, e, l)
    end
    
    # check if the output is coherent
    function functionalTest(output)
        
        # check if the output is filled (not None, no errors,..)

        # verify that every taxi's route is coherent 
        # (no teleportation from one vertex to another)

        # verify that every taxi's schedule is coherent

        return true #
    end

    # check if the output quality is good based on the acceptance criteria
    # which could be, in this case, the min objective value expected to reach
    # the 5% best solutions from all combinations.
    function qualityTest(input, output)

        # store objective values of every possible solution from input

        # calculate the 5% least value

        # check if the output obj value is less or equal

        return true #
    end

    # check if the execution time is convenient based on the input size
    # and our acceptance criteria for performance
    function perfTest(input, execTime)

        # calculate expected value based on input

        # check if the exec time is less or equal

        return true #
    end

end