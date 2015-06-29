socket = io.connect()

correctMarkup = (sentence) ->
    sentence.indexOf("|") is -1 and sentence.indexOf("{{") is -1

useful = (sentence) ->
    sentence.length > 40 and correctMarkup sentence

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

        # don't add a slide if one exists with the same id
        if $("##{@id}").length isnt 0
            return

        $(".slides").append "<section id='#{@id}'>
            <section>
                <h1>#{@name}</h1>
                <h2>#{@subtitle or ""}</h1>
            </section>
        </section>"
        if not @subtitle
            for keySection, section of @json.text

                sectionHTML = "<section><h2>#{keySection}</h2><p>"
                for keySentence, sentence of section
                    if useful(sentence.text) and sectionHTML.length < maxLength
                        sectionHTML += sentence.text.replace(/ *\([^)]*\) */g, "") + " "
                sectionHTML += "</p></section>"
                $("##{@id}").append(sectionHTML)
        else
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

# if the URL is something like presentr.tk/Karl_Marx then start with Karl Marx
$(document).ready () ->
    startTopic = (/[^/]*$/.exec(window.location.href)[0]).replace(/_/g, " ")
    if startTopic isnt ""
        socket.emit "get page", startTopic
        $("#input-area").hide()

Reveal.initialize({
	center: true
})
