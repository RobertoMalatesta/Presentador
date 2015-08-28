###
This file makes the HTML that can be inserted to create a section
It doesn't actually make each slide itself- that's done in `slide.coffee`
###

make =
    slide: require "./slide.coffee"
    id: require "./id.coffee"

module.exports = (title, sectionsMap) ->
    # we need to go thru the sections in order, but a Map has no implicit order
    # thus, we need to turn it into an array of objects
    sections = []
    for heading, content of sectionsMap
        sections.push
            heading: heading
            content: content
    if sections[0].heading isnt "Intro"
        sections = sections.reverse()

    id = make.id title

    sectionsHTML =
        "<section id='#{id}' class='stack future'>
            <section>
                <h1>#{title}</h1>
            </section>
            <section>
                <img id='img-#{id}' />
            </section>"
            # keep the top section open so we can add slides into it

    # insert the slides
    for section in sections
        sectionsHTML += make.slide(section.heading, section.content) or ""

    # close the top section
    sectionsHTML += "</section>"

    return sectionsHTML
