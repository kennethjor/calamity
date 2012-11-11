# EventMessage represents a single message in the system.
EventMessage = class C.EventMessage
	# Constructor.
	constructor: (@address, @data, @replyHandler) ->
		# Generate ID.
		@id = util.genId()
		# Check reply handler.
		unless _.isUndefined(@replyHandler) or _.isFunction(@replyHandler)
			throw new Error "Reply must be a function"

	# Executes the reply handler, if this message has one.
	reply: (data) ->
		if _.isFunction(@replyHandler)
			replyHandler = @replyHandler
			_.defer ->
				replyHandler(data)
				return
		return @

	# Serializes the message as JSON.
	serialize: ->
		return undefined

# Desrialises a message from JSON.
EventMessage.deserialize = (json) ->
	return undefined