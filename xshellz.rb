require 'yaml'
require 'socket'

class XshellZ
	
  def initialize(server, port, username)
    # instance variables
    @server = server
    @port = port
    @username = username
    @socket
      
    # let's call the connect method
    connect
  end

  def connect
    @socket = TCPSocket.open(@server, @port)
    #print("addr: ", @socket.addr.join(":"), "\n")
    #print("peer: ", @socket.peeraddr.join(":"), "\n")
    @socket.puts "USER  #{@username} 0 * #{@username}"
    @socket.puts "NICK #{@username}"
  end

  def join_channel(channel)
    @socket.puts "JOIN #{channel}"
  end

  def send_msg(channel, message)
    while line = @socket.gets
      puts line.chop
      @socket.puts "PRIVMSG #{channel} :#{message}"
      if line.match(/End of \/NAMES list/)
        puts "Closing client socket"
        @socket.puts "QUIT Disconnecting ..."
      end
    end
    @socket.close
  end

  def disconnect
    @socket.close
  end

end

# -------------------------------------
# MAIN CODE
# -------------------------------------

# Reading settings from YML
settings = YAML.load_file('account.yml')
server = settings['xshellz']['server']
port = settings['xshellz']['port']
username = settings['xshellz']['username']
channel = settings['xshellz']['channel']


# Running BotXshellZ
client = XshellZ.new(server, port, username)
trap("INT"){ client.disconnect }
client.join_channel(channel)
message = "!keep #{username}"
client.send_msg(channel, message)
