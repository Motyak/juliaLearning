LOAD_PATH = String[]
DEPOT_PATH = String[]
Base.reinit_stdio()
Base.init_depot_path()
Base.init_load_path()

using JuMP      #ilp/mip model
using GLPK      #optimizer
using JSON      #serialization and parsing

@eval Module() begin
    for (pkgid, mod) in Base.loaded_modules
        if !(pkgid.name in ("Main", "Core", "Base"))
            eval(@__MODULE__, :(const $(Symbol(mod)) = $mod))
        end
    end
    for statement in readlines("sysimage/generate_precompile.jl")
        try
            Base.include_string(@__MODULE__, statement)
        catch
            # See julia issue #28808
            @info "failed to compile statement: $statement"
        end
    end
end # module

empty!(LOAD_PATH)
empty!(DEPOT_PATH)
