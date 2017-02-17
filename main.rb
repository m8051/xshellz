require_relative 'xshellz'
require_relative 'user'
require 'ruby-progressbar'


# Let's instantiate from the class User an object user that gets by default when the shell expires
user = User.new("https://www.xshellz.com/api/json/", "crawler", "shellexpires")
hours_to_expire = user.message

# Reading settings from YML
settings = YAML.load_file('account.yml')
server = settings['xshellz']['server']
port = settings['xshellz']['port']
username = settings['xshellz']['username']
renew = settings['xshellz']['renew']


puts "-----------------------------------"
puts " Running xshellz bot | Hours #{hours_to_expire}"
puts "-----------------------------------"

#puts "Account: #{username}"
#puts "Hours: #{hours_to_expire}" 

# The shell expires in 2 weeks which is 336 hours, so let's renew the shell every 84 hours
if hours_to_expire <= renew
  
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

end