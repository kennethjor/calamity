calamity = require "../dist/calamity.js"
async = require "async"

bus = null
bridge = null

next = null
n = null
msg = null
handler = null

exports.tests =
	setUp: (done) ->
		# Construct two event busses and connect then via a bridge.
		bus = [
			new calamity.EventBus()
			new calamity.EventBus()
		]
		bridge = new calamity.MemoryEventBridge()
			.connect(bus[0])
			.connect(bus[1])
		# Construct handlers and subscribe.
		next = () ->
			return
		n = []
		msg = []
		handler = []
		for a in [0..1]
			n.push []
			msg.push []
			handler.push []
			for b in [0..1]
				n[a].push 0
				msg[a].push null
				do (a, b) ->
					h = (m) ->
						n[a][b]++
						msg[a][b] = m
						next()
					handler[a].push h
					bus[a].subscribe "address"+b, h

		done()

	# Simple connection test.
	"simple connection": (test) ->
		async.series [
			# Publish on one bus.
			(callback) ->
				next = callback
				bus[0].publish "address0", "data0"
			# Verify calls.
			(callback) ->
				test.equals 1, n[0][0]
				test.equals 0, n[0][1]
				test.equals 1, n[1][0]
				test.equals 0, n[1][1]
				test.equals "data0", msg[0][0]
				test.equals "data0", msg[1][0]
				callback()
			# Publish on the other bus.
			(callback) ->
				next = callback
				bus[1].publish "address1", "data1"
			# Verify calls.
			(callback) ->
				test.equals 1, n[0][0]
				test.equals 1, n[0][1]
				test.equals 1, n[1][0]
				test.equals 1, n[1][1]
				test.equals "data1", msg[0][1]
				test.equals "data1", msg[1][1]
				callback()
				test.done()
		]
