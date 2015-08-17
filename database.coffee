# yes I am using MongoDB
# please don't kill me, /r/programming
mongoose = require 'mongoose'
logarithmic = require 'logarithmic'
easypedia = require 'easypedia'

databaseURI = process.env.MONGO_URI || 'localhost'

mongoose.connect databaseURI

mongoose.connection.on 'error', ->
    logarithmic.warning 'Could not connect to MongoDB. Did you forget to run `mongod`?'
    logarithmic.alert "Switching over to saving to the RAM"

databaseStorage = {}

databaseContains = (pagename, language) ->
    databaseStorage[language]?[pagename]?

database = (pagename, options, next) ->
    logarithmic.alert "Now trying to open #{pagename}"
    if databaseContains pagename, options.language
        logarithmic.alert "Found #{pagename} and calling the callback"
        next databaseStorage[options.language][pagename]
    else
        logarithmic.alert "Could not find #{pagename} and asking Wikipedia"
        easypedia pagename, options, (page) ->
            logarithmic.alert "Got the result back from Wikipedia for #{pagename}"
            if not databaseStorage[options.language]?
                databaseStorage[options.language] = {}
            databaseStorage[options.language][page.name] = page
            next page

module.exports = database
