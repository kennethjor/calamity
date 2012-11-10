calamity = require "../dist/calamity.js"

bus1 = null
bus2 = null
bridge = null

exports.tests =
	setUp: (done) ->
		# Construct two event busses and connect then via a bridge.
		bus1 = new calamity.EventBus()
		bus2 = new calamity.EventBus()
		bridge = new calamity.MemoryEventBridge()
			.connect(bus1)
			.connect(bus2)
		done()

	# Simple connection test.
	"simple connection": (test) ->
		test.done()
		return



		# Setup counters and register on both busses
		n11 = n12 = n21 = n22 = 0

		bus1.subscribe "a1", ->
			n11++
		bus1.subscribe "a2", ->
			n12++
		bus2.subscribe "a1", ->
			n21++
		bus2.subscribe "a2", ->
			n22++

		# Publish to address on either bus and entire connection across bridge.
		bus1.publish "a1"
		test.equals n11, 1
		test.equals n21, 1
		bus2.publish "a2"
		test.equals n12, 1
		test.equals n22, 1

		test.done()
