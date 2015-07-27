express = require 'express'
http = require 'http'
socketio = require 'socket.io'
easypedia = require 'easypedia'
logarithmic = require 'logarithmic'
fotology = require 'fotology'
compression = require 'compression'

app = express()
server = http.Server app
io = socketio.listen server

app.use express.static __dirname + '/public'
app.use compression()

app.use require("./routes.coffee")

maxLinks = process.env.MAXLINKS or 30 # how many links to search for

io.sockets.on 'connection', (client) ->
    sendPage = (page) ->
        io.to(client.id).emit 'new page', page

    sendImage = (imageURL) ->
        io.to(client.id).emit 'new image', imageURL

    client.on 'get page', (page) ->

        easypedia page.title, {language: page.language}, (mainpage) ->
            sendPage mainpage

            # Wikipedia has a list of the images in a page
            # because we know those images exist, we want to use them
            # however, getting the images from Wikipedia is slow
            # thus, just search for the images on Google Image search
            # also, if no images were found, just use the original pageName
            imageSearchTerm = page.title
            options =
                size: "large"
                safe: true
                language: page.language
            fotology imageSearchTerm, options, (imageURLs) ->
                sendImage imageURLs[0]

            isRelated = (possible) ->
                mainpage.name in possible.links

            for link in mainpage.links.slice 0, maxLinks
                easypedia link, {language: page.language}, (linkedPage) ->
                    if isRelated linkedPage
                        sendPage linkedPage

port = process.env.PORT or 80
hostname = process.env.HOSTNAME or '0.0.0.0'
backlog = process.env.BACKLOG or 512
server.listen port, hostname, backlog, ->
    logarithmic.ok "Server started on port", port
