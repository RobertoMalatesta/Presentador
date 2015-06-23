socket = io.connect "http://localhost:8080"

class section
    constructor: (@json) ->
        @id = @json.name.replace(/ /g , "").toLowerCase()
        console.log @json

    use: () ->
        $(".slides").append "<section id='#{@id}'>
            <section>
                <h1>#{@json.name}</h1>
            </section>
        </section>"
        for keySection, section of @json.text
            maxLength = 400 # how many characters a slide can have

            sectionHTML = "<section><h2>#{keySection}</h2><p>"
            for keySentence, sentence of section
                if sectionHTML.length < maxLength
                    sectionHTML += sentence.text + " "
            sectionHTML += "</p></section>"
            $("##{@id}").append(sectionHTML)

socket.on 'new page', (page) ->
	new section(page).use()

$("#generate").click () ->
    title = $("#title").val()
    if title.replace(/ /, "") isnt ""
        socket.emit "get page", title
        $("#input-area").remove()

Reveal.initialize({
	center: true
})
