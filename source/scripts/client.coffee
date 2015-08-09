###
This file is the main file for the client

This is the file that is called in the <script> tag
Thus, it is the only one with access to the global variables
Socket.io has its client code as a global variable,
so this is the only file that can manage client socketing

Most of the actual work and complexity resides in other files
###

makeSection = require './make.coffee'
animations = require "./animations.coffee"
dom = require './dom.coffee'

# connect to the server via a websocket
# then tell the generate function where to send the "new page" requests
socket = io.connect()
generate = require('./generate.coffee')(socket)

socket.on 'new page', (page) ->
    dom.div.slides.append makeSection page

socket.on 'new image', (imageURL) ->
    # to change the background image of a slide, Reveal has to restart
    # thus, it only restarts once at the start of the presentation
    # that way, the screen doesn't reset whenever another section is added
    if not dom.section.title.attr("data-background")?
        dom.section.title.attr "data-background", imageURL
        Reveal.initialize()

dom.button.generate.click generate
dom.button.showMenubar.click animations.searchbar.toggle

$(document).keydown (event) ->
    if event.keyCode is 220 # backslash
        animations.searchbar.toggle()

$(document).ready ->
    # takes in a url and returns everything after the first /
    # extractTopics "google.com/AbhinavMadahar#Swag" -> "AbhinavMadahar#Swag"
    extractTopics = (url) ->
        (/[^/]*$/.exec(url)[0]).replace(/_/g, " ")

    startTopics = extractTopics window.location.href
    if startTopics isnt ""
        startTopics.split("+").map generate

    # jQuery objects do not have a .onkeypress
    # that is what DOM objects have, so we need that
    # the 0th object in a jQuery object is the DOM element
    # titleForm[0] is the DOM element, so use it
    dom.form.title[0].onkeypress = (event) ->
        generate() if event.keyCode is 13 # enter key
    dom.form.language[0].onkeypress = (event) ->
        generate() if event.keyCode is 13 # enter key

Reveal.initialize
    center: true
