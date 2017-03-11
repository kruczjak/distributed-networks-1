class MyClient
  def initialize(nickname, host = 'localhost', port = 5000)
    @nickname = nickname
    @host = host
    @port = port
  end

  def start
    puts "Connecting to #{@host} on port #{@port}."
    @socket = MySocket.new(host, port)
    puts 'Connected!'

    @socket.puts @nickname

    listen_server
    listen_stdin
  end

  private

  def listen_server
    Thread.new do
      while (line = @socket.gets)
        puts line.chop
      end
    end
  end

  def listen_stdin
    while (input = STDIN.gets.chomp)
      @socket.puts(input)
    end
  end
end
