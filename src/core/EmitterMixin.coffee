# The EmitterMixin is a mixin class for attaching an instance-local EventBus to objects.
# It adds the `on()`, `off()`, and `_trigger()` methods to the object.
EmitterMixin = class C.EmitterMixin
	# Register a handler to an address.
	on: (address, handler, context) ->
		return getEmitterBus(@).subscribe(address, handler, context)

	# Unregisters a handler from an address.
	off: (address, handler, context) ->
		return unless hasEmitterBus(@)
		return getEmitterBus(@).unsubscribe(address, handler, context)

	# Publishes an event to an address.
	_trigger: (address, data, reply) ->
		return unless hasEmitterBus(@)
		return getEmitterBus(@).publish(address, data, reply)

# Provate statis function for checking is the object has an emitter bus.
hasEmitterBus = (obj) ->
	return false unless obj._calamity
	return false unless obj._calamity.emitter
	return false unless obj._calamity.emitter.bus
	return true

# Private static function for preparing an on-demand event bus for an object.
getEmitterBus = (obj) ->
	calamity = (obj._calamity or= {})
	emitter = (calamity.emitter or= {})
	return emitter.bus or= new EventBus()


# Adds emitter functionality.
C.emitter = (obj) ->
	_.extend obj, EmitterMixin.prototype
