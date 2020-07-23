Pour lancer le serveur julia :
	#Installation des packages julia, à faire qu'une seule fois
	$julia prerequisites.jl
	#Lancement du serveur TCP
	$bash run.sh [host ip] [port] [optimizer]
		Ex -> julia main.jl 192.168.1.13 55555 glpk
		
Pour build une custom sysimage (recommandé pour avoir de meilleures performances) :
	$bash sysimage/build.sh

Pour lancer une requête TCP au serveur avec client netcat (TUI) :
	$nc localhost 8080 < input.json > output.json
