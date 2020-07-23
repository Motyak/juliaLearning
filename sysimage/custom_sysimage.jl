Base.reinit_stdio()
Base.init_depot_path()
Base.init_load_path()
# Manually adding stdlib path because '@stdlib' is not working
push!(LOAD_PATH, "/opt/julia-1.4.2/share/julia/stdlib/v1.4")

# using JuMP
# using GLPK
# using JSON
# using Dates
# using Sockets

include("../Solver.jl")
include("../Pdp.jl")
include("../PdpJson.jl")
include("../Tcp.jl")
using .Solver
using .Pdp
using .PdpJson
using .Tcp

@eval Module() begin
    for (pkgid, mod) in Base.loaded_modules
        if !(pkgid.name in ("Main", "Core", "Base"))
            eval(@__MODULE__, :(const $(Symbol(mod)) = $mod))
        end
    end
    for statement in readlines("sysimage/precompile.jl")
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
