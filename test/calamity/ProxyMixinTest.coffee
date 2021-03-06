calamity = require "../../../calamity"
async = require "async"

# Proxy using the default global bus.
class TestProxyDefault
	calamity.proxy @.prototype
default1 = new TestProxyDefault()
default2 = new TestProxyDefault()

# Proxy using a specific supplied bus.
bus = new calamity.EventBus()
class TestProxySpecific
	calamity.proxy @.prototype, bus
specific1 = new TestProxySpecific()
specific2 = new TestProxySpecific()


exports.tests =
	setUp: (done) ->
		done()

	# Tests whether the construction and mixin worked correctly.
	"construction": (test) ->
		test.ok default1 instanceof TestProxyDefault
		test.equal "function", typeof default1.publish
		test.equal "function", typeof default1.subscribe
		test.ok default1._calamity.proxy.bus instanceof calamity.EventBus
		test.ok specific1._calamity.proxy.bus instanceof calamity.EventBus
		test.done()

	# Tests whether the busses are the same instances.
	"bus equality": (test) ->
		test.strictEqual default1._calamity.proxy.bus, default2._calamity.proxy.bus
		test.strictEqual specific1._calamity.proxy.bus, bus
		test.strictEqual specific1._calamity.proxy.bus, specific2._calamity.proxy.bus
		test.notStrictEqual default1._calamity.proxy.bus, specific1._calamity.proxy.bus
		test.done()

	# Actually tests the publish and subscribe functionality.
	"pubsub": (test) ->
		test.expect 2
		# Subscribe on object 1, publish on object 2. They should use the same event bus.
		default1.subscribe "address", (msg) ->
			# Check this context and data.
			test.strictEqual default1, @
			test.equal "data", msg.data
			test.done()
		default2.publish "address", "data"

