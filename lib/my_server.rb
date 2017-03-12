class MyServer
  include MyServer::Processors

  def initialize
    puts 'Initializing server'
    @socket = MySocket.new(nil, 5000)
    @udp_socket = MyUdpSocket.new
    @client_writers = []
    @master_reader, @master_writer = IO.pipe
    @colors = {}

    write_incoming_messages_to_child_processes
    write_incoming_udp_data
  end

  def listen
    puts 'Starting listening'
    loop { accept_connection }
  end

  private

  def accept_connection
    while (socket = @socket.accept)
      client_reader, client_writer = IO.pipe
      @client_writers << client_writer

      fork { process_binding(socket, client_reader) }
    end
  end

  def process_binding(socket, client_reader)
    nickname = read_line_from(socket)
    @colors[nickname] = String.colors.drop(1).sample
    puts "#{Process.pid}: Accepted connection from #{nickname}"

    write_messages_to_client(nickname, client_reader, socket)

    # Read incoming messages from the client.
    while (incoming_message = read_line_from(socket))
      @master_writer.puts(colorized_string(nickname, incoming_message))
    end

    puts "#{Process.pid}: Disconnected #{nickname}"
  end

  def colorized_string(nickname, incoming_message)
    "#{nickname}: #{incoming_message}".colorize(@colors[nickname])
  end
end
