# 0.3.0 (development)
* *API change:* Removed initial underscore from `_trigger()`, `_subscribe()`, and `_publish()` on `ProxyMixin` and `EmitterMixin`. It makes assumptions about code style.
* *Fix:* Browser initialisation.
* *Fix:* Bug where `EmitterMixin` would not correctly set default context.

# 0.2.0 (2012-11-14)

* *Feature:* Implemented `ProxyMixin` for easy global event bus handling.
* *Feature:* Implemented `Subscription` objects.
* *Feature:* Implemented `EmitterMixin` for easy attachment of an instance-local `EventBus`.

# 0.1.1 (2012-11-12)

* `npm` related fixes.

# 0.1.0 (2012-11-12)

* Initial public release.
* *Feature:* `EventBus` implementation.
