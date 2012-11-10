calamity = require("../dist/calamity.js")

bus = null

exports.tests =
	setUp: (done) ->
		bus = new calamity.EventBus()
		done()

	# Simple pub/sub tests.
	"simple pubsub": (test) ->
		# Setup two handlers.
		n1 = 0
		handler1 = ->
			n1++
		bus.subscribe "address1", handler1

		n2 = 0
		handler2 = ->
			n2++
		bus.subscribe "address2", handler2

		# Publish to both of them.
		bus.publish "address1"
		test.equals(n1, 1)
		test.equals(n2, 0)
		bus.publish "address2"
		test.equals(n1, 1)
		test.equals(n2, 1)

		# Publish to somewhere unknown.
		bus.publish "address3"
		test.equals(n1, 1)
		test.equals(n2, 1)

		test.done()

	# Tests wildcard subscriptions.
	"wildcard subscription": (test) ->
		test.done()
