calamity = require "../dist/calamity.js"
async = require "async"

bus = null
next = null
n1 = null
n2 = null
handler1 = ->
	n1++
	next()
handler2 = ->
	n2++
	next()

exports.tests =
	setUp: (done) ->
		bus = new calamity.EventBus()
		next = null
		# Setup two handlers.
		n1 = 0
		n2 = 0
		bus.subscribe "address1", handler1
		bus.subscribe "address2", handler2
		done()

	# Simple pub/sub tests.
	"simple pubsub": (test) ->
		async.series [
			# Publsh to the first address.
			(callback) ->
				next = callback
				bus.publish "address1"
			# Check callback counts.
			(callback) ->
				test.equals(n1, 1)
				test.equals(n2, 0)
				callback()
			# Publish to second address.
			(callback) ->
				next = callback
				bus.publish "address2"
			# Check callback counts.
			(callback) ->
				test.equals(n1, 1)
				test.equals(n2, 1)
				callback()

				test.done()
		]

	# Tests wildcard subscriptions.
	"wildcard subscription": (test) ->
		test.expect(1)
		bus.subscribe "*", (msg) ->
			test.equal("data", msg.data)
			test.done()
		bus.publish "something", "data"

	# Tests repeated publishing of the same message.
	"repeat publish": (test) ->
		test.expect 1
		msg = new calamity.EventMessage "address1"
		async.series [
			# Publish message twice
			(callback) ->
				next = callback
				bus.publish msg
			(callback) ->
				# Next should NOT be called
				next = ->
					test.ok false, "repeated publish exection"
				bus.publish msg
				_.defer ->
					test.ok true
					callback()
					test.done()
		]

