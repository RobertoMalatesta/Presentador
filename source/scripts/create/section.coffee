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
    for heading, content of sections
        sectionsHTML += make.slide(heading, content) or ""
    sectionsHTML += "</section>"

    sectionsHTML
