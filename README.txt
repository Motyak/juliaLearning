Pour lancer le serveur julia :
	#Installation des packages julia, à faire qu'une seule fois
	$julia prerequisites.jl
	#Lancement du serveur TCP sans sysimage
	$julia main.jl [ip] [port] [optimizer]
		Ex -> julia main.jl 192.168.1.13 55555 glpk
	#(Optionnel)Pour build la sysimage avec tous les paquets précompilés, à faire qu'une seule fois
	$bash sysimage/build.sh
	#Lancement du serveur TCP avec la sysimage (nécessite de l'avoir build au préalable)
	$julia -J sysimage/sys.so main.jl [ip] [port] [optimizer]


Pour lancer une requête TCP au serveur avec client netcat (TUI) :
	$nc localhost 8080 < input.json > output.json
