Installation:

	Prerequisites:
		julia (developped for julia 1.4.2)
		(OPTIONNAL)gcc (can be found in build-essential package)

	Setup:
		1. julia packages installation, to do once :
		$julia prerequisites.jl

		2. (OPTIONNAL) building the custom sysimage, to do once :
		$bash sysimage/build.sh

Usage:

	To launch the server, simply execute :
	$bash run.sh [host ip] [port] [optimizer]
		Ex -> bash run.sh 192.168.1.1 55555 glpk

	To send a TCP request to the server, you can use any TCP client :
	$nc localhost 8080 < json/input.json > json/output.json

	To stop the server, you can either press 'ENTER' (recommended) or interrupt
	the process with ctrl+c.
