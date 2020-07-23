
using Sockets   #@ip_str, ip string literal
include("../Solver.jl")
include("../Pdp.jl")
include("../PdpJson.jl")
include("../Tcp.jl")
using .Solver
using .Pdp
using .PdpJson
using .Tcp

host, port, optimizer = ip"127.0.0.1", 8080, Solver.GLPK
if length(ARGS) > 1
    host = IPv4(ARGS[1])
    port = parse(Int32, ARGS[2])
end
if length(ARGS) > 2 && haskey(Solver.MAP, lowercase(ARGS[3]))
    optimizer = Solver.getValue(lowercase(ARGS[3]))
end

Tcp.launch(
    Tcp.Server(
        host, 
        port, 
        x -> PdpJson.json(
            Pdp.solve(
                PdpJson.parse(x), 
                optimizer
            )
        )
    )
)
