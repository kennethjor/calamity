# # EventMessage
# Represents a single message in the system.
EventMessage = class C.EventMessage
	# Constructor.
	constructor: (@address, @data = {}, replyHandler) ->
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
	replyError: (error, data = {}) ->
		# Ensure meaningful serialization.
		if error instanceof Error
			# Transfer values to data.
			for v in "message,name,stack,fileName,lineNumber,description,number".split(",")
				val = error[v]
				val = val.toString() if val and typeof val.toString is "function"
				data[v] = val
			if typeof error.toString is "function"
				data.string = error.toString()
				error = data.string
				if data.stack
					error += " :: " + data.stack
		# Create new error message.
		msg = new EventMessage null, data
		msg.status = "error"
		msg.error = error
		# Send reply.
		@reply msg
		return @

	# Returns an event handler which will automatically catch and propagate errors,
	# removing the need to constantly check incoming messages for errors.
	#     msg.proxyErrors (reply) ->
	# Reply will never be an error message, as this would be sent back to the reply handler of message.
	# If not reply handler is present on the message, errors are thrown instead.
	proxyErrors: (handler) ->
		# If we don't have a reply handler, just return a passthrough function.
		unless _.isFunction @_replyHandler
			# Throw error if we have one.
			if @isError()
				throw @error
			# Create and return handler.
			return (msg) ->
				# Pass message errors.
				if msg.isError()
					throw msg.error
				# No error, pass to handler.
				handler msg
		# If we have a reply handler, we need to be more sophisticated.
		else
			# Pass errors on self.
			if @isError()
				@reply @
				return
			# Create and return handler.
			return (msg) =>
				# Pass message errors.
				if msg.isError()
					@reply msg
					return
				# Setup try/catch block and execute handler.
				try
					handler msg
				catch err
					@replyError err
					return

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
		parts = param.split "."
		val = @data[parts[0]]
		# Iterate from second element onwards.
		if parts.length > 1 then for part in parts.splice 1
			if _.isObject(val) and val[part]?
				val = val[part]
			else
				val = undefined
				break
		# Default.
		if typeof val is "undefined"
			return def
		return val

	# Returns a parameter message data.
	# If the parameter is not present, an error is thrown.
	getRequired: (param) ->
		val = @getOptional param
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
