makeSection = require './section.coffee'

socket = io.connect()

slides = $(".slides") # cache it

socket.on 'new page', (page) ->
	$('#loading').remove()
	titleSection.children().show()
	slides.append makeSection page

socket.on 'new image', (image) ->
	if not $("#title-section").attr("data-background")?
		$("#title-section").attr "data-background", image.url
		Reveal.initialize()

slideSpeed = 350 # milliseconds

titleSection = $("#title-section")
generate = (title = $("#title").val()) ->
	if title.replace(/ /g, "") isnt ""
		# clear the searchbar and move it away
		$("#title").val("")
		$("#input-area").slideUp slideSpeed

		# say the page is loading
		titleSection.children().hide()
		$("#loading").show()
		setTimeout () ->
			$("#beenAWhile").show()
		, 3000

		# ask for the page
		socket.emit "get page", title

$("#generate").click () ->
	generate()

$(document).keydown (event) ->
	if event.keyCode is 220
		if $("#input-area").css("display") is "none"
			$("#input-area").slideDown slideSpeed
		else
			$("#input-area").slideUp slideSpeed


# if the URL is something like presentr.tk/Karl_Marx then start with Karl Marx
$(document).ready () ->
	# if the url is presentador.co/TOPIC+OTHERTOPIC+NEXTONE then TOPIC, OTHERTOPIC, NEXTONE are topics
	startTopics = (/[^/]*$/.exec(window.location.href)[0]).replace(/_/g, " ")
	if startTopics isnt ""
		for startTopic in startTopics.split "+"
			generate startTopic

	# jQuery had a bug where it registered the enter press many times, so use pure JS
	document.getElementById("title").onkeypress = (event) ->
		if event.keyCode is 13 # enter key
			generate()

Reveal.initialize
	center: true
