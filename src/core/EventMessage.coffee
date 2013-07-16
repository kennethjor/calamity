# # EventMessage
# Represents a single message in the system.
EventMessage = class C.EventMessage
	# Constructor.
	constructor: (@address, @data, replyHandler) ->
		# Generate ID.
		@id = util.genId()
		# Remebered busses container.
		# This will store the ID of every bus the event has seen, to prevent repeated execution.
		@_busses = []
		# Check reply handler.
		unless _.isUndefined(replyHandler) or _.isFunction(replyHandler)
			throw new Error "Reply must be a function"
		@_replyHandler = replyHandler
		# Default values.
		@status = "ok"
		@error = null

	# ## `reply()`
	# Executes the reply handler, if this message has one.
	reply: (data, replier) ->
		replyHandler = @_replyHandler
		# Don't do anything if we don't have a reply handler.
		return unless _.isFunction(replyHandler)
		# Wrap data and further replies in another message.
		unless data instanceof EventMessage
			data = new EventMessage null, data, replier
		# Execute.
		_.defer ->
			replyHandler data
			return
		return @

	# ## `replyError()`
	# Executes the reply handler with an error instead of a reply.
	replyError: (error, data) ->
		msg = new EventMessage null, data
		msg.status = "error"
		msg.error = error
		@reply msg
		return @

	# ## `isSuccess()`
	# Returns true if this message is marked successful, which is the default state.
	isSuccess: ->
		return @status is "ok"

	# ## `isError()`
	# Returns true if this message is marked as errored, such as when replying with `replyError()`.
	isError: ->
		return @status is "error"

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
