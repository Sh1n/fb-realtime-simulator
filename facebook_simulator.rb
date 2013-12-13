require 'securerandom'
require 'restclient'

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
