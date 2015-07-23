require 'socket'

class Client

  def initialize host, port
    @host = host
    @port = port
  end

  def start
    @server = TCPSocket.open @host, @port
    thread_listener
    thread_send

    @response.join
    @request.join
  end

  private

  def thread_listener
    @response = Thread.new do
      loop do
        puts @server.gets.chomp
      end
    end
  end

  def thread_send
    puts "Nick:"
    @request = Thread.new do
      loop do
        @server.puts $stdin.gets.chomp
      end
    end

  end

end

Client.new('localhost', 2000).start
#http://stackoverflow.com/questions/10523536/whats-the-difference-between-gets-chomp-vs-stdin-gets-chomp

#gets.chomp() = read ARGV first
#STDIN.gets.chomp() = read user's input
