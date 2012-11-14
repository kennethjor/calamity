# # EventBridge
# Bridge for transfering events between two `EventBus` instances.
EventBridge = class C.EventBridge
	# Constructor.
	constructor: () ->
		@_busses = []
		return

	# ## `connect()`
	# Connects this bridge to an event bus.
	connect: (bus) ->
		# Add to internal list.
		@_busses.push bus
		# Register handler on bus.
		bus.subscribe "*", _.bind(@handler, @)

		return @

	# ## `handler()`
	# Default noop handler.
	handler: (msg) ->
		return
