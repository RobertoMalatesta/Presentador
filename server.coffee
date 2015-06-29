express = require 'express'
http = require 'http'
socketio = require 'socket.io'
easypedia = require 'easypedia'
logarithmic = require 'logarithmic'

app = express()
server = http.Server(app)
io = socketio.listen(server)

app.use express.static __dirname + '/public'

app.get '/', (request, response) ->
	response.render 'index.jade'
app.get '/:topic', (request, response) ->
	response.render 'index.jade'

io.sockets.on 'connection', (client) ->
	client.on 'hello', (name) ->
		console.log name

	client.on 'get page', (pageName) ->
		easypedia pageName, (page) ->
			io.to(client.id).emit('new page', page);

			maxLinks = process.env.MAXLINKS or Infinity # how many links to search for
			for link in page.links.slice(0, maxLinks)
				easypedia link, (relatedPage) ->
					if page.name in relatedPage.links
						io.to(client.id).emit 'new page', relatedPage

port = process.env.PORT or 80
hostname = process.env.HOSTNAME or '0.0.0.0'
backlog = process.env.BACKLOG or 512
server.listen port, hostname, backlog, ->
	logarithmic.ok "Server started on port", port
