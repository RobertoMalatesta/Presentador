# yes I am using MongoDB
# please don't kill me, /r/programming
mongoose = require 'mongoose'
logarithmic = require 'logarithmic'
easypedia = require 'easypedia'
Page = require './models/page'

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
    logarithmic.warning "Could not connect to MongoDB. Forget to run `mongod`?"
    logarithmic.alert "Will make an Easypedia call every time"
    module.exports = easypedia

mongoose.connection.on "open", ->
    logarithmic.ok "Connected to Mongoose"

    Page.find (error, pages) ->
        logarithmic.alert "Current pages in the database:"
        console.log pages.map (page) -> page.name

    module.exports = (pagename, options, next) ->
        Page.find {name: pagename, language: options.language}, (error, pages)->
            console.log pages
