require_relative 'facebook_simulator.rb'

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

puts "==========================="
puts "    Facebook Simulator"
puts "==========================="
sim = FacebookSimulator.new
sim.debug = true
sim.verify_token = VERIFY_TOKEN
sim.callback_url = CALLBACK_URL
sim.simulate_realtime_update(payload)
