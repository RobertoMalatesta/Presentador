###
This file makes the HTML that can be inserted to create a section
It doesn't actually make each slide itself- that's done in `slide.coffee`
###

make =
  slide: require "./slide.coffee"
  id: require "./id.coffee"

module.exports = (article) ->
  id = make.id article.name

  sectionsHTML =
    "<section id='#{id}' class='stack future'>
      <section>
        <h1>#{article.name}</h1>
      </section>
      <section>
        <img id='img-#{id}' />
      </section>"
      # keep the top section open so we can add slides into it

  # insert the slides
  for section in article.sections
    sectionsHTML += make.slide section

  # close the top section
  sectionsHTML += "</section>"

  return sectionsHTML
