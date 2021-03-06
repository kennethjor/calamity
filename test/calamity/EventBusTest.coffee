calamity = require "../../../calamity"
async = require "async"

bus = null
next = null
n1 = null
n2 = null
sub1 = null
sub2 = null
handler1 = ->
	n1++
	next() if next
handler2 = ->
	n2++
	next() if next

exports.tests =
	setUp: (done) ->
		bus = new calamity.EventBus()
		next = null
		# Setup two handlers.
		n1 = 0
		n2 = 0
		sub1 = bus.subscribe "address1", handler1
		sub2 = bus.subscribe "address2", handler2
		done()

	# Tests wildcard subscriptions.
	"wildcard subscription": (test) ->
		test.expect 1
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

	# Tests unsubscribe.
	"unsubscribe": (test) ->
		test.expect 5
		# Make sure subscription objects were created.
		test.ok sub1 instanceof calamity.Subscription
		test.ok sub2 instanceof calamity.Subscription
		test.notStrictEqual sub1, sub2

		async.series [
			# Unsubscribe both handlers and publish.
			(callback) ->
				# First using the subscription object.
				bus.unsubscribe sub1
				# Second using the address and handler reference.
				bus.unsubscribe "address2", handler2
				# Publish to both addresses.
				bus.publish "address1"
				bus.publish "address2"

				_.delay callback, 10
			# Make sure neither handler was called.
			(callback) ->
				test.equal 0, n1
				test.equal 0, n2
				callback()
				test.done()
		]

