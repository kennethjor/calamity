# Calamity
Calamity allows you to drive your application through a global event bus, facilitating loosely-coupled event-driven architectures.
Available via [npm](https://npmjs.org/package/calamity): `npm install calamity`.

# Local event busses with `emitter()`.
Local event busses are used on individual classes and objects to allow them to publish events others can subscribe to.
When attaching a local event bus, two methods are made available: `on()` and `trigger()`.

## `on(address, handler(msg) )`
Attaches the function `handler(msg)` to be executed when `address` is triggered.
When `handler` is executed, Calamity will automatically bind its execution to the subscribing object.

## `trigger(address [, data [, replier(reply) ] ] )`
Triggers any handlers attached to `address`.
`data` is an arbitrary object which will be provided to the handler via its message.
`replier` is a secondary handler function which will be executed in case the main handler executes a reply (more on this later).

## Local events example
Consider this imaginary `View` class:

    :::coffeescript
    Calamity = require "calamity"
    _ = require "underscore"

    class View
    	Calamity.emitter @prototype

    	render:
    		@trigger "beforeRender"
    		_.defer ->
    			# Real render code ...
    			@element.find("#closeButton").click =>
    				@trigger "closeButtonClicked"
    		@trigger "afterRender"

Now using the `on()` method, any code with a reference to the view can subscribe to events coming out of it.
In this example we can act on the view starting and finishing its render routine.
Additionally, the view attaches to the click event on a DOM element, propagating it to a Calamity event on the view itself, thereby abstracting it away.

    :::coffeescript
    view = new View()
    view.on "closeButtonClicked", ->
    	view.hide()

# Global event bus with `proxy()`
A more powerful example of Calamity is using it as a global event bus which spans your entire application.
The global event bus proxy attaches three methods: `subscribe()`, `publish()` and `send()`.

## `subscribe( address, handler(msg) )`
Attaches the function `handler(msg)` to be executed when messages are published or sent to `address`.
When `handler` is executed, Calamity will automatically bind its execution to the subscribing object.

## `publish( address [, data [, replier(reply) ] ] )`
Sends a message to `address`.
`data` is an arbitrary object which will be provided to the handler via its message.
`replier` is a secondary handler function which will be executed in case the main handler executes a reply (more on this later).

## `send( address [, data [, replier(reply) ] ] )`
Works exactly like `publish()` with the notable difference that only one subscribing handler will be executed.
This is useful for sending commands instead events.

## Global events example

    :::coffeescript
    Calamity = require "calamity"
    class Foo
    	Calamity.proxy @prototype

    	constructor: () ->
    		@subscribe "address", @handler

    	handler: (msg) ->
    		# Proxy automatically handles binding to this.
    		@data = msg.data

Now, whenever any object publishes a message to the `foo:bar` address, handler will be called and you can react on it.

# Events and commands
Events tell of something which happened and will normally not be replied to.
They will usually originate from a single object type.

Commands are instructions to perform an action and are very likely to implement replies.
They will usually only be subscribed to by a single object type and sent from many places.

# Working with messages

# Replying to messages

# License
Calamity is licensed and freely distributed under the [MIT License][mit]

[mit]: https://bitbucket.org/kennethjor/calamity/raw/default/LICENSE "MIT License"
