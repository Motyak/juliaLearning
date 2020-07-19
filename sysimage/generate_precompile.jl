include("../Pdp.jl")
include("../PdpJson.jl")
include("../Tcp.jl")
using Sockets   #@ip_str, ip string literal used in Server ctor
using .Pdp
using .PdpJson
using .Tcp
#Pdp.test()
PdpJson.test()
#Tcp.test()

#Tcp.launch(Tcp.Server(ip"127.0.0.1", 8080, x -> PdpJson.json(Pdp.solve(PdpJson.parse(x)))))
