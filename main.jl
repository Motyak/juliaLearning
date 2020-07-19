println("Pdp.jl")
@time include("Pdp.jl")
println("\nPdpJson.jl")
@time include("PdpJson.jl")
println("\nTcp.jl")
@time include("Tcp.jl")
println("\nusing Sockets")
@time using Sockets   #@ip_str, ip string literal used in Server ctor
println("\nusing pdp")
@time using .Pdp
println("\npdpjson")
@time using .PdpJson
println("\ntcp")
@time using .Tcp
println("\npdp test")
#@time Pdp.test()
#PdpJson.test()
#Tcp.test()

Tcp.launch(Tcp.Server(ip"127.0.0.1", 8080, x -> PdpJson.json(Pdp.solve(PdpJson.parse(x)))))
