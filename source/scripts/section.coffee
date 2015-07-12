###
This file manages the process of making and adding a section.
Here is the syntax for adding a section via the JSON passed by Easypedia:
    makeSection = require "./section.coffee"
    section = makeSection json
    $(".slides").append section

quick definitions:
    sentence: a single sentence
    slide: a group of sentences that are grouped as to put them on a single screen
    subsection: a subsection from Wikipedia that Easypedia returned
    section: all the slides- goes linearly vertically
###

slideLengthRange =
    max: 500
    min: 100
sentenceLengthRange =
    # no max length
    min: 40

purifyText = (text) ->
    text.replace("}}", "").replace("{{", "")
extractText = (sentence) -> purifyText sentence.text
usable = (text) ->
    text.length > sentenceLengthRange.min and text.indexOf("|") is -1
make =
    id: (name) ->
        name
            .replace(/[\.,-\/#!$%\^&\*;:{}=\-_`~()]/g, "")
            .replace(/\s{2,}/g,"")
            .replace(/ /g, "")
            .replace(/'/g, "")
            .toLowerCase()

    name: (name) ->
        if "#" in name # if only a section is wanted
            # only get things after the hash
            startingPoint = name.indexOf("#") + 1
            name.substring(startingPoint).replace(/_/g, " ")
        else # if the whole thing is wanted
            name.replace(/_/g, " ")

    slide: (heading, sentences) ->
        slideText = ""

        enoughSpace = (sentence) ->
            sentence.length + slideText.length <= slideLengthRange.max

        for sentence in sentences
            if not usable sentence
                console.log sentence

            if enoughSpace(sentence) and usable sentence
                slideText += sentence
            else if not enoughSpace sentence
                break

        "<section>
            <h2>#{heading}</h2>
            <p>#{slideText}</p>
        </section>"

    entire: (title, sections) ->
        sectionsHTML = # open the section and add the title
            "<section id='#{make.id title}'>
                <section>
                    <h1>#{title}</h1>
                </section>"
        for heading, sentences of sections
            sectionsHTML += make.slide(heading, sentences.map extractText)
        sectionsHTML += "</section>" # close the section

        sectionsHTML

    pseudoSlides: (sentences) ->
        currentSlide = ""
        slides = []

        shouldStartAnew = (sentence) -> sentence.length + currentSlide.length > slideLengthRange.max

        for sentence in sentences
            if shouldStartAnew sentence
                slides.push currentSlide
                currentSlide = sentence
            else
                currentSlide += sentence

        slides

    subsection: (title, section) ->
        sentences = section.map extractText

        sectionHTML = "<section id='#{make.id title}'><section><h1>#{title}</h1></section>"
        for slide in make.pseudoSlides sentences
            sectionHTML += "<section><p>#{slide}</p></section>"
        sectionHTML += "</section>"

        sectionHTML

use = (json) ->
    # set up the variables that will be used
    id = make.id json.name
    name = make.name json.name

    if document.getElementById(id)?
        return

    if not ("#" in json.name)
        make.entire name, json.text
    else
        make.subsection name, json.text[name]

module.exports = use
