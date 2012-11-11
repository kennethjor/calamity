# EventBridge implementation which ties to EventBuses together in memory.
MemoryEventBridge = class C.MemoryEventBridge extends EventBridge
	# Repeating handler implementation.
	handler: (msg) ->
		# Pass msg onto all connected busses
		for bus in @_busses
			bus.publish msg.address, msg
		return
