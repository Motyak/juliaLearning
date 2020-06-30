server = listen(8080)
while true
  conn = accept(server)
  @async begin
    try
      while true
        line = readline(conn)
        if !isempty(line)
          firstValue = JSON.parse(line)[1]
          println(firstValue)
          write(conn, JSON.json(firstValue))
        end
      end
    catch err
      print("connection ended with error $err")
    end
  end
end
