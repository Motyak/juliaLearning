Pour lancer le serveur julia sous localhost:8080 :
#Installation des packages julia, à faire qu'une seule fois par machine
$include("prerequisites.jl")
#Lancement du serveur TCP en question
$include("main.jl")


Pour lancer une requête TCP au serveur avec client netcat (TUI) :
$nc localhost 8080 < input.json > output.json
