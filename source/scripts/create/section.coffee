###
This file makes the HTML that can be inserted to create a section
It doesn't actually make each slide itself- that's done in `slide.coffee`
###

make =
    slide: require "./slide.coffee"
    id: require "./id.coffee"

module.exports = (title, sections) ->
    id = make.id title

    sectionsHTML =
        "<section id='#{id}' class='stack future'>
            <section>
                <h1>#{title}</h1>
            </section>"
            # keep the top section open so we can add slides into it

    # insert the slides
    for heading, content of sections
        sectionsHTML += make.slide(heading, content) or ""

    # close the top section
    sectionsHTML += "</section>"

    return sectionsHTML
