Pour lancer le serveur julia sous localhost:8080 :
	#Installation des packages julia, à faire qu'une seule fois par machine
	$julia prerequisites.jl
	#Pour build la librairie avec tous les paquets précompilés
	$bash sysimage/build.sh
	#Lancement du serveur TCP en question
	$julia -J sysimage/sys.so main.jl

Pour lancer une requête TCP au serveur avec client netcat (TUI) :
	$nc localhost 8080 < input.json > output.json
