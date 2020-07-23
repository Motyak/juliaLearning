module Tcp
	using Sockets

	struct Server
		host::IPAddr
		port::Int32
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
					println("Waiting for input..")
					msg = ""
					endOfStream = false
					while !endOfStream
						msg = msg * readline(conn)
						endOfStream = (isempty(msg) || msg[begin] != '{' || msg[end] == '}')
					end
					println("Processing input..")
					output = server.process(msg)
					println("Sending back output to client..")
					write(conn, output)
					close(conn)
					println("Connection closed.\n")
				catch err
					print("Connection ended with error $err")
					close(conn)
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
