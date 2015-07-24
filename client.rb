require 'socket'

class Client

  def initialize host, port
    @host = host
    @port = port
  end

  def start
    @server = TCPSocket.open @host, @port

    setup
  end

  private

  def setup
    @out = Thread.new do
      loop do        
        puts "#{@server.gets.chomp}"
      end
    end

    puts "Nick:"
    @in = Thread.new do
      loop do
        @server.puts $stdin.gets.chomp
      end
    end

    @out.join
    @in.join
  end

end

Client.new('localhost', 2000).start
#http://stackoverflow.com/questions/10523536/whats-the-difference-between-gets-chomp-vs-stdin-gets-chomp

#gets.chomp() = read ARGV first
#STDIN.gets.chomp() = read user's input
