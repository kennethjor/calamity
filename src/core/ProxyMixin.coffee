# The ProxyMixin is a mixin class for attaching global EventBus handling to objects.
# It adds the _subscribe and _publish methods to the class, which automatically sets the context of any handler to this.
ProxyMixin = class C.ProxyMixin
	# Register a handler to an address with.
	_subscribe: (address, handler) ->
		return @_calamity.proxy.bus.subscribe address, handler, @

	# Publishes an event to an address.
	_publish: (address, data, reply) ->
		return @_calamity.proxy.bus.publish address, data, reply

# We automatically construct a default global bus when needed.
PROXY_GLOBAL_BUS = null

# Adds proxy functionality.
C.proxy = (obj, bus) ->
	# Prepare bus.
	unless bus instanceof EventBus
		PROXY_GLOBAL_BUS or= new EventBus()
		bus = PROXY_GLOBAL_BUS
	# Attach bus.
	c = (obj._calamity or= {})
	c.proxy =
		bus: bus
	# Extend.
	_.extend obj, ProxyMixin.prototype
