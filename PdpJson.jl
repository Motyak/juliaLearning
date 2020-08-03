module PdpJson
    using JSON      #serialization and parsing
    
    include("Pdp.jl")
    using .Pdp 

    # retourne une Input
    function parse(jsonInput)
        data = JSON.parse(jsonInput)
        m = data["m"]
        n = data["n"]
        N = 2*n+m

        c_arrOfAny = data["c"]
        c = Array{Int32, 2}(undef, N, N)
        for i = 1:N
            for j = 1:N
                c[i,j] = c_arrOfAny[i][j]
            end
        end

        t_arrOfAny = data["t"]
        t = Array{Int32, 2}(undef, N, N)
        for i = 1:N
            for j = 1:N
                t[i,j] = t_arrOfAny[i][j]
            end
        end

        e_arrOfAny = data["e"]
        e = Array{Int32}(undef, N)
        for i = 1:N
            e[i] = e_arrOfAny[i]
        end

        l_arrOfAny = data["l"]
        l = Array{Int32}(undef, N)
        for i = 1:N
            l[i] = l_arrOfAny[i]
        end

        return Pdp.Input(m, n, c, t, e, l)
    end

    # retourne un string représentatif d'une Output au format JSON
    function json(output)
        objectiveValue = JSON.json(output.objectiveValue)
        objectiveTimes = JSON.json(output.objectiveTimes)
        timestamp = JSON.json(output.timestamp)
        solveTime = JSON.json(output.solveTime)

        m, N = size(output.res, 3), size(output.res, 2)
        res = Array{Bool, 3}(undef, m, N, N)
        for k = 1:m
            for j = 1:N
                for i = 1:N
                    # on inverse l'ordre des indices car [k,j,i] => [i][j][k] en json
                    res[k,j,i] = output.res[i,j,k]
                end
            end
        end
        res = JSON.json(res)

        io = IOBuffer()
        unindentedJson = string("{\"objectiveValue\":", objectiveValue, 
                ",\"objectiveTimes\":", objectiveTimes,
                ",\"timestamp\":", timestamp, 
                ",\"solveTime\":", solveTime, 
                ",\"res\":", res, "}")
        JSON.print(io, JSON.parse(unindentedJson), 4)

        return read(seekstart(io), String)
    end

    # test unitaire
    function test()
        jsonInput = "{\"m\":2,\"n\":2,\"N\":6,\"c\":[[1000,1000,20,1000,1000,1000],[1000,1000,1000,257,1000,1000],[20,1000,1000,312,312,1000],[1000,257,1000,1000,130,140],[1000,1000,312,130,1000,1000],[1000,1000,1000,140,1000,1000]],\"t\":[[1440,1440,2,1440,1440,1440],[1440,1440,1440,31,1440,1440],[2,1440,1440,37,37,1440],[1440,31,1440,1440,16,17],[1440,1440,37,16,1440,1440],[1440,1440,1440,17,1440,1440]],\"e\":[0,0,750,825,0,0],\"l\":[2879,2879,765,840,2879,2879]}"
        input = parse(jsonInput)
        println("m = ", input.m)
        println("n = ", input.n)
        println("c = ", input.c)
        println("t = ", input.t)
        println("e = ", input.e)
        println("l = ", input.l)

        output = Pdp.solve(input)
        jsonOutput = json(output)
        println(jsonOutput)
    end
end
