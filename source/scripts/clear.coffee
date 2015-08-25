# this function clears the sections except for the title section

dom = require './dom'

module.exports = ->
    for child in dom.div.slides.children().slice 1
        child.remove()

    $(".navigate-left.enabled").click()
