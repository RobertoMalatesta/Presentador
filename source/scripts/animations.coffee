dom = require './dom.coffee'

module.exports =
    speed:
        slide: 350
        fade: 200

    searchbar:
        hide: () ->
            dom.form.title.val("")
            dom.div.inputArea.slideUp animations.speed.slide

        show: () ->
            dom.div.inputArea.slideDown animations.speed.slide

        toggle: () ->
            if dom.div.inputArea.css("display") is "none"
                animations.searchbar.show()
            else
                animations.searchbar.hide()
