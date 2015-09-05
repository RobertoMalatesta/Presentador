express = require 'express'
http = require 'http'
socketio = require 'socket.io'
logarithmic = require 'logarithmic'
fotology = require 'fotology'
compression = require 'compression'
mongoose = require 'mongoose' # please don't kill me, /r/programming
easypedia = require 'easypedia'
Page = require './models/page'
Image = require './models/image'

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
getImage = fotology

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
        pageexists = false
        setTimeout ->
          if not pageexists
            logarithmic.alert "#{pagename} does not exist"
            next undefined
        , 3000

        easypedia pagename, options, (page) ->
          pageexists = true
          logarithmic.ok "Found #{pagename} from the Wikipedia API"
          pageEntry =
            name: page.name
            # the database matches the search terms to the pages
            # thus, it uses the search lang, not the page lang
            language: options.language
            links: page.links
            text: page.text
          next pageEntry
          Page.create pageEntry, (error, newpage) ->
            if error
              logarithmic.warning error
            else
              logarithmic.ok "Saved #{pagename} to the DB"

      else # if the page is in the database
        logarithmic.ok "Found the entry for #{pagename} in the database"

        next
          name: databasePage.name
          language: databasePage.language
          text: databasePage.text
          links: databasePage.links

  getImage = (imagename, options, next) ->
    imagename = imagename.toLowerCase()
    logarithmic.alert "Looking in the database for #{imagename}"
    searchQuery =
      name: imagename
      language: options.language
    Image.findOne searchQuery, (error, databaseImage)->
      if not databaseImage
        logarithmic.alert "#{imagename} is not in the database"
        options.size = "medium"
        fotology imagename, options, (images) ->
          logarithmic.ok "Found #{imagename} from the Google API"
          imageEntry =
            name: imagename
            # the database matches the search terms to the pages
            # thus, it uses the search lang, not the page lang
            language: options.language
            url: images[0]
          next imageEntry
          Image.create imageEntry, (error, newimage) ->
            if error
              logarithmic.warning error
            else
              logarithmic.ok "Saved #{imagename} to the database"

      else # if the page is in the database
        logarithmic.ok "Found the entry for #{imagename} in the DB"

        next
          name: databaseImage.name
          language: options.language
          url: databaseImage.url

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

  sendImage = (image) ->
    io.to(client.id).emit 'new image', image

  client.on 'get page', (page) ->

    getPage page.title, {language: page.language}, (mainpage) ->
      if not mainpage?
        logarithmic.alert "#{page.title} could not be found"
        sendPage
          title: page.title
          exists: false
        return

      sendPage mainpage
      getImage page.title, {}, sendImage

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

      isRelated = (possible) ->
        if not possible?
          return false
        mainpage.name in possible.links

      for link in mainpage.links.slice 0, maxLinks
        getPage link, {language: page.language}, (linkedPage) ->
          if isRelated linkedPage
            sendPage linkedPage
            getImage linkedPage.name, {}, sendImage

port = process.env.PORT or 80
hostname = process.env.HOSTNAME or '0.0.0.0'
backlog = process.env.BACKLOG or 512
server.listen port, hostname, backlog, ->
  logarithmic.ok "Server started on port", port
