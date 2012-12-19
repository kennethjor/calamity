# # ProxyMixin
# Mixin class for attaching global `EventBus` handling to objects.
# It adds the `_subscribe()` and `_publish()` methods to the class, which automatically sets the context of any handler
# to `this`.
ProxyMixin = class C.ProxyMixin
	# ## `_subscribe()`
	# Register a handler to an address with.
	subscribe: (address, handler) ->
		return @_calamity.proxy.bus.subscribe address, handler, @

	# ## `_publish()`
	# Publishes an event to an address.
	publish: (address, data, reply) ->
		return @_calamity.proxy.bus.publish address, data, reply

# We automatically construct a default global bus when needed.
PROXY_GLOBAL_BUS = null

# ## `Calamity.proxy()`
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
