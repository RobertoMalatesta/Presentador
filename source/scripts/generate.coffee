# this function defines how to generate a presentation
# it takes in a socket where it can latch to

langify = require 'langify'
dom = require './dom.coffee'
animations = require './animations.coffee'

getTitle = -> dom.form.title.val()

isUsable = (title) -> title.replace(/ /g, "") isnt ""

# I tried to make this in a functional-like programming style
# module.exports is a function that returns a function
# the advantage is that module.exports gets a socket
# the returned function is latched to the socket
module.exports = (socket) ->
    (title = getTitle()) ->
        language = dom.form.language.val()
        languageCode = langify language

        if language is ""
            languageCode = "en"

        else if language? and not languageCode? # if a bad language was given
            Materialize.toast "#{language} is not a valid language", 4000
            return

        if isUsable title
            animations.searchbar.hide()
            socket.emit "get page",
                title: title
                language: language
