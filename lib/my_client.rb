class MyClient

  CUSTOM_COMMANDS = {
    'M' => :send_ascii,
    'N' => :send_ascii_multicast,
  }.freeze
  ASCII_ART = <<ASCII_END
                       .-.
                      |_:_|
                     /(_Y_)\
                    ( \/M\/ )
 '.               _.'-/'-'\-'._
   ':           _/.--'[[[[]'--.\_
     ':        /_'  : |::"| :  '.\
       ':     //   ./ |oUU| \.'  :\
         ':  _:'..' \_|___|_/ :   :|
           ':.  .'  |_[___]_|  :.':\
            [::\ |  :  | |  :   ; : \
             '-'   \/'.| |.' \  .;.' |
             |\_    \  '-'   :       |
             |  \    \ .:    :   |   |
             |   \    | '.   :    \  |
             /       \   :. .;       |
            /     |   |  :__/     :  \\
           |  |   |    \:   | \   |   ||
          /    \  : :  |:   /  |__|   /|
      snd |     : : :_/_|  /'._\  '--|_\
          /___.-/_|-'   \  \
                         '-'
ASCII_END

  def initialize(nickname, host = 'localhost', port = 5000)
    @nickname = nickname
    @host = host
    @port = port
  end

  def start
    puts "Connecting to #{@host} on port #{@port}."
    @socket = MySocket.new(@host, @port)
    @udp_socket = UDPSocket.new
    @udp_socket.send(@nickname, 0, @host, @port)
    puts 'Connected!'

    @socket.puts(@nickname)

    listen_server
    listen_udp_response
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

  def listen_udp_response
    Thread.new do
      puts 'starting listening udp response'
      while (incoming = @udp_socket.gets)
        puts incoming.chop
      end
    end
  end

  def listen_stdin
    while (input = STDIN.gets.chomp)
      CUSTOM_COMMANDS[input] ? self.send(CUSTOM_COMMANDS[input]) : @socket.puts(input)
    end
  end

  def send_ascii
    @udp_socket.send(ASCII_ART, 0, @host, @port)
  end

  def send_ascii_multicast
    @udp_socket.send(ASCII_ART, 0, @host, @port)
  end
end
