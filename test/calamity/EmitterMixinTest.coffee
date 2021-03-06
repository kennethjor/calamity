calamity = require "../../../calamity"
async = require "async"

# Test class with the emitter mixin applied.
class TestEmitter
	calamity.emitter @.prototype

emitter1 = null
emitter2 = null
n1 = null
n2 = null
context = {}
context1 = null
context2 = null
next = null
handler1 = (msg) ->
	n1++
	context1 = @
	next() if next
handler2 = (msg) ->
	n2++
	context2 = @
	next() if next
sub1 = null
sub2 = null

exports.tests =
	setUp: (done) ->
		emitter1 = new TestEmitter()
		emitter2 = new TestEmitter()
		n1 = 0
		n2 = 0
		context1 = null
		context2 = null
		sub1 = emitter1.on "address", handler1, context
		sub2 = emitter2.on "address", handler2, context
		done()

	# Tests if the mixin completed sucessfully.
	"mixin": (test) ->
		test.expect 3
		test.ok _.isFunction emitter1.on
		test.ok _.isFunction emitter1.off
		test.ok _.isFunction emitter1.trigger
		test.done()

	# General test of the emitter.
	"emitter": (test) ->
		test.expect 7
		# Test for separate event bus instances.
		test.notStrictEqual emitter1._calamity.emitter.bus, emitter2._calamity.emitter.bus
		# Test context on subscription.
		test.strictEqual context, sub1.context
		test.strictEqual context, sub2.context
		async.series [
			(callback) ->
				# Trigger both emitters.
				emitter1.trigger "address"
				emitter2.trigger "address"
				_.delay callback, 10
			(callback) ->
				# Test correct execution count.
				test.equal 1, n1
				test.equal 1, n2
				# Test handler context.
				test.strictEqual context, context1
				test.strictEqual context, context2
				callback()
				test.done()
		]

	# Tests if the event bus is created on-demand like it's designed to.
	"ondemand": (test) ->
		test.expect 5
		# When first initialized, no event bus should exist.
		emitter = new TestEmitter()
		test.ok _.isUndefined emitter._calamity
		async.series [
			(callback) ->
				# A trigger with no listeners should not create the bus.
				emitter.trigger "address"
				_.delay callback, 10
			(callback) ->
				test.ok _.isUndefined emitter._calamity
				callback()
			(callback) ->
				# Adding a new subscription should create it.
				emitter.on "address", () ->
					return
				test.ok _.isObject emitter._calamity
				test.ok _.isObject emitter._calamity.emitter
				test.ok emitter._calamity.emitter.bus instanceof calamity.EventBus
				test.done()
		]

	# Test correct default context is set.
	"default context": (test) ->
		test.expect 2
		# Setup
		emitter = new TestEmitter()
		sub = emitter.on "address", () ->
			# Test local context
			test.strictEqual emitter, @
			test.done()
		# Test subscription context
		test.strictEqual emitter, sub.context
		emitter.trigger "address"

