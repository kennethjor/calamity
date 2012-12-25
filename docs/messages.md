# Messages, Events, Commands, Futures, and Progresses.

## Message
`Message` is the base class for message passing.

## Event
`Event` is the first addition to `Message`.
It's the most commonly used class, and represents something which happened in the past:
e.g. A button click, a model change, or the result of a command.

## Command
`Command` is the second addition to `Message`.
It represents a desired action and is used to convey intent from one part of the application to the other.
They are used to keep everything loosely coupled, but still allow non-idempotent communication.

## Future
`Future` is an addition to `Command`.
When a `Command` is sent to the bus, a`Future` object is returned.
This object is used to manage message handler for when an event comes back from a command.

## Progress
`Progress` is the third extension to `Message`.
It is used to represent the status of an existing command, as it is being executed.
Command executors can use this to report back about the status if a long running job.
Completion notification should be done using normal `Events`.
