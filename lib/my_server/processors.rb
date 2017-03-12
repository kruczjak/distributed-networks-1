class MyServer
  module Processors
    def write_incoming_messages_to_child_processes
      Thread.new do
        while (incoming = @master_reader.gets)
          @client_writers.each { |writer| writer.puts(incoming) }
        end
      end
    end

    def write_messages_to_client(nickname, client_reader, socket)
      Thread.new do
        while (incoming = client_reader.gets)
          unless incoming.start_with?(nickname)
            puts incoming
            socket.puts incoming
          end
        end
      end
    end

    def read_line_from(socket)
      socket.gets.chomp
    end
  end
end
