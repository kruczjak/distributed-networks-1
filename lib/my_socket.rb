require 'socket'
require 'forwardable'

class MySocket
  extend Forwardable

  def_delegator :@socket, :accept

  def initialize(host = 'localhost', port = 5000)
    @socket = (host ? TCPSocket.open(host, port) : TCPServer.open(port))
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
