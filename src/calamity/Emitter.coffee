# # Emitter
# Mixin class for attaching an instance-local event bus to objects.
# It adds the `on()`, `off()`, and `trigger()` methods to the object, which allows object-local addresses to be
# published and subscribed to.
# To mix this into any object or class, use `Calamity.emitter(*obj*)`.
Emitter = class Calamity.Emitter
	# ## `on()`
	# Register a handler to an address.
	# this returns a `Subscription` object which can be used to unregister later.
	on: (address, handler, context) ->
		context or= @
		return getEmitterBus(@).subscribe address, handler, context

	# ## `off()`
	# Unregisters a handler from an address.
	off: (address, handler, context) ->
		return unless hasEmitterBus(@)
		context or= @
		return getEmitterBus(@).unsubscribe address, handler, context

	# ## `trigger()`
	# Publishes an event to an address.
	trigger: (address, data, reply) ->
		return unless hasEmitterBus(@)
		return getEmitterBus(@).publish address, data, reply

# Private statis function for checking is the object has an emitter bus.
hasEmitterBus = (obj) ->
	return false unless obj?._calamity?.emitter?.bus?
	return true

# Private static function for preparing an on-demand event bus for an object.
getEmitterBus = (obj) ->
	calamity = (obj._calamity or= {})
	emitter = (calamity.emitter or= {})
	return emitter.bus or= new Bus()


# ## `Calamity.emitter()`
# Adds emitter functionality to the supplied object.
Calamity.emitter = (obj) ->
	_.extend obj, Emitter.prototype
