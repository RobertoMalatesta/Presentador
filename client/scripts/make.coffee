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

make =
    id: require "./create/id.coffee"
    name: require "./create/name.coffee"
    pseudosection: require "./create/pseudosection.coffee"
    section: require "./create/section.coffee"

module.exports = (json) ->
    # set up the variables that will be used
    id = make.id json.name
    name = make.name json.name

    if document.getElementById(id)?
        return

    if not ("#" in json.name)
        make.section name, json.text
    else
        make.pseudosection name, json.text[name]
