# The EventProxy is a mixin class used to attach global EventBus handling to objects.
# This exposes the subscribe and publish methods from the EventBus,
# but automatically sets the context of any handler to this.
EventProxy = class C.EventProxy
# Register a handler to an address.
	subscribe: (address, handler) ->
		EventBus.subscribe address, handler, @

	# Publishes an event to an address.
	publish: (address, data) ->
		EventBus.publish address, data
