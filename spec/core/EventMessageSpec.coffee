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
			try
				throw new Error "Foo"
			catch error then message.replyError error, foo:"foo"
			waitsFor (-> reply.called), "Reply never called", 100
			runs ->
				expect(reply.callCount).toBe 1
				call = reply.getCall 0
				replyMsg = call.args[0]
				expect(replyMsg instanceof EventMessage).toBe true
				expect(replyMsg.status).toBe "error"
				#expect(replyMsg.error).toBe "Error: Foo"
				expect(replyMsg.data.message).toBe "Foo"
				expect(replyMsg.data.name).toBe "Error"
				expect(replyMsg.data.foo).toBe "foo"
				expect(replyMsg.isSuccess()).toBe false
				expect(replyMsg.isError()).toBe true

	describe "serialization", ->
		msg = null
		address = "address"
		data =
			a: "foo"
			b: -56.3
			c: false
			d: NaN
			e: Infinity
			f: {x:6, y:0}
		dataString = JSON.stringify data
		reply = null

		beforeEach ->
			reply = sinon.spy()
			msg = new EventMessage address, data, reply

		it "should convert to JSON", ->
			json = msg.toJSON()
			expect(json.calamity?).toBe true
			expect(json.address).toBe address
			expect(json.status).toBe "ok"
			expect(json.error).toBe null
			expect(typeof json.reply).toBe "function"
			expect(JSON.stringify(json.data)).toBe dataString

			# Replying should still work.
			json = msg.toJSON()
			json.reply.call @, foo:"foo"
			waitsFor (-> reply.called), "Reply never called", 100
			runs ->
				expect(reply.callCount).toBe 1
				call = reply.getCall 0
				expect(call.args[0] instanceof EventMessage).toBe true
				expect(call.args[0].data.foo).toBe "foo"

		it "should not add a reply in the JSON if there is not reply handler", ->
			msg = new EventMessage address, data
			json = msg.toJSON()
			expect(json.reply).toBe undefined

		it "should deserialize from JSON", ->
			json = msg.toJSON()
			dmsg = EventMessage.fromJSON json
			expect(typeof dmsg).toBe "object"
			expect(dmsg).not.toBe msg
			expect(dmsg instanceof EventMessage).toBe true
			expect(dmsg.address).toBe address
			expect(dmsg.status).toBe "ok"
			expect(dmsg.error).toBe null
			expect(JSON.stringify(dmsg.data)).toBe dataString

			# Replying should work like before.
			dmsg.reply foo:"foo"
			waitsFor (-> reply.called), "Reply never called", 100
			runs ->
				expect(reply.callCount).toBe 1
				call = reply.getCall 0
				expect(call.args[0] instanceof EventMessage).toBe true
				expect(call.args[0].data.foo).toBe "foo"

	describe "variables", ->
		data =
			foo: "a"
			bar: "b"
		msg = null
		beforeEach ->
			msg = new EventMessage "address", data

		it "should return optional values", ->
			expect(msg.getOptional "foo").toBe "a"
			expect(msg.getOptional "bar").toBe "b"
			expect(msg.getOptional "bar", "default").toBe "b"
			expect(msg.getOptional "doesntexist").toBe undefined
			expect(msg.getOptional "doesntexist", "default").toBe "default"

		it "should return required values", ->
			expect(msg.getRequired "foo").toBe "a"
			expect(msg.getRequired "bar").toBe "b"

		it "should throw errors on missing required values without a reply handler", ->
			check = ->
				msg.getRequired "doesntexist"
			expect(check).toThrow("Variable \"doesntexist\" not found on message with address \"address\"")

		it "should return deep values" # getRequired("a.b.c.d")

		it "should support an empty dataset", ->
			msg = new EventMessage "address", null
			expect(msg.getOptional "nope").toBe undefined
			test = ->
				msg.getRequired "nope"
			expect(test).toThrow("Variable \"nope\" not found on message with address \"address\"")


	# Planned feature.
	describe "proxy", ->
		it "should propagate own errors unless it has a reply handler"
		# msg has an error:
		# msg.proxy (reply) =>

		it "should propagate reply errors unless it has a reply handler"
		# reply has an error
		# msg.proxy (reply) =>
		# data on `reply` should also be propagated.

		it "should propagate thrown errors unless it has a reply handler"
		# Supplied handler threw an error
		# msg.proxy (reply) =>

		it "should execute handler if there are no errors"

		it "should automatically propagate errors using replies when told to"
		xit "should automatically propagate errors using replies when told to", ->
			reply = sinon.spy()
			msg = new EventMessage null, "errorpropagation", reply
			error = new Error "test error"
			# When inside a message handler, using `autoPropagate` should provide error aggregation.
			msg.autoPropagate ->
				throw error

			waitsFor (-> reply.called), "Reply never called", 100
			runs ->
				expect(reply.callCount).toBe 1
				call = reply.getCall 0
				replyMsg = call.args[0]
				expect(replyMsg.status).toBe "error"
				expect(replyMsg.error).toBe error

	describe "callback proxy", ->
		it "should propagate own errors unless it has a reply handler"
		# msg has an error:
		# msg.proxyCallback (data) =>

		it "should propagate reply errors unless it has a reply handler"
		# original callback had an error:
		# msg.proxyCallback (data) =>

		it "should propagate thrown errors unless it has a reply handler"
		# Supplied handler threw an error:
		# msg.proxyCallback (data) =>

		it "should execute handler if there are no errors"
