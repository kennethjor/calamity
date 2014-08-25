# # Bridge
# Allows multiple busses to be linked together.
Bridge = class Calamity.Bridge
	_busses: null
	_seen: null
	_cleanId: null

	constructor: (busses...) ->
		@_seen = []
		@_busses = busses
		for bus in busses
			@subscribeBus bus
		return

	# Subscribes to all messages on the bus
	subscribeBus: (bus) ->
		bus.subscribe "*", do (bus) => (msg) => @handle bus, msg
		return

	# Handles a single message.
	# Bus is the event bus instance which the message came from.
	# The default implementation sends the message to all other busses.
	handle: (bus, msg) ->
		return if @seen msg
		for b in @_busses
			unless b is bus
				b.publish msg
		return

	# Returns true if the supplied message has been seen previously.
	# Unless `save` is set to false, the message will be saved as seen.
	seen: (msg, save=true) ->
		for entry in @_seen
			if entry.id is msg.id
				return true
		# Message not seen, save it.
		if save
			@_seen.push
				id: msg.id,
				time: new Date().getTime()
			@scheduleClean()
		return false

	# Schedules a cleanout of the seen messages.
	scheduleClean: ->
		return if @_cleanId
		@_cleanId = setTimeout
		_.delay (=>
			seen = @_seen
			limit = new Date().getTime() - 100
			i = 0
			while i < seen.length
				if seen[i].time < limit
					seen.splice i, 1
				else
					i++
			return
		), 100