range = require "./range.coffee"

module.exports = (heading, content) ->
    sentences = content.map (sentence) -> sentence.text

    slideText = ""

    enoughSpace = (sentence) ->
        sentence.length + slideText.length <= range.slide.max

    goodLength = (sentence) ->
        range.sentence.min <= sentence.length <= range.sentence.max

    for sentence in sentences
        if enoughSpace(sentence) and goodLength(sentence)
            slideText += sentence + " "
        else if not enoughSpace sentence
            break

    if slideText >= range.slide.min
        "<section>
            <h2>#{heading}</h2>
            <p>#{slideText}</p>
        </section>"
