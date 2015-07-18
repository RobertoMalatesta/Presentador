###
This file manages the process of making and adding a section.
Here is the syntax for adding a section via the JSON passed by Easypedia:
    makeSection = require "./section.coffee"
    section = makeSection json
    $(".slides").append section

quick definitions:
    sentence: a single sentence
    slide: sentences grouped on a single screen
    subsection: a subsection from Wikipedia that Easypedia returned
    section: all the slides- goes linearly vertically
###

purify = require './purify.coffee'

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

    summary: (intro) ->
        descriptors = ["is", "are", "was", "were", "will be", "been"]

        isUsable = (sentence) ->
            sentence.indexOf("{{") is -1 and
            sentence.indexOf("}}") is -1

        sentences = intro.map((x) -> x.text).filter isUsable

        isDescription = (sentence) ->
            for descriptor in descriptors
                if sentence.indexOf(" #{descriptor} ") isnt -1
                    return true
            return false

        findDescription = (sentences) ->
            for sentence in sentences
                if isDescription sentence
                    return sentence

        description = (sentence) ->
            regex = /\s(is|are|was|were).*\./

            return sentence.match(regex)[0]

        capitalize = (text) ->
            noLeadingSpaces = text.replace /\s*/, ""
            noLeadingSpaces.charAt(0).toUpperCase() + noLeadingSpaces.slice 1

        for sentence in sentences
            if isDescription sentence
                return capitalize description sentence
        return ""

    slide: (heading, sentences) ->
        slideText = ""

        enoughSpace = (sentence) ->
            sentence.length + slideText.length <= slideLengthRange.max

        for sentence in sentences
            if enoughSpace(sentence) and usable sentence
                slideText += purify.text(sentence) + " "
            else if not enoughSpace sentence
                break

        "<section>
            <h2>#{heading}</h2>
            <p>#{slideText}</p>
        </section>"

    entire: (title, sections) ->
        summary = make.summary sections.Intro or ""

        sectionsHTML = # open the section and add the title
            "<section id='#{make.id title}'>
                <section>
                    <h1>#{title}</h1>
                    <p>#{summary}</p>
                </section>"
        for heading, sentences of sections
            sectionsHTML += make.slide(heading, sentences.map extractText)
        sectionsHTML += "</section>" # close the section

        sectionsHTML

    pseudoSlides: (sentences) ->
        currentSlide = ""
        slides = []

        shouldStartAnew = (sentence) ->
            sentence.length + currentSlide.length > slideLengthRange.max

        for sentence in sentences
            if shouldStartAnew sentence
                slides.push currentSlide
                currentSlide = sentence
            else
                currentSlide += sentence

        slides

    subsection: (title, section) ->
        sentences = section.map extractText

        sectionHTML =
            "<section id='#{make.id title}'>
                <section>
                    <h1>#{title}</h1>
                </section>"
            # keep the top section open so we can add slides into it
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
