range = require "./range.coffee"
purify = require '../purify.coffee'

module.exports = (heading, content) ->
    sentences = content.map (sentence) -> sentence.text

    enoughSpace = (sentence) ->
        sentence.length + slideText.length <= range.slide.max

    goodLength = (sentence) ->
        range.sentence.min <= sentence.length

    slideText = ""
    for sentence in sentences
        if enoughSpace(sentence) and goodLength(sentence)
            slideText += purify.sentence(sentence) + " "
        else if not enoughSpace sentence
            break

    if slideText.length >= range.slide.min
        "<section>
            <h2>#{heading}</h2>
            <p>#{slideText}</p>
        </section>"
