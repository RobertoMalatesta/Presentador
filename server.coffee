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
	socketio = require 'socket.io'
	easypedia = require 'easypedia'

	app = express()
	server = http.Server app
	io = socketio server

	app.use express.static __dirname + '/public'

	app.get '/', (request, response) ->
		response.render "index.jade"
	io.sockets.on 'connection',	(client) ->
		client.on 'error', (err) -> logarithmic.error err.stack

		client.on 'get page', (pageName) ->
			easypedia pageName, (page) ->
				io.to(client.id).emit('new page', page);
				maxLinks = 20 # how many links to search for
				for link in page.links.slice(0, maxLinks)
					easypedia link, (relatedPage) ->
						if page.name in relatedPage.links
							io.to(client.id).emit('new page', relatedPage);

	port = process.env.PORT ? 8080
	hostname = process.env.HOSTNAME ? "0.0.0.0"
	backlog = process.env.BACKLOG ? 512
	server.listen port, hostname, backlog, () ->
		logarithmic.ok "Slave running on port", port
