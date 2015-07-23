# Description
#   A hubot wit.ai router
#
# Configuration:
#   HUBOT_WIT_TOKEN
#
# Commands:
#   hey (hey,) - <what the respond trigger does>
#
# Notes:
#   response from wit.ai will trigger event with intent as the event name and entities in JSON object as parameters
#
# Author:
#   tianwei.liu <tianwei.liu@target.com>

module.exports = (robot) ->
	robot.respond /hey[, ](.*)/i, (res) ->
		query = res.match[1]
		console.log "query: #{query}"
		unless process.env.HUBOT_WIT_TOKEN?
			res.send "i am not on wit's friendlist yet. :("
			console.log "HUBOT_WIT_TOKEN not set"
			return

		robot.http("https://api.wit.ai/message?q=#{encodeURI(query)}")
		.header('Content-Type', 'application/json')
		.header('Authorization', 'Bearer ' + process.env.HUBOT_WIT_TOKEN)
		.header('Accept', 'application/vnd.wit.20141022+json')
		.get() (err, r, body) ->
			if err
				res.send "Wit needs coffee :| #{err}"
				console.log "wit error: #{err}"
				return
			
			# got response back, routing
			json = JSON.parse(body)
			console.log "wit response: #{body}"
			for intent in json.outcomes
				do(intent) ->
					robot.emit "#{intent.intent}", intent.entities
					console.log "emit event: #{intent.intent}, #{intent.entities}"
