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

socket.on 'new page', (page) ->
	loading.remove()
	titleSection.children().show()
	slides.append makeSection page

socket.on 'new image', (image) ->
	if not titleSection.attr("data-background")?
		titleSection.attr "data-background", image.url
		Reveal.initialize()

slideSpeed = 350 # milliseconds

generate = (title = titleForm.val()) ->
	if title.replace(/ /g, "") isnt ""
		# clear the searchbar and move it away
		titleForm.val("")
		inputArea.slideUp slideSpeed

		# say the page is loading
		titleSection.children().hide()
		loading.show()
		setTimeout () ->
			beenAWhile.show()
		, 3000

		# ask for the page
		socket.emit "get page", title

generateButton.click () ->
	generate()

$(document).keydown (event) ->
	if event.keyCode is 220
		if inputArea.css("display") is "none"
			inputArea.slideDown slideSpeed
		else
			inputArea.slideUp slideSpeed


# if the URL is something like presentr.tk/Karl_Marx then start with Karl Marx
$(document).ready () ->
	# if the url is presentador.co/TOPIC+OTHERTOPIC+NEXTONE then TOPIC, OTHERTOPIC, NEXTONE are topics
	startTopics = (/[^/]*$/.exec(window.location.href)[0]).replace(/_/g, " ")
	if startTopics isnt ""
		for startTopic in startTopics.split "+"
			generate startTopic

	# jQuery had a bug where it registered the enter press many times, so use pure JS
	titleForm[0].onkeypress = (event) -> # titleForm[0] is a HTML object, not jQuery object
		if event.keyCode is 13 # enter key
			generate()

Reveal.initialize
	center: true
