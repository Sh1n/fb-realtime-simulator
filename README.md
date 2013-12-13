fb-realtime-simulator
=====================

Simulator of messages coming from Facebook Realtime Updates

Usage
=====

```ruby
require './facebook_simulator.rb'
simulator = FacebookSimulator.new
simulator.verifyToken = YOUR_VERIFY_TOKEN
simulator.callbackUrl = YOUR_CALLBACK_URL
sim.simulateRealtimeUpdate(subscriptionPayload)
```
where subscriptionPayload is the payload is an hash resembling the Facebook subscription object. The method will send the JSON version.



