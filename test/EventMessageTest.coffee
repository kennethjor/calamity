calamity = require "../dist/calamity.js"
async = require "async"

msg = null
replies = null
replyData = null
next = null
reply = (data) ->
	replies++
	replyData = data
	next()

exports.tests =
	setUp: (done) ->
		replies = 0
		replyData = undefined
		msg = new calamity.EventMessage("address", "data", reply)
		next = ->
			return
		done()

	# Tests construction.
	"construction": (test) ->
		test.equals "address", msg.address
		test.equals "data", msg.data
		test.done()

	# Tests reply handler.
	"reply": (test) ->
		async.series [
			(callback) ->
				next = callback
				msg.reply "replydata"
				test.equals 0, replies
			(callback) ->
				test.equals 1, replies
				test.equals "replydata", replyData
				callback()
				test.done()
		]

	# Tests addBus() and sawBus()
	"remember bus": (test) ->
		test.expect 5
		bus = new calamity.EventBus()
		msg.addBus bus
		test.ok msg.sawBus(bus)
		test.ok !msg.sawBus(new calamity.EventBus())
		# Add another bus
		bus2 = new calamity.EventBus()
		msg.addBus bus2
		test.ok msg.sawBus(bus)
		test.ok msg.sawBus(bus2)
		test.ok !msg.sawBus(new calamity.EventBus())

		test.done()
