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
		# Create new error message.
		msg = new EventMessage null, data
		msg.status = "error"
		msg.error = error
		# Ensure meaningful serialization.
		if error instanceof Error
			for v in "message,name,stack,fileName,lineNumber,description,number".split(",")
				error[v] = error[v] if error[v]
			error.string = error.toString() if typeof error.toString is "function"
		# Send reply.
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

	# Returns a parameter message data.
	# If the parameter is not present, `def` is returned.
	getOptional: (param, def) ->
		val = @data[param]
		if typeof val is "undefined"
			return def
		return val

	# Returns a parameter message data.
	# If the parameter is not present, an error is thrown.
	getRequired: (param) ->
		val = @data[param]
		if typeof val is "undefined"
			throw new Error "Variable \"#{param}\" not found on message with address \"#{@address}\""
		return val

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

	# ## `toJSON()`
	# Converts the message to a plain JSON object for possible storage or transmission.
	toJSON: ->
		json =
			calamity: C.version
			address: @address
			data: @data
			status: @status
			error: @error
		if @_replyHandler?
			json.reply = _.bind @reply, @
		return json

	# ## `fromJSON()`
	# Converts a JSON object to an EventMessage.
	# The message must have been serialized using `EventMessage`'s own `toJSON()` method, otherwise weird things could happen.
	@fromJSON = (json) ->
		throw new Error "JSON must be an object" unless _.isObject json
		throw new Error "Serialized JSON is not for calamity: #{JSON.stringify(json)}" unless json.calamity?
		msg = new EventMessage json.address, json.data, json.reply
		msg.status = json.status
		msg.error = json.error
		return msg
