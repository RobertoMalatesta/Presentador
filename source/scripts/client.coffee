makeSection = require './section.coffee'
animations = require "./animations.coffee"
dom = require './dom.coffee'

socket = io.connect()
generate = require('./generate.coffee')(socket)

socket.on 'new page', (page) ->
    animations.loading.hide()
    dom.div.slides.append makeSection page

socket.on 'new image', (imageURL) ->
    if not dom.section.title.attr("data-background")?
        dom.section.title.attr "data-background", imageURL
        Reveal.initialize()

dom.button.generate.click () ->
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
    dom.form.title[0].onkeypress = (event) ->
        generate() if event.keyCode is 13 # enter key
    dom.form.language[0].onkeypress = (event) ->
        generate() if event.keyCode is 13 # enter key

    random = (upperbound) -> Math.floor Math.random() * upperbound

    dom.video.loading.attr "src", "images/loading/#{random 15}.mp4"

Reveal.initialize
    center: true
