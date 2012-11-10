# EventBridge implementation which ties to EventBuses together in memory.
MemoryEventBridge = class C.MemoryEventBridge extends EventBridge
	# Repeating handler implementation.
	handler: ->
		for bus in @busses
			bus.publish msg.address, msg
		return
