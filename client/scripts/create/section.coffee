make =
    summary: require "./summary.coffee"
    slide: require "./slide.coffee"
    id: require "./id.coffee"

module.exports = (title, sections) ->
    summary = make.summary sections.Intro
    id = make.id title

    sectionsHTML =
        "<section id='#{id}' class='stack future'>
            <section>
                <h1>#{title}</h1>
                <p>#{summary}</p>
            </section>"
    for heading, content of sections
        sectionsHTML += make.slide(heading, content) or ""
    sectionsHTML += "</section>"

    sectionsHTML
