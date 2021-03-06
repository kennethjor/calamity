Calamity is a publish-subscribe event bus library, allowing for the building of loosely-coupled, event-driven applications.
The event bus can either be used globally or it can be attached to individual objects, providing any object with the ability to publish local events.

Install via NPM:

    npm install --save calamity

Or via Bower:

    bower install --save calamity

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
    		_.defer =>
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
*Events* tell of something which happened and are transmitted using `trigger()` and `publish()`.
Normally events will not be replied to and will originate from a single source.

*Commands* are instructions to perform an action and are transmitted using `send()`.
The local events mixin does not include a mechanism for sending commands.
Commands are much more likely to send replies than events, as they often need to report on their progress.
Commands will usually only be subscribed to by a single object type, and be sent from many.

Within Calamity there is no real difference between an event and a command, other than the method used for sending it.
Both of them use the `EventMessage` class to contain themselves.

# Working with messages
When subscribing to an address, the attached handler is expected to accept a single argument: an `EventMessage` object.
This object encapsulates the entire message and everything that can be done with it.

## EventMessage properties
The following properties are available on `EventMessage`:

* `msg.address`: The address the message was sent to.
* `msg.data`: The raw data object supplied on creation.
* `msg.status`: The status of the message. This can beeither "ok" or "error". Error is used by `replyError()`. To check for erros, `isError()` should be used.
* `msg.error`: If `msg.status` is "error", this will contain the error supplied to `replyError()`.

## EventMessage methods
The following methods can be used to interact with the message:

* `getOptional( param, default )`: Returns a value from `msg.data`. If the value does not exist, the supplied `default` is returned.
* `getRequried( param )`: Returns a value from `msg.data`. IF the value does not exist, an `Error` is thrown.
* `reply( data[, replier(msg) ] )`: Sends a reply to the sender.
* `replyError( error[, replier(msg) ] )`: Sends an error reply to the sender.
* `isError()`: Returns true if the message represents an error. The supplied error is available via `msg.error`.

# Replying to messages

# License
Calamity is licensed and freely distributed under the [MIT License][mit]

[mit]: https://bitbucket.org/kennethjor/calamity/raw/default/LICENSE "MIT License"
