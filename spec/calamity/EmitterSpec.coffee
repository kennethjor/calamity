calamity = require "../../calamity"
sinon = require "sinon"
_ = require "underscore"

describe "Emitter", ->
	obj = null
	handler = sinon.spy()
	beforeEach ->
		obj = {}
		calamity.emitter obj

	it "should accept on, trigger, and off", (done) ->
		obj.on "address", handler
		obj.trigger "address", "data"
		_.defer ->
			expect(handler.callCount).toBe 1
			obj.off "address", handler
			obj.trigger "address", "data"
			_.defer ->
				expect(handler.callCount).toBe 1
				done()

	it "should unsubscribe via subscription objects", (done) ->
		sub = obj.on "address", handler
		sub.unsubscribe()
		obj.trigger "address", "data"
		_.defer ->
			expect(handler.callCount).toBe 1
			done()

