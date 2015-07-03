socket = io.connect()

correctMarkup = (sentence) ->
	sentence.indexOf("|") is -1 and sentence.indexOf("{{") is -1

useful = (sentence) ->
	sentence.length > 40 and correctMarkup sentence

slides = $(".slides") # cache

class section
	constructor: (@json) ->
		@id = @json.name
			.replace(/[\.,-\/#!$%\^&\*;:{}=\-_`~()]/g, "")
			.replace(/\s{2,}/g,"")
			.replace(/ /g, "")
			.toLowerCase()
		if "#" in @json.name
			@name = @json.name
				.substring(/#/g, @json.name.indexOf("#"))
				.replace(/_/g, " ")
			@subtitle = @json.name
				.substring(@json.name.indexOf("#") + 1)
				.replace(/_/g, " ")
		else
			@name = @json.name
				.replace(/_/g, " ")

	use: () ->
		maxLength = 400 # how many characters a slide can have
		topSection = $("##{@id}") # cache it now

		# don't add a slide if one exists with the same id
		if topSection.length isnt 0
			return

		slides.append "<section id='#{@id}'>
			<section>
				<h1>#{@name}</h1>
				<h2>#{@subtitle or ""}</h1>
			</section>
		</section>"
		topSection = $("##{@id}") # cache it now
		if not @subtitle # if all the page needs to be added
			for keySection, section of @json.text
				paragraph = ""
				for sentence in section
					paragraph += sentence.text + " " if paragraph.length < maxLength and useful sentence.text
				if paragraph.length > 70
					topSection.append "<section><h2>#{keySection}</h2><p>#{paragraph}</p></section>"

		else # if only a singple section needs to be added
			groups = []
			currentGroup = ""
			for sentence in @json.text[@subtitle]
				if currentGroup.length < maxLength
					currentGroup += sentence.text + " "
				else
					groups.push currentGroup
					currentGroup = sentence.text + " " # reset it

			sectionHTML = ""
			for group in groups
				sectionHTML += "<section><p>#{group}</p></section>"
			topSection.append(sectionHTML)

socket.on 'new page', (page) ->
	$('#loading').remove()
	titleSection.children().show()
	new section(page).use()

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
