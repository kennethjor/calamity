calamity = require "../../calamity"
sinon = require "sinon"
_ = require "underscore"

describe "Bus", ->
	bus = null

	beforeEach ->
		bus = new calamity.Bus()

	it "should route to and execute the correct handlers", (done) ->
		handler11 = sinon.spy()
		handler12 = sinon.spy()
		handler2 = sinon.spy()
		bus.subscribe "address.1", handler11
		bus.subscribe "address.1", handler12
		bus.subscribe "address.2", handler2
		bus.publish "address.1"
		_.defer ->
			expect(handler11.callCount).toBe 1
			expect(handler12.callCount).toBe 1
			expect(handler2.called).toBe false
			bus.publish "address.2"
			_.defer ->
				expect(handler11.callCount).toBe 1
				expect(handler12.callCount).toBe 1
				expect(handler2.called).toBe true
				done()

	it "should send correct messages to handlers", (done) ->
		handler = sinon.spy()
		bus.subscribe "address", handler
		bus.publish "address", "data"
		_.defer ->
			expect(handler.callCount).toBe 1
			msg = handler.getCall(0).args[0]
			expect(msg.address).toBe "address"
			expect(msg.data).toBe "data"
			done()

	it "should send commands to a single handler only", (done) ->
		handler1 = sinon.spy()
		handler2 = sinon.spy()
		bus.subscribe "address", handler1
		bus.subscribe "address", handler2
		bus.send "address"
		_.defer ->
			if handler1.called
				expect(handler1.callCount).toBe 1
				expect(handler2.callCount).toBe 0
			if handler2.called
				expect(handler1.callCount).toBe 0
				expect(handler2.callCount).toBe 1
			expect(handler1.callCount + handler2.callCount).toBe 1
			done()

	it "should provide a global bus", ->
		expect(calamity.global() instanceof calamity.Bus)
		expect(calamity.global()).toBe calamity.global()
