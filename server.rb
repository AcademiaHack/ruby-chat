require 'socket'

class Server
  def initialize port
    @server = TCPServer.open port
    @clients = Hash.new
  end

  def run

    loop {
        Thread.start(@server.accept) do |client|
          nick = client.gets.chomp.to_sym
          unless take_nick nick, client
            Thread.kill self
          end
          client_listener nick, client
        end
    }

  end

  private

  def take_nick nick, client
    if value = (!@clients.has_key? nick)
      @clients[nick] = client
      puts "#{nick} -> #{client}"
      client.puts 'Connected'
    else
      client.puts 'Nick already exists'
      client.close
    end
    value
  end

  def client_listener nick, client
    puts 'In client loop'
    loop do
      message = client.gets.chomp
      puts "#{nick} say: #{message}"

      @clients.each do |key, client|
        client.puts "#{nick}: #{message}" unless nick==key
      end
    end
  end

end

Server.new(2000).run
