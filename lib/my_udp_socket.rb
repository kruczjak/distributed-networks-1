require 'socket'
require 'forwardable'

class MyUdpSocket
  extend Forwardable

  def_delegator :@socket, :close, :gets

  def initialize(host = 'localhost', port = 5000)
    @socket = UDPSocket.new
    @socket.bind(host, port)
  end

  # returns data, addr
  def recvfrom
    @socket.recvfrom(1024*1024)
  end

  def udp_send(data, flags, host, port)
    puts "Sending udp data to #{host}:#{port}"
    @socket.send(data, flags, host, port)
  end
end