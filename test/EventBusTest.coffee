calamity = require "../dist/calamity.js"
async = require "async"

bus = null

exports.tests =
	setUp: (done) ->
		bus = new calamity.EventBus()
		done()

	# Simple pub/sub tests.
	"simple pubsub": (test) ->
		next = null
		# Setup two handlers.
		n1 = 0
		n2 = 0
		handler1 = ->
			n1++
			next()
		handler2 = ->
			n2++
			next()
		bus.subscribe "address1", handler1
		bus.subscribe "address2", handler2

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
		bus.subscribe "*", ->
			test.done()
		bus.publish "something"
