# Changelog

## 0.5.0.rc.2 (dev)
* *API change:* Changed the way `EventMessage.replyError` serializes the error object to something more meaningful.

## 0.5.0.rc.1 (2013-07-19)
* *API change:* Replies now send a new `EventMessage` object instead of plain object.
* *Feature:* Implemented `replyError()` on `EventMessage` to allow for easy handling of errors.
* *Feature:* Implemented `toJSON()`  and `fromJSON()` on `EventMessage`.
* *Feature:* Implemented `getRequired()`  and `getOptional()` on `EventMessage` for data retrieval.

## 0.4.1 (2013-07-10)
* *Fix:* `Subscription`'s `unsubscribe()` contained a typo, causing it to never work.

## 0.4.0 (2013-06-26)
* *Feature:* Added support for commands via `send()`.
* *Feature:* Added support for basic event bridges via `bridge()`.

## 0.3.1 (2013-03-19)
* *Fix:* Added AMD load header. [pull/1](https://bitbucket.org/kennethjor/calamity/pull-request/1)

## 0.3.0 (2013-01-29)
* *API change:* Removed initial underscore from `_trigger()`, `_subscribe()`, and `_publish()` on `ProxyMixin` and `EmitterMixin`. It makes assumptions about code style.
* *Fix:* Browser initialisation.
* *Fix:* Bug where `EmitterMixin` would not correctly set default context.

## 0.2.0 (2012-11-14)

* *Feature:* Implemented `ProxyMixin` for easy global event bus handling.
* *Feature:* Implemented `Subscription` objects.
* *Feature:* Implemented `EmitterMixin` for easy attachment of an instance-local `EventBus`.

## 0.1.1 (2012-11-12)

* `npm` related fixes.

## 0.1.0 (2012-11-12)

* Initial public release.
* *Feature:* `EventBus` implementation.
