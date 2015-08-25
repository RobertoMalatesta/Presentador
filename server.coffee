express = require 'express'
http = require 'http'
socketio = require 'socket.io'
logarithmic = require 'logarithmic'
fotology = require 'fotology'
compression = require 'compression'
mongoose = require 'mongoose' # please don't kill me, /r/programming
easypedia = require 'easypedia'
Page = require './models/page'

databaseURI = process.env.MONGO_URI || 'localhost'

if process.env.VERBOSE is "FALSE"
    # hide everything except for Error messages
    logarithmic =
        alert: () -> null
        ok: () -> null
        warning: () -> null
        error: logarithmic.error

# will use the database in the following lines
getPage = easypedia

logarithmic.alert "Trying to connect to the database"
mongoose.connect databaseURI

mongoose.connection.on 'error', ->
    logarithmic.warning "Could not connect to MongoDB. Forget to run `mongod`?"
    logarithmic.alert "Will make an Easypedia call every time"

mongoose.connection.on "open", ->
    logarithmic.ok "Connected to Mongoose"

    getPage = (pagename, options, next) ->
        logarithmic.alert "Looking in the database for #{pagename}"
        searchQuery =
            name: pagename
            language: options.language
        Page.findOne searchQuery, (error, databasePage)->
            if not databasePage
                logarithmic.alert "#{pagename} is not in the database"
                easypedia pagename, options, (page) ->
                    logarithmic.ok "Found #{pagename} from the Wikipedia API"
                    next page
                    pageEntry =
                        name: page.name
                        # the database matches the search terms to the pages
                        # thus, it uses the search lang, not the page lang
                        language: options.language
                        links: page.links
                        text: page.text
                    Page.create pageEntry, (error, newpage) ->
                        if error
                            logarithmic.warning error
                        else
                            logarithmic.ok "Saved #{pagename} to the database"

            else # if the page is in the database
                logarithmic.ok "Found the entry for #{pagename} in the database"

                next
                    name: databasePage.name
                    language: databasePage.language
                    text: databasePage.text
                    links: databasePage.links

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

        getPage page.title, {language: page.language}, (mainpage) ->
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
                getPage link, {language: page.language}, (linkedPage) ->
                    if isRelated linkedPage
                        sendPage linkedPage

port = process.env.PORT or 80
hostname = process.env.HOSTNAME or '0.0.0.0'
backlog = process.env.BACKLOG or 512
server.listen port, hostname, backlog, ->
    logarithmic.ok "Server started on port", port
