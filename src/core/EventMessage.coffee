# # EventMessage
# Represents a single message in the system.
EventMessage = class C.EventMessage
	# Constructor.
	constructor: (@address, @data, @_replyHandler) ->
		# Generate ID.
		@id = util.genId()
		# Remebered busses container.
		# This will store the ID of every bus the event has seen, to prevent repeated execution.
		@_busses = []
		# Check reply handler.
		unless _.isUndefined(@_replyHandler) or _.isFunction(@_replyHandler)
			throw new Error "Reply must be a function"

	# ## `reply()`
	# Executes the reply handler, if this message has one.
	reply: (data) ->
		if _.isFunction(@_replyHandler)
			replyHandler = @_replyHandler
			_.defer ->
				replyHandler(data)
				return
		return @

	# ## `addBus()`
	# Adds a bus to the internal list.
	addBus: (bus) ->
		return @ if @sawBus(bus)
		@_busses.push bus.id
		return @

	# ## `sawBus()`
	# Returns true if this message has been processed by the supplied bus.
	sawBus: (bus) ->
		return _.contains @_busses, bus.id

	# ## `serialize()`
	# Serializes the message as JSON.
	serialize: ->
		return JSON.stringify @

# ## `deserialize()`
# Desrialises a message from JSON.
EventMessage.deserialize = (json) ->
	return undefined
