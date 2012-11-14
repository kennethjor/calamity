# The EventBus manages passing events between different modules.
EventBus = class C.EventBus
	constructor: ->
		# Generate ID.
		@id = util.genId()
		# Registered subscriptions container.
		@_subscriptions = {}

	# Register a handler to an address.
	subscribe: (address, handler, context) ->
		# Initialize subscriptions container for this address.
		unless @_subscriptions[address]
			@_subscriptions[address] = []
		# Create subscription.
		sub = new Subscription address, handler, context, @
		# Add to list.
		@_subscriptions[address].push sub
		# Return subscription.
		return sub

	# Unsubscribes a handler.
	unsubscribe: (address, handler) ->
		sub = address
		# Search by subscription.
		if sub instanceof Subscription
			# Check address.
			address = sub.address
			return unless @_subscriptions[address]
			for s, i in @_subscriptions[address]
				if s is sub
					@_subscriptions[address].splice i
		# Otherwise search by address and handler.
		else
			# Check for address.
			return unless @_subscriptions[address]
			for s, i in @_subscriptions[address]
				if s.address is address and s.handler is handler
					@_subscriptions[address].splice i
		return

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
		# Check if we have subscriptions at all for this address.
		return unless @_subscriptions[address]
		# Send message to all subscriptions.
		for subscription in @_subscriptions[address]
			subscription.trigger msg
		return

