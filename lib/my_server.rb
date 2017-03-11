class MyServer
  include MyServer::Processors

  def initialize
    @socket = MySocket.new
    @client_writers = []
    @master_reader, @master_writer = IO.pipe

    write_incoming_messages_to_child_processes
  end

  def listen
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
    puts "#{Process.pid}: Accepted connection from #{nickname}"

    write_messages_to_client(nickname, client_reader, socket)

    # Read incoming messages from the client.
    while (incoming_message = read_line_from(socket))
      @master_writer.puts "#{nickname}: #{incoming_message}"
    end

    puts "#{Process.pid}: Disconnected #{nickname}"
  end
end
