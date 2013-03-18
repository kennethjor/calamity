# Calamity
Calamity is an event bus library for use in event-driven architectures.
Using Calamity you can easily drive your application through a global event bus, or simply add event functionality to objects.

# Installing
Install via `npm`:

    npm install calamity

# Usage

The two primary methods in Calamity are `Calamity.proxy()` and `Calamity.emitter()`.

## Global event bus with `proxy()`
This example CoffeeScript code will create an object which is aware of a global event bus.

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

## Local event bus with `emitter()`

    :::coffeescript
    Calamity = require "calamity"
    class Foo
    	Calamity.emitter @prototype

    	constructor: () ->
    		@on "address", @handler

    	handler: (msg) ->
    		# Proxy automatically handles binding to this.
    		@data = msg.data

This code is very similar to the global events, except this will create an event bus local to a particular instance.
This allows you to create localised events using `on(address, handler)` and `trigger(address, data)`.

# License
Calamity is licensed and freely distributed under the [MIT License][mit]

[downloadmin]: https://bitbucket.org/kennethjor/calamity/downloads/calamity-min.js
[mit]: https://bitbucket.org/kennethjor/calamity/raw/default/LICENSE "MIT License"
