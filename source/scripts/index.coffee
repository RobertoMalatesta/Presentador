socket = io.connect()

class section
    constructor: (@json) ->
        @id = @json.name
            .replace(/[\.,-\/#!$%\^&\*;:{}=\-_`~()]/g, "")
            .replace(/\s{2,}/g,"")
            .replace(/ /g, "")
            .toLowerCase()

    use: () ->
        # don't add a slide if one exists with the same id
        if $("##{@id}").length isnt 0
            return
        
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
                    sectionHTML += sentence.text.replace(/ *\([^)]*\) */g, "") + " "
            sectionHTML += "</p></section>"
            $("##{@id}").append(sectionHTML)

socket.on 'new page', (page) ->
	new section(page).use()

slideSpeed = 350 # milliseconds

$("#generate").click () ->
    title = $("#title").val()
    if title.replace(/ /, "") isnt ""
        socket.emit "get page", title
        $("#input-area").slideUp slideSpeed

$(document).keydown (event) ->
    if event.keyCode is 220
        if $("#input-area").css("display") is "none"
            $("#input-area").slideDown slideSpeed
        else
            $("#input-area").slideUp slideSpeed

Reveal.initialize({
	center: true
})
