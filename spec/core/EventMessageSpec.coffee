{EventBus, EventMessage} = require "../../../calamity"
sinon = require "sinon"

describe "EventMessage", ->

	it "should be empty when created", ->
		msg = new EventMessage
		expect(msg instanceof EventMessage).toBe true

	it "should create a message with correct address and data", ->
		msg = new EventMessage "address", "data"
		expect(msg.address).toBe "address"
		expect(msg.data).toBe "data"

	it "should remember if it has seen a bus or not", ->
		msg = new EventMessage
		bus = new EventBus
		expect(msg.sawBus bus).toBe false
		msg.addBus bus
		expect(msg.sawBus bus).toBe true
		expect(msg.sawBus new EventBus).toBe false

	describe "replies", ->
		message = null
		reply = null
		beforeEach ->
			reply = sinon.spy()
			message = new EventMessage "address", data:"foo", reply

		it "should call reply handler when replied", ->
			message.reply()
			waitsFor (-> reply.called), "Reply never called", 100
			runs ->
				expect(reply.callCount).toBe 1

		it "should be provided with a successful EventMessage by default", ->
			message.reply foo:"foo"
			waitsFor (-> reply.called), "Reply never called", 100
			runs ->
				replyMsg = reply.args[0][0]
				expect(replyMsg instanceof EventMessage).toBe true
				expect(replyMsg.data.foo).toBe "foo"
				expect(replyMsg.status).toBe "ok"
				expect(replyMsg.error).toBe null
				expect(replyMsg.isSuccess()).toBe true
				expect(replyMsg.isError()).toBe false

		it "should handle error replies", ->
			error = new Error "Foo"
			message.replyError error, foo:"foo"
			waitsFor (-> reply.called), "Reply never called", 100
			runs ->
				replyMsg = reply.args[0][0]
				expect(replyMsg instanceof EventMessage).toBe true
				expect(replyMsg.data.foo).toBe "foo"
				expect(replyMsg.status).toBe "error"
				expect(replyMsg.error).toBe error
				expect(replyMsg.isSuccess()).toBe false
				expect(replyMsg.isError()).toBe true
