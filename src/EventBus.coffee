if !_ and require
	_ = require "underscore"

# The EventBus manages passing events between different modules.
module.exports["EventBus"] = class EventBus
	constructor: ->
		# Registered handlers
		@handlers = {}

	# Register a handler to an address.
	subscribe: (address, handler, context) ->
		context or= @
		unless @handlers[address]
			@handlers[address] = []
		@handlers[address].push _.bind(handler, context)
		return @

	# Publishes an event to an address.
	publish: (address, data) ->
		#console.log "publish: " + address + " :: " + JSON.stringify(data)
		return unless @handlers[address]
		for h in @handlers[address]
			h(data)
		return @
