require 'securerandom'
require 'restclient'
require 'json'

class FacebookSimulator
	
	attr_accessor :verify_token, :callback_url, :app_secret, :app_id, :debug  
	attr_reader :challenge

	def simulate_realtime_update(payload)
		@challenge = SecureRandom.hex()
		hub = {
			:params => {
				"hub.verify_token" => @verify_token,
				"hub.mode" => "subscribe",
				"hub.challenge" => @challenge
			}
		}
		if @debug
			puts "Hub Payload: " + hub.to_s
		end
		begin
			if @debug
				puts "Sending Verification to: " + @callback_url.to_s
			end
			response = RestClient.get @callback_url, hub
			if response.code == 200 and response == @challenge
				if @debug
					puts "Verification response: [" + response.code.to_s + "] " + response
					puts "Sending Stream: " + payload.to_s
				end
				# Streaming
				response = RestClient.post @callback_url,  payload.to_json, :content_type => :json
				if @debug
					puts "Received: [code." + response.code.to_s + "] " + response
				end
				return true
			else
				if @debug
					puts "Received: [code." + response.code.to_s + "] " + response
				end
				return false
			end
		rescue Exception => e  
			puts e.message  
		  	puts e.backtrace.inspect
		end
	end
end
