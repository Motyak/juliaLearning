module Solver
    @enum ENUM begin
        GLPK
        CPLEX
    end

    MAP = Dict{String, ENUM}("glpk" => GLPK, "cplex" => CPLEX)

    function getValue(str)
        if !haskey(MAP, str)
            throw(KeyError(str))
        end
        return get(MAP, str, -1)
    end

    function getString(value)
        if !isa(value, ENUM)
            throw(TypeError(value))
        end
        for (k, v) in pairs(MAP)
            if v == value
                return k
            end
        end
    end

    function test()
        a = getValue("glpk")
        println(a, ",", typeof(a))
        if a == GLPK
            println("houra")
        end
        # b = getValue("gLpK") #err
        c = getString(CPLEX)
        println(c)
        # d = getString(EXISTEPAS) #err
    end
end