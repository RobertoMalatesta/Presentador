###
This file makes a section from a single Wikipedia subsection
It separates the content into different slides, but it can't title them

It takes the title and sections, then returns the HTML that can be inserted
###

range = require './range.coffee'
make =
  id: require './id.coffee'

# separates the sentences into roughly equally-sized groups
pseudoslides = (sentences) ->
  # sentences will be added to currentSlide until it is too long
  # then the currentSlide will be saved to slides and reset

  currentSlide = ""
  slides = []

  # XXX: relies on the state of `slides` and is not purely-functional
  shouldRestart = (sentence) ->
    sentence.length + currentSlide.length > range.slide.max

  # XXX: relies on the state of `slides` and is not purely-functional
  restart = ->
    slides.push currentSlide
    currentSlide = sentence

  for sentence in sentences
    if shouldRestart sentence
      restart()
    else
      currentSlide += sentence + " "

  slides

# this creates the HTML that will be inserted
module.exports = (title, section) ->
  # this just inserts the slides into an HTML-string
  # the actual generation of the slides is done by pseudoslides

  # we don't need the links right now, so extract the text
  sentences = section.map (sentence) -> sentence.text
  id = make.id title

  sectionHTML =
    "<section id='#{id}' class='stack future'>
      <section>
        <h1>#{title}</h1>
        <img id='img-#{id}' />
      </section>"
    # keep the top section open so we can add slides into it

  # insert the slides' content into the top section
  for slide in pseudoslides sentences
    sectionHTML += "<section><p>#{slide}</p></section>"

  sectionHTML += "</section>" # close the top section

  sectionHTML
