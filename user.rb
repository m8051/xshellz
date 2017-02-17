require 'httparty'
require 'json'

class User

  attr_reader :message

  def initialize(api, user, met="shellexpires")
    @api = api
    @user = user
    @met = met

    request
  end

  def request
    response = HTTParty.get("#{@api}#{@user}/#{@met}")
    @message = response.parsed_response["msg"]
  end
  def to_s
    "#{@message}"
  end
end

if __FILE__ == $0
  # shellexpires, shellactive, location, approved, status, joined
  user = User.new("https://www.xshellz.com/api/json/", "crawler", "shellexpires")
  puts user.message
end