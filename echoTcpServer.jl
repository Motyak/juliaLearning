using Sockets
server = listen(8080)
while true
  conn = accept(server)
  @async begin
    try
      while true
        line = readline(conn)
        write(conn,line)
      end
    catch err
      print("connection ended with error $err")
    end
  end
end