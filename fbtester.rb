require 'json'
require 'securerandom'
require 'restclient'

# =================================================================
# userId represents the User whose subscription entry is arriving 
# =================================================================
userId = ""

# =================================================================
# Application ID
# =================================================================
APP_ID = ""

# =================================================================
# Application Secret
# =================================================================
APP_SECRET = ""

# =================================================================
# Verification Token
# =================================================================
VERIFY_TOKEN = "TEST-BEANCOUNTER-FACEBOOK"

# =================================================================
# Callback Url: requests will be sent to this address
# =================================================================
CALLBACK_URL = "http://0.0.0.0:34567/facebook"

# =============================================
# Hash of the payload sent to the user
# =============================================
payload = {:object => "user", :entry => [{:uid => userId, :id => userId, :time => Time.now.to_f, :changed_fields => ["likes"]}]}

puts "Facebook RealTime Update Tester"
puts payload.to_json

#
# Verification
#
hub = {
	"verify_token" => VERIFY_TOKEN,
	"mode" => "subscribe",
	"challenge" => SecureRandom.hex()
}
puts "Sending Verification" 
puts hub
begin
	response = RestClient.get CALLBACK_URL, hub
	if response.code == 200 && response.to_str == hub[:challenge]
		puts "Verification Ok"
		puts "Sending Stream"
		# Streaming
		response = RestClient.put CALLBACK_URL,  payload.to_json, :content_type => :json
		puts "Streaming: [" + response.code.to_str + "] " + response.to_str
	else
		puts "Received " + response.code.to_str
		puts response.to_str
	end
rescue
	puts "Address not reachable"
end
	# Send GET -> hub.verify_token = $, hub.mode -> "subscribe" -> expects $(hub.challenge)


# Streaming
