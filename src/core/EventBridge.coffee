# The `EventBridge` is responsible for transfering events between two EventBuses.
EventBridge = class C.EventBridge
	# Constructor.
	constructor: () ->
		@busses = []
		return

	# Connects this bridge to an event bus.
	connect: (bus) ->
		# Add to internal list.
		@busses.push bus
		# Register handler on bus.
		bus.subscribe "*", _.bind(@handler, @)

		return @

	# Default noop handler.
	handler: ->
		return
