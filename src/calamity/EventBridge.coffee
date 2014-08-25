# # EventBridge
#
# Addresses used by Calamity to communicate with bridges:
#
# * `bus.subscribe`
# * `bus.unsubscribe`
# * `bus.publish`
# * `bus.send`
#
# These will all supplied the following data:
#
# * For all:
#    * `bus`
# * For `bus.subscribe` and `bus.unsubscribe`@
#    * `subscription`
# * For `bus.publish` and `bus.send`:
#    * `message`
#
EventBridge = class Calamity.EventBridge
	Calamity.emitter @prototype

	constructor: ->
		# Nothing special here at the moment.
