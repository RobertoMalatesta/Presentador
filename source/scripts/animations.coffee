dom = require './dom.coffee'

module.exports = animations =
    speed:
        slide: 350
        fade: 200

    loading:
        hide: () ->
            dom.section.loading.remove()
            dom.section.title.children().show()
        show: () ->
            dom.section.title.children().hide()
            dom.section.loading.show()
            setTimeout () ->
                dom.section.beenAWhile.show()
            , 3000

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
