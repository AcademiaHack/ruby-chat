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
          unless available_nick nick
            client.puts 'Nick already exists'
            client.close
            Thread.kill self
          end

          puts "#{nick} -> #{client}"
          @clients[nick] = client
          client.puts 'Connected'

          client_listener nick, client
        end
    }

  end

  private

  def available_nick nick
    !@clients.has_key? nick
  end

  def client_listener nick, client
    loop do
      puts 'jodeeer'
      message = client.gets.chomp
      puts "#{nick} say: #{message}"

      @clients.each do |key, client|
        client.puts "#{nick}: #{message}" unless nick==key
      end
    end
  end

end

Server.new(2000).run
