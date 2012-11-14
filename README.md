# CalamityJS
Calamity is an event bus library for use in event-driven architectures.
With Calamity you can easily attach global and local event functionality to your classes and prototypes.

The library is still in its early stages of development, bus the basics are there.

# Installing
Install via `npm`:

    npm install calamity

Or [download][download] directly from bitbucket:

* [Development version][downloadfull]
* [Minimized version][downloadmin]

[Download latest stable.][download]

# Usage

The two primary methods in Calamity are `Calamity.proxy()` and `Calamity.emitter()`.

## Global event bus with `proxy()`
This example CoffeeScript code will create an object which is aware of a global event bus.

    Calamity = require "calamity"
    class Foo
    	Calamity.proxy @.prototype

    	constructor: () ->
    		@._subscribe "address", @.handler

    	handler: (msg) ->
    		# Proxy automatically handles this.
    		@data = msg.data

Now, whenever any object publishes a message to the "foo:bar" address, handler will be called and you can react to it.

## Local event bus `emitter()`

# Compiling
To compile Calamity yourself, first check out the repo

    hg clone ssh://hg@bitbucket.org/kennethjor/calamityjs

Install required tools and libraries

    ./setup.sh

Run a full compile

    grunt

When developing, executing watch immediately after the compile is very handy

    grunt default watch

# Versioning
CalamityJS follows the [semantic versioning][semver] specification.

# License
CalamityJS is licensed and freely distributed under the [MIT License][mit]

[download]: https://bitbucket.org/kennethjor/calamityjs/downloads "Download from bitbucket.org"
[downloadfull]: http://cdn.bitbucket.org/kennethjor/calamityjs/downloads/calamity.js
[downloadmin]: http://cdn.bitbucket.org/kennethjor/calamityjs/downloads/calamity-min.js
[mit]: https://bitbucket.org/kennethjor/calamityjs/raw/default/LICENSE "MIT License"
[semver]: http://semver.org/ "Semantic Versioning"
