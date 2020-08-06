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
		shouldContinue = true
		@async begin
			readline()
			println("Server interruption sent")
			shouldContinue = false
			connect(server.port)
		end
		while shouldContinue
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
				catch err
					println("An error occured : $err")
				finally
					close(conn)
					println("Connection closed.\n")
				end
			end
		end
		println("Server stopped")
		close(socket)
	end

	# test unitaire
	function test()
		server = Server(ip"127.0.0.1", 8080, x -> uppercase(x))
		launch(server)
	end
end
