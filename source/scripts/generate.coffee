dom = require './dom.coffee'
animations = require './animations.coffee'
language = require './language.coffee'

getTitle = () -> dom.form.title.val()

isUsable = (title) -> title.replace(/ /g, "") isnt ""

# I tried to make this in a functional-like programming style
# module.exports is a function that returns a function
# the advantage is that module.exports gets a socket
# the returned function is latched to the socket
module.exports = (socket) ->
    (title = getTitle()) ->
        if isUsable title
            animations.searchbar.hide()
            animations.loading.show()
            socket.emit "get page",
                title: title
                language: language()