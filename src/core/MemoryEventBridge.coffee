# EventBridge implementation which ties to EventBuses together in memory.
MemoryEventBridge = class C.MemoryEventBridge extends EventBridge
	# Attaches this bridge to another bus.
	attach: (@otherBus) ->
		return
