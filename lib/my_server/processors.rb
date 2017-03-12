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
          unless incoming.uncolorize.start_with?(nickname)
            puts incoming
            socket.puts incoming
          end
        end
      end
    end

    def write_incoming_udp_data
      Thread.new do
        while (incoming = @udp_socket.recvfrom)
          unless @clients_udp.key?(incoming[1][1])
            @clients_udp[incoming[1][1]] = incoming[0]
            puts "Initialized #{incoming[0]} as port #{incoming[1][1]}"
            next
          end

          puts "Received\n#{incoming[0]}\nfrom #{incoming[1]}"

          @clients_udp.each do |port_number, _|
            next if port_number == incoming[1][1]

            @udp_socket.udp_send(
              colorized_string(@clients_udp[incoming[1][1]], incoming[0]),
              0,
              incoming[1][2],
              port_number,
            )
          end
        end
      end
    end

    def read_line_from(socket)
      socket.gets.chomp
    end
  end
end
