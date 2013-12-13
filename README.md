fb-realtime-simulator
=====================

Simulator for messages coming from Facebook Realtime Updates

Usage
=====

```ruby
require './facebooksimulator.rb'
simulator = FacebookSimulator.new
simulator.verifyToken = YOUR_VERIFY_TOKEN
simulator.callbackUrl = YOUR_CALLBACK_URL
sim.simulateRealtimeUpdate(subscriptionPayload)
```
where subscriptionPayload is the payload is an hash resembling the Facebook subscription object. The method will send the JSON version.



