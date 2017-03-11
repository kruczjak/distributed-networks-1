require 'socket'

class MySocket
  extend Forwardable

  def initialize(host = 'localhost', port = 5000)
    @socket = TCPServer.open(host, port)
  end

  def gets
    p 'Locking on gets' if $DEBUG
    @socket.gets
  end

  def puts(input)
    p 'Locking on puts' if $DEBUG
    @socket.puts(input)
  end
end
