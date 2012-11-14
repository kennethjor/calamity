# Represents a subscription of a handler to an address on an bus.
Subscription = class C.Subscription
	# Constructor.
	constructor: (@address, @handler, @context, @bus) ->
		@id = util.genId()
		@active = true
		return

	# Shorthand for unsubscribing.
	unsubscribe: ->
		return unless @_active
		@bus.unsubscribe @
		@active = false
		return @

	# Fires the handler with the supplied message.
	trigger: (msg) ->
		return @ unless @active
		# Bind handler.
		bound = _.bind @handler, @context
		# Execute.
		_.defer ->
			bound msg
			return

		return @
