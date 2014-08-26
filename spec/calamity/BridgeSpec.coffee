calamity = require "../../calamity"
sinon = require "sinon"
_ = require "underscore"

describe "Bridge", ->
	bus1 = null
	bus2 = null
	bridge = null
	handler1 = null
	handler2 = null

	beforeEach ->
		bus1 = new calamity.Bus()
		bus2 = new calamity.Bus()
		bridge = new calamity.Bridge bus1, bus2
		handler1 = sinon.spy()
		handler2 = sinon.spy()
		bus1.subscribe "address", handler1
		bus2.subscribe "address", handler2

	it "should remember seen messages", ->
		msg = new calamity.Message()
		expect(bridge.seen msg).toBe false
		expect(bridge.seen msg).toBe true
		msg = new calamity.Message()
		expect(bridge.seen msg).toBe false
		expect(bridge.seen msg).toBe true

	it "it should forget seen messages after a certain time", (done) ->
		msg = new calamity.Message()
		bridge.seen msg
		_.delay (->
			expect(bridge.seen msg, false).toBe false
			done()
		), bridge.SEEN_TIME + 10


	it "should transfer messages from one bus to another", (done) ->
		bus1.publish "address", "data"
		_.defer ->
			expect(handler1.callCount).toBe 1
			expect(handler2.callCount).toBe 1
			done()
