calamity = require "../../calamity"
sinon = require "sinon"
_ = require "underscore"

describe "Emitter", ->
	obj = null
	handler = null
	sub = null
	beforeEach ->
		obj = {}
		calamity.emitter obj
		handler = sinon.spy()
		sub = obj.on "address", handler

	it "should accept on, trigger, and off", (done) ->
		obj.trigger "address", "data"
		_.defer ->
			expect(handler.callCount).toBe 1
			obj.off "address", handler
			obj.trigger "address", "data"
			_.defer ->
				expect(handler.callCount).toBe 1
				done()

	it "should unsubscribe via subscription objects", (done) ->
		sub.unsubscribe()
		obj.trigger "address", "data"
		_.defer ->
			expect(handler.callCount).toBe 0
			done()

	it "should isolate the busses of multiple objects", ->
		obj2 = {}
		calamity.emitter obj2
		obj2.trigger "address"
		_.defer ->
			expect(handler.callCount).toBe 0

