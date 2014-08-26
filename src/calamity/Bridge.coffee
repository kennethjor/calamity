# # Bridge
# Allows multiple busses to be linked together.
Bridge = class Calamity.Bridge
	# The number of miliseconds to remember seen messages for.
	SEEN_TIME: 500
	# All busses connected by thisbcridge.
	_busses: null
	# A temporary record of all messages seen.
	_seen: null
	# The timeout ID of the next cleaning of seen messages.
	_cleanId: null

	constructor: (busses...) ->
		@_seen = {}
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
	seen: (msg, save = true) ->
		# Returns true if message has been seen and its time limit is within the bounds.
		limit = new Date().getTime() - @SEEN_TIME
		time = @_seen[msg.id]
		if time? and time > limit
			return true
		# Message not seen, save it.
		if save
			@_seen[msg.id] = new Date().getTime()
			@_scheduleClean()
		return false

	# Schedules a cleanout of the seen messages.
	_scheduleClean: ->
		return if @_cleanId
		@_cleanId = _.delay (=>
			@_clean()
			# Schedule another if we still have messages.
			unless _.isEmpty @_seen
				@_scheduleClean()
			return
		), @SEEN_TIME
		return

	# Clean the seen messages.
	_clean: ->
		seen = @_seen
		limit = new Date().getTime() - @SEEN_TIME
		for own id, time of seen
			if time < limit
				delete seen[id]
		return
