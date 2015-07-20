range = require './range.coffee'
make =
    id: require './id.coffee'

pseudoslides = (sentences) ->
    currentSlide = ""
    slides = []

    shouldStartAnew = (sentence) ->
        sentence.length + currentSlide.length > range.slide.max

    for sentence in sentences
        if shouldStartAnew sentence
            slides.push currentSlide
            currentSlide = sentence
        else
            currentSlide += sentence + " "

    slides

module.exports = (title, section) ->
    sentences = section.map (sentence) -> sentence.text
    id = make.id title

    sectionHTML =
        "<section id='#{id}'>
            <section>
                <h1>#{title}</h1>
            </section>"
        # keep the top section open so we can add slides into it
    for slide in pseudoslides sentences
        sectionHTML += "<section><p>#{slide}</p></section>"
    sectionHTML += "</section>"

    sectionHTML
