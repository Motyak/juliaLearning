Pour lancer le serveur julia sous localhost:8080 :
#Installation des packages julia, à faire qu'une seule fois par machine
$include("prerequisites.jl")
#Chargement des modules julia, à faire à chaque redémarrage de serveur
$include("init.jl")
#Lancement du serveur TCP en question
$include("tcpServer.jl")


Pour lancer une requête TCP au serveur avec client netcat (TUI) :
$nc localhost 8080 < input.json > output.json
