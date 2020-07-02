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
        c = Array{UInt16, 2}(undef, N, N)
        for i = 1:N
            for j = 1:N
                c[i,j] = c_arrOfAny[i][j]
            end
        end

        return Pdp.Input(m, n, c)
    end

    # retourne un string représentatif d'une Output au format JSON
    function json(output)
        objectiveValue = JSON.json(output.objectiveValue)
        timestamp = JSON.json(output.timestamp)
        solveTime = JSON.json(output.solveTime)

        m, N = size(output.res, 3), size(output.res, 2)
        println("m, n = ", m, ", ", N)
        res = Array{Bool, 3}(undef, m, N, N)
        for k = 1:m     #nb de dimensions
            for j = 1:N
                for i = 1:N
                    # on inverse l'ordre des indices car [k,j,i] => [i][j][k] en json
                    res[k,j,i] = output.res[i,j,k]
                end
            end
        end
        res = JSON.json(res)

        return string("{\"objectiveValue\":", objectiveValue, 
        ",\"timestamp\":", timestamp, 
        ",\"solveTime\":", solveTime, 
        ",\"res\":", res, "}")
    end

    # test unitaire
    function test()
        jsonInput = "{\"m\":2,\"n\":2,\"c\":[[10000,10000,20,10000,10000,10000],[10000,10000,10000,257,10000,10000],[20,10000,10000,312,312,10000],[10000,257,10000,10000,130,140],[10000,10000,312,130,10000,10000],[10000,10000,10000,140,10000,10000]]}"
        input = parse(jsonInput)
        println("m = ", input.m)
        println("n = ", input.n)
        println("c = ", input.c)

        output = Pdp.solve(input)
        jsonOutput = json(output)
        println(jsonOutput)
    end
end