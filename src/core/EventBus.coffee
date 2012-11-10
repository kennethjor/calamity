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
		# Construct new EventMessage is necesarry.
		msg = address
		unless msg instanceof EventMessage
			msg = new EventMessage address, data, reply
		address = msg.address
		# Check if we have handlers for this address.
		return unless @handlers[address]
		# Send to handlers.
		for h in @handlers[address]
			h(msg)

		return @
