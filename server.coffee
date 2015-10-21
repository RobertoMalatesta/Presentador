express = require 'express'
http = require 'http'
socketio = require 'socket.io'
logarithmic = require 'logarithmic'
fotology = require 'fotology'
compression = require 'compression'
mongoose = require 'mongoose' # please don't kill me, /r/programming
easypedia = require 'easypedia'
langify = require 'langify'
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
getPage = (name, options, next) ->
  easypedia name, options, (error, page) ->
    if error
      logarithmic.error error
    else
      next page
getImage = (searchterm, options, next) ->
  options.size = "large"
  fotology searchterm, options, (links) ->
    if links then next links

logarithmic.alert "Trying to connect to the database"
mongoose.connect databaseURI

mongoose.connection.on 'error', ->
  logarithmic.warning "Could not connect to MongoDB. Forget to run `mongod`?"
  logarithmic.alert "Will make an Easypedia call every time"

mongoose.connection.on "open", ->
  logarithmic.ok "Connected to Mongoose"

  getPage = (pagename, options, next) ->
    options.language = options.language or "English"
    searchQuery =
      name: pagename
      language: langify options.language
    logarithmic.alert "Look for #{pagename} in #{options.language} page DB"
    Page.findOne searchQuery, (finderror, databasePage)->
      if finderror
        logarithmic.warning finderror
      else if not databasePage?
        logarithmic.alert "#{pagename} not in #{options.language} page DB"
        logarithmic.alert "Get #{pagename} from Easypedia"
        easypedia pagename, options, (easypediaerror, page) ->
          if easypediaerror
            logarithmic.warning easypediaerror
          else
            pageEntry =
              # the database matches the search terms to the pages
              # thus, it uses the search name and language, not the page's
              name: pagename
              language: langify options.language
              links: page.links
              sections: page.sections
            next pageEntry
            Page.create pageEntry, (createerror) ->
              if createerror
                logarithmic.warning createerror
              else
                logarithmic.ok "Saved #{pagename} to the pages DB"

      else if databasePage?
        logarithmic.ok "Found #{pagename} in the #{options.language} page DB"
        next
          name: databasePage.name
          sections: databasePage.sections
          links: databasePage.links

  getImage = (imagename, options, next) ->
    imagename = imagename.toLowerCase()
    options.language = options.language or "English"
    logarithmic.alert "Look in image database for #{imagename}"
    searchQuery =
      name: imagename
      language: langify options.language
    Image.findOne searchQuery, (error, databaseImage)->
      if not databaseImage
        logarithmic.alert "#{imagename} not in image database"
        options.size = "large"
        fotology imagename, options, (images) ->
          if not images
            return
          logarithmic.ok "Find #{imagename} from the Google API"
          imageEntry =
            name: imagename
            # the database matches the search terms to the pages
            # thus, it uses the search lang, not the page lang
            language: langify options.language
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

io.sockets.on 'connection', (client) ->
  sendPage = (page) ->
    io.to(client.id).emit 'new page', page

  sendImage = (image) ->
    io.to(client.id).emit 'new image', image

  sendError = (image) ->
    io.to(client.id).emit 'new error', image

  client.on 'get page', (page) ->

    getPage page.title, {language: page.language}, (mainpage) ->
      logarithmic.ok "Send #{page.title} in #{page.language} to the client"
      sendPage mainpage

      getImage page.title, {}, sendImage

      # Wikipedia has a list of the images in a page
      # because we know those images exist, we want to use them
      # however, getting the images from Wikipedia is slow
      # thus, just search for the images on Google Image search
      # also, if no images were found, just use the original pagename
      imageSearchTerm = page.title
      options =
        size: "large"
        safe: true
        language: langify page.language

      isInside = (array) ->
        (element) -> array.indexOf(element) isnt -1
      intersection = (firstArray, secondArray) ->
        firstArray.filter isInside secondArray
      areRelated = (firstPage, secondPage) ->
        meanLength = Math.sqrt firstPage.links.length * secondPage.links.length
        minimumIntersectionLength = Math.sqrt meanLength
        pageIntersection = intersection firstPage.links, secondPage.links
        intersectEnough = pageIntersection.length >= minimumIntersectionLength
        intersectEnough

      for link in mainpage.links
        getPage link, {language: page.language}, (linkedPage) ->
          if areRelated mainpage, linkedPage
            sendPage linkedPage
            getImage linkedPage.name, {}, (image) ->
              sendImage image
          else
            logarithmic.alert (
              "#{linkedPage.name} and #{mainpage.name} are not related"
            )

port = process.env.PORT or 80
hostname = process.env.HOSTNAME or '0.0.0.0'
backlog = process.env.BACKLOG or 512
server.listen port, hostname, backlog, ->
  logarithmic.ok "Server started on port", port
