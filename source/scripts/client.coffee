makeSection = require './section.coffee'

socket = io.connect()

# cache the DOM elements that will be used
slides = $ ".slides"
loading = $ "#loading"
titleSection = $ "#title-section"
titleForm = $ "#title"
inputArea = $ "#input-area"
beenAWhile = $ "#beenAWhile"
generateButton = $ "#generate"
languageForm = $ "#language"

animations =
    speed:
        slide: 350
        fade: 200

    loading:
        hide: () ->
            loading.remove()
            titleSection.children().show()
        show: () ->
            titleSection.children().hide()
            loading.show()
            setTimeout () ->
                beenAWhile.show()
            , 3000

    searchbar:
        hide: () ->
            titleForm.val("")
            inputArea.slideUp animations.speed.slide

        show: () ->
            inputArea.slideDown animations.speed.slide

        toggle: () ->
            if inputArea.css("display") is "none"
                animations.searchbar.show()
            else
                animations.searchbar.hide()

socket.on 'new page', (page) ->
    animations.loading.hide()
    slides.append makeSection page

socket.on 'new image', (imageURL) ->
    if not titleSection.attr("data-background")?
        titleSection.attr "data-background", imageURL
        Reveal.initialize()

generate = (title = titleForm.val(), language = languageForm.val()) ->
    if title.replace(/ /g, "") isnt ""
        animations.searchbar.hide()
        animations.loading.show()
        socket.emit "get page", {title: title, language: language}

generateButton.click () ->
    generate()

$(document).keydown (event) ->
    if event.keyCode is 220 # backslash
        animations.searchbar.toggle()

$(document).ready () ->
    # takes in a url and returns everything after the first /
    # extractTopics "google.com/AbhinavMadahar#Swag" -> "AbhinavMadahar#Swag"
    extractTopics = (url) ->
        (/[^/]*$/.exec(url)[0]).replace(/_/g, " ")

    startTopics = extractTopics window.location.href
    if startTopics isnt ""
        generate startTopic for startTopic in startTopics.split "+"

    # jQuery objects do not have a .onkeypress
    # that is what DOM objects have, so we need that
    # the 0th object in a jQuery object is the DOM element
    # titleForm[0] is the DOM element, so use it
    titleForm[0].onkeypress = (event) ->
        generate() if event.keyCode is 13 # enter key
    languageForm[0].onkeypress = (event) ->
        generate() if event.keyCode is 13 # enter key

Reveal.initialize
    center: true
