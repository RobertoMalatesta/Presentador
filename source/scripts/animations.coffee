dom = require './dom.coffee'

module.exports = animations =
    speed:
        slide: 350
        fade: 200

    searchbar:
        hide: ->
            dom.form.title.val("")
            dom.div.input.slideUp animations.speed.slide

        show: ->
            dom.div.input.slideDown animations.speed.slide

        toggle: ->
            if dom.div.input.css("display") is "none"
                animations.searchbar.show()
            else
                animations.searchbar.hide()
