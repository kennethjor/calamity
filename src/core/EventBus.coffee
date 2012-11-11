# The EventBus manages passing events between different modules.
EventBus = class C.EventBus
	constructor: ->
		# Generate ID.
		@id = util.genId()
		# Registered handlers container.
		@handlers = {}

	# Register a handler to an address.
	subscribe: (address, handler, context) ->
		context or= @
		unless @handlers[address]
			@handlers[address] = []
		@handlers[address].push _.bind(handler, context)

		return @

	# Publishes an event to an address.
	publish: (address, data, reply) ->
		msg = @_createMessage address, data, reply
		address = msg.address
		# Check if message has already been processed by this bus.
		return @ if msg.sawBus @
		# Register this bus on the event
		msg.addBus @
		# Publish to target address.
		@_publishAddress address, msg
		# Publish to wildcard address.
		@_publishAddress "*", msg

		return @

	# Utility function for creating messages.
	_createMessage: (address, data, reply) ->
		# Construct new EventMessage is necesarry.
		msg = address
		unless msg instanceof EventMessage
			msg = new EventMessage address, data, reply
		return msg


	# Publishes a message to an address.
	_publishAddress: (address, msg) ->
		# Check if we have handlers for this address.
		return unless @handlers[address]
		# Send to handlers.
		for handler in @handlers[address]
			do (handler) ->
				_.defer ->
					handler(msg)
				return

