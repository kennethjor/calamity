Calamity = require "../../../calamity.js"

describe "EventBus", ->
	it "should create an empty message", ->
		bus = new EventBus()
		msg = bus._createMessage()
		expect(msg instanceof EventMessage).toBe(true)

	it "should create a message with correct address, data, and reply", ->
		bus = new EventBus()
		reply = ->
			# empty
		msg = bus._createMessage "address", "data", reply
		expect(msg instanceof EventMessage).toBe(true)
		expect(msg.address).toBe("address")
		expect(msg.data).toBe("data")
		expect(msg._replyHandler).toBe(reply)

	it "should create multiple messages", () ->
		bus = new EventBus()
		msg1 = bus._createMessage()
		msg2 = bus._createMessage()
		expect(msg1).toNotBe(msg2)
