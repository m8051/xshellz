require 'yaml'
require 'socket'

class XshellZ

  attr_reader :server, :port, :username
  attr_accessor :channel, :message
  
  def initialize(server, port, username)
    # Instance variables
    @server = server
    @port = port
    @username = username
    @socket
      
    # let's call the connect method by the time the object is instantiate 
    connect
  end

  def connect
    @socket = TCPSocket.open(@server, @port)
    #print("addr: ", @socket.addr.join(":"), "\n")
    #print("peer: ", @socket.peeraddr.join(":"), "\n")
    @socket.puts "NICK  #{@username}"
    @socket.puts "USER  #{@username} 0 * :#{@username}"
  end

  def channel=(channel)
  	@channel = channel
  end

  def join_channel
    @socket.puts "JOIN #{@channel}"
  end

  def message=(message)
  	@message = message
  end

  def send_msg
    @socket.puts "PRIVMSG #{@channel} :#{@message}"
    while line = @socket.gets
      puts line.chop
      if line.match(/End of \/NAMES list/)
        puts "Closing client socket"
        @socket.puts "QUIT Disconnecting ..."
      end
    end
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


# Running BotXshellZ
client = XshellZ.new(server, port, username)

trap("INT"){ client.disconnect }

# Setting the channel writter attribute
client.channel = "#tjt"

# Joinning the channel
client.join_channel

# Setting the message writter attribute
client.message = "!keep #{username}"

# Sending the message to the channel
client.send_msg

# Closing the socket nicely
client.disconnect
