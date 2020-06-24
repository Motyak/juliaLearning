using Sockets

function process()
    return "bonjour"
end

server = listen(8080)
while true
  conn = accept(server)
  @async begin
    try
        println(process())
    catch err
      print("connection ended with error $err")
    end
  end
end

