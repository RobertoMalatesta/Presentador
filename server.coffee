express = require 'express'
http = require 'http'
socketio = require 'socket.io'
easypedia = require 'easypedia'
logarithmic = require 'logarithmic'
fotology = require 'fotology'

app = express()
server = http.Server app
io = socketio.listen server

app.use express.static __dirname + '/public'

app.get '/', (request, response) ->
	response.render 'index.jade'
app.get '/:topic', (request, response) ->
	response.render 'index.jade'

maxLinks = process.env.MAXLINKS or 30 # how many links to search for

io.sockets.on 'connection', (client) ->
	client.on 'get page', (pageName) ->
		easypedia pageName, (page) ->
			io.to(client.id).emit 'new page', page

			# Wikipedia has a list of the images in a page
			# because we know those images exist, we want to use them
			# however, getting the images from Wikipedia is slow
			# thus, just search for the images on Google Image search
			# also, if no images were found, just use the original pageName
			imageSearchTerm = pageName
			options =
				size: "large"
				safe: true
			fotology imageSearchTerm, options, (imageURLs) ->
				io.to(client.id).emit 'new image', imageURLs[0]

			for link in page.links.slice 0, maxLinks
				easypedia link, (relatedPage) ->
					if page.name in relatedPage.links
						io.to(client.id).emit 'new page', relatedPage

port = process.env.PORT or 80
hostname = process.env.HOSTNAME or '0.0.0.0'
backlog = process.env.BACKLOG or 512
server.listen port, hostname, backlog, ->
	logarithmic.ok "Server started on port", port
	logarithmic.alert ""
