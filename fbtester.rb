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
CALLBACK_URL = "http://192.168.10.10:34567/facebook"

# =============================================
# Hash of the payload sent to the user
# =============================================
payload = {:object => "user", :entry => [{:uid => userId, :id => userId, :time => Time.now.to_f, :changed_fields => ["likes"]}]}

class FacebookSimulator
	
	attr_accessor :verifyToken, :callbackUrl, :appSecret, :appId, :appSecret, :debug  
	attr_reader :challenge

	def simulateRealtimeUpdate(payload)
		@challenge = SecureRandom.hex()
		hub = {
			:params => {
				"hub.verify_token" => @verifyToken,
				"hub.mode" => "subscribe",
				"hub.challenge" => @challenge
			}
		}
		if @debug
			puts "Hub Payload: " + hub.to_s
		end
		begin
			if @debug
				puts "Sending Verification to: " + @callbackUrl.to_s
			end
			response = RestClient.get @callbackUrl, hub
			if response.code == 200 and response == @challenge
				if @debug
					puts "Verification response: [" + response.code + "] " + response
					puts "Sending Stream: " + payload.to_s
				end
				# Streaming
				response = RestClient.put @callbackUrl,  payload.to_json, :content_type => :json
				if @debug
					puts "Received: [code." + response.code + "] " + response
				end
				return true
			else
				if @debug
					puts "Received: [code." + response.code + "] " + response
				end
				return false
			end
		rescue Exception => e  
			puts e.message  
		  	puts e.backtrace.inspect
		end
	end
end

puts "==========================="
puts "    Facebook Simulator"
puts "==========================="
sim = FacebookSimulator.new
sim.debug = true
sim.verifyToken = VERIFY_TOKEN
sim.callbackUrl = CALLBACK_URL
sim.simulateRealtimeUpdate(payload)