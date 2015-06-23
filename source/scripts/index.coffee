socket = io.connect "http://localhost:8080"

socket.on 'new page', (page) ->
	console.log page # TODO: insert the page into the DOM

$("#generate").click () ->
    title = $("#title").val()
    socket.emit "get page", title
    $("#input-area").remove()

Reveal.initialize({
	center: true
})
