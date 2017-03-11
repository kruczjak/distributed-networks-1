module MyServer
  module Processors
    def read_line_from(socket)
      socket.gets.chomp
    end
  end
end
