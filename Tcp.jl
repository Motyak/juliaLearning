module Tcp
	using Sockets

	struct Server
		host::IPAddr
		port::Int16
		process::Function
	end

	function launch(server)
		println("Launching TCP server..")
		socket = listen(server.host, server.port)
		println("Listening on ", server.host, ":", server.port, "..\n")
		while true
			println("Waiting for a connection..")
			conn = accept(socket)
			println("Connection accepted : ", conn)
			@async begin
				try
					while true
						println("Waiting for input..")
						line = readline(conn)
						if !isempty(line)
							println("Processing input..")
							output = server.process(line)
							println("Sending back output to client..")
							write(conn, output)
						end
						close(conn)
						println("Connection closed.\n")
						break
					end
				catch err
					print("Connection ended with error $err")
				end
			end
		end
	end

	# test unitaire
	function test()
		server = Server(ip"127.0.0.1", 8080, x -> uppercase(x))
		launch(server)
	end
end