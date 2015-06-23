socket = io.connect "http://localhost:8080"
socket.on 'connect', (data) ->
    socket.emit 'join', 'Hello World from client'

socket.on 'new page', (page) ->
	console.log page # TODO: insert the page into the DOM

Reveal.initialize({
	center: true
})
