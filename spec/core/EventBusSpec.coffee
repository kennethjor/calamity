C = require "../../../calamity.js"

describe "EventBus", ->
	bus = null

	beforeEach ->
		bus = new C.EventBus()

	it "should create an empty message", ->
		msg = bus._createMessage()
		expect(msg instanceof C.EventMessage).toBeTruthy()

	it "should create a message with correct address, data, and reply", ->
		reply = ->
			# empty
		msg = bus._createMessage "address", "data", reply
		expect(msg instanceof C.EventMessage).toBeTruthy()
		expect(msg.address).toBe("address")
		expect(msg.data).toBe("data")
		expect(msg._replyHandler).toBe(reply)

	it "should create multiple messages", () ->
		bus = new C.EventBus()
		msg1 = bus._createMessage()
		msg2 = bus._createMessage()
		expect(msg1).not.toBe(msg2)

	it "should route messages to correct handlers", () ->
		handler11 = sinon.spy()
		handler12 = sinon.spy()
		handler2 = sinon.spy()
		bus.subscribe "address/1", handler11
		bus.subscribe "address/1", handler12
		bus.subscribe "address/2", handler2

		runs ->
			bus.publish "address/1"
		waits 10
		runs ->
			expect(handler11).toHaveBeenCalledOnce()
			expect(handler12).toHaveBeenCalledOnce()
			expect(handler2).not.toHaveBeenCalled()

			bus.publish "address/2"
		waits 10
		runs ->
			expect(handler11).toHaveBeenCalledOnce()
			expect(handler12).toHaveBeenCalledOnce()
			expect(handler2).toHaveBeenCalledOnce()

	it "should send correct message to handlers", ->
		msg = null
		handler = (m) ->
			msg = m
		bus.subscribe "address", handler
		runs ->
			bus.publish "address", "data"
		waits 10
		runs ->
			expect(msg.address).toBe("address")
			expect(msg.data).toBe("data")

