class socketHandler
	constructor: (@DOM) ->

	newPage: (page) ->
		@DOM.loadingScreen.remove() # because it is no longer loading
		@DOM.titleSection.children().show() # return title section to normal
		@DOM.slides.append makeSection page

	newImage: (image) ->
		if not @DOM.titleSection.attr("data-background")?
			@DOM.titleSection.attr "data-background", image.url
			Reveal.initialize()
