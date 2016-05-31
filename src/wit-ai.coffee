# Description
#   A hubot wit.ai router
#
# Configuration:
#   HUBOT_WIT_TOKEN=SERVER_TOKEN
#   HUBOT_WIT_VERSION=20160527 (specify your version)
#
# Commands:
#   hey hubot (hey hubot,) <dialog> - Ask me something. I may or may not understand you.
#	hubot hey (hubot hey,) <dialog> - Ask me something. I may or may not understand you.
#
# Notes:
#   response from wit.ai will trigger event with intent as the event name and entities in JSON object as parameters
#
# Author:
#   tianwei.liu <tianwei.liu@target.com>

module.exports = (robot) ->
	robot.respond /hey(, | )(.*)/i, (res) ->
		query = res.match[2]
		console.log "query: #{query}"
		askWit(query, res)

	robot.hear ///hey\s+#{robot.name}(,\s+|\s+)(.*)///i, (res) ->
		query = res.match[2]
		console.log "query: #{query}"
		askWit(query, res)

	askWit = (query, res) ->
		unless process.env.HUBOT_WIT_TOKEN?
			res.send "i am not on wit's friendlist yet. :("
			console.log "HUBOT_WIT_TOKEN not set"
			return

		robot.http("https://api.wit.ai/message?v=#{process.env.HUBOT_WIT_VERSION}&q=#{encodeURI(query)}")
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
			if json.outcomes.length > 0
				for intent in json.outcomes
					do(intent) ->
						robot.emit "#{intent.intent}", {
							res: res
							entities: intent.entities
						}
						console.log "emit event: #{intent.intent}"
			else
				res.send "Sorry, could you please try to rephrase that in binary?"
