# CalamityJS
Calamity is a JavaScript event bus implementation designed for use within both server and client applications.
The library is still in its early stages of development.

The goal of this project is to build a simple EventBus library for event-driven architectures.

# Usage

[Download latest stable.][download]

Install via `npm`:

    npm install calamity

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
[mit]: https://bitbucket.org/kennethjor/calamityjs/raw/default/LICENSE "MIT License"
[semver]: http://semver.org/ "Semantic Versioning"
