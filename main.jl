println("\nusing Sockets")
@time using Sockets   #@ip_str, ip string literal

println("Solver.jl")
@time include("Solver.jl")
println("Pdp.jl")
@time include("Pdp.jl")
println("\nPdpJson.jl")
@time include("PdpJson.jl")
println("\nTcp.jl")
@time include("Tcp.jl")
println("\nusing solver")
@time using .Solver
println("\nusing pdp")
@time using .Pdp
println("\npdpjson")
@time using .PdpJson
println("\ntcp")
@time using .Tcp


# println("\npdp test")
# @time Pdp.test()
# println("\npdpjson test")
# @time PdpJson.test()
# println("\ntcp test")
# @time Tcp.test()


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
