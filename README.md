# hubot-wit-ai

A hubot wit.ai router

See [`src/wit-ai.coffee`](src/wit-ai.coffee) for full documentation.

## Installation

In hubot project repo, run:

`npm install hubot-wit-ai --save`

Then add **hubot-wit-ai** to your `external-scripts.json`:

```json
[
  "hubot-wit-ai"
]
```

## Sample Interaction

```
user1>> hey hubot, what is the weather like tomorrow?
(hubot send "what is the weather like tomorrow" to wit.ai and emit intent as event)
```

or

```
user1>> @hubot: hey what is the weather like tomorrow?
(hubot send "what is the weather like tomorrow" to wit.ai and emit intent as event)
```