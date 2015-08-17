# yes I am using MongoDB
# please don't kill me, /r/programming
mongoose = require 'mongoose'
logarithmic = require 'logarithmic'
easypedia = require 'easypedia'

if process.env.VERBOSE is "FALSE"
    # hide everything except for Error messages
    logarithmic =
        alert: () -> null
        ok: () -> null
        warning: () -> null
        error: logarithmic.error

databaseURI = process.env.MONGO_URI || 'localhost'

mongoose.connect databaseURI

mongoose.connection.on 'error', ->
    logarithmic.warning 'Could not connect to MongoDB. Forget to run `mongod`?'
    logarithmic.alert "Switching over to a RAM-based database"

databaseStorage = {}

databaseContains = (pagename, language) ->
    databaseStorage[language]?[pagename]?

database = (pagename, options, next) ->
    logarithmic.alert "Now trying to open #{pagename} from the database"
    if databaseContains pagename, options.language
        logarithmic.ok "Found #{pagename} and calling the callback"
        next databaseStorage[options.language][pagename]
    else
        logarithmic.warning "Could not find #{pagename} so calling Wikipedia"
        easypedia pagename, options, (page) ->
            logarithmic.ok "Got #{pagename} back from Wikipedia"
            logarithmic.alert "Saving #{pagename} to the database"
            if not databaseStorage[options.language]?
                databaseStorage[options.language] = {}
            databaseStorage[options.language][page.name] = page
            next page

module.exports = database
