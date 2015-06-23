cluster = require 'cluster'
logarithmic = require 'logarithmic'

if cluster.isMaster
	slaves = process.env.SLAVES ? require("os").cpus().length ? 2
	cluster.fork() for [1..slaves]
	logarithmic.alert "Now making", slaves, "slaves"

	cluster.on "exit", () ->
		logarithmic.warning "A slave died. Now trying to respawn"
		cluster.fork()

else
	express = require 'express'
	http = require 'http'

	app = express()
	server = http.createServer app

	app.use express.static __dirname + '/public'

	app.get '/', (request, response) ->
		response.render "index.jade"

	port = process.env.PORT ? 8080
	hostname = process.env.HOSTNAME ? "0.0.0.0"
	backlog = process.env.BACKLOG ? 512
	server.listen port, hostname, backlog, () ->
		logarithmic.ok "Slave running on port", port
