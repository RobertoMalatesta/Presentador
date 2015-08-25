dom = require './dom.coffee'

state =
    fullscreen: false

module.exports = animations =
    speed:
        slide: 350
        fade: 500

    searchbar:
        hide: ->
            dom.form.title.val("")
            dom.div.input.slideUp animations.speed.slide
            dom.button.show.show()

        show: ->
            dom.div.input.slideDown animations.speed.slide
            dom.button.show.hide()

        toggle: ->
            if dom.div.input.css("display") is "none"
                animations.searchbar.show()
            else
                animations.searchbar.hide()

    title:
        hide: ->
            dom.section.title
                .fadeOut animations.speed.fade

    body:
        fullscreen:
            enable: ->
                document.body.webkitRequestFullScreen.apply(document.body)
                state.fullscreen = true

            disable: ->
                document.webkitCancelFullScreen() or
                document.mozCancelFullScreen() or
                document.cancelFullScreen()

            toggle: ->
                if state.fullscreen
                    animations.body.fullscreen.disable()
                else
                    animations.body.fullscreen.enable()
