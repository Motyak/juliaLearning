module Test

    include("../Pdp.jl")
    using .Pdp

    using Dates
    using Random

    # mutable struct Test
    #     input::Pdp.Input
    #     output::Pdp.Output
    #     execTime::Float32
    #     functionnalPassed::Bool
    #     qualityPassed::Bool
    #     perfPassed::Bool
    #     Test() = new(missing, missing, 999.9, false, false, false)
    # end

    struct RandomInstance
        population::Int16
        minPerClass::Int16
        maxPerClass::Int16
    end

    function performTesting()
        INSTANCES = 
                [RandomInstance(5, 1, 4)
                ,RandomInstance(20, 4, 16)
                ,RandomInstance(80, 16, 64)]

        # for instance in INSTANCES
        instance = "onsenfout"

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
                println("Functional test passed ! (1/1 test passed)")
            else
                println("Functional test failed ! (0/1 test passed)")
                return
            end

            if qualityTest(output)
                println("Quality test passed ! (2/2 tests passed)")
            else
                println("Quality test failed ! (1/2 test passed)")
                return
            end

            if perfTest(output)
                println("Performance test passed ! (3/3 tests passed)")
            else
                println("Performance test failed ! (2/3 tests passed)")
                return
            end
        # end
    end

    function genInput(instance)
        MAX_DIST = 1000
        MAX_TIME = 1679 #3h59 le lendemain
        MIN_WAITING_TIME = 5
        MAX_WAITING_TIME = 30
        MIN_RIDE_TIME = 5
        MAX_RIDE_TIME = 180 #3 hours
        INF = 99999
        m = rand(instance.minPerClass:instance.maxPerClass)
        n = instance.population - m
        N = 2*n + m
        c = Array{Int32,2}(undef, N, N)
        for i in 1:N
            c[i,i] = INF
            for j in i+1:N
                c[i,j] = rand(0:MAX_DIST)
                c[j,i] = c[i,j]
            end
        end
        t = c
        e = Array{Int32}(undef, N)
        l = Array{Int32}(undef, N)
        for i in 1:m
            e[i] = 0
            l[i] = INF
        end
        for i in m+1:m+n
            e[i] = rand(0:MAX_TIME)
            l[i] = e[i] + rand(MIN_WAITING_TIME:MAX_WAITING_TIME)
        end
        for i in m+n+1:N
            e[i] = 0
            l[i] = e[i-n] + rand(MIN_RIDE_TIME:MAX_RIDE_TIME)
        end
        # println(m)
        # println(n)
        # println(c)
        # println(t)
        # println(e)
        # println(l)
        return Pdp.Input(m, n, c, t, e, l)
    end
    
    function functionalTest(output)
        # check if the output is coherent

    end

    function qualityTest(output)
        # check if the output quality is good
    end

end