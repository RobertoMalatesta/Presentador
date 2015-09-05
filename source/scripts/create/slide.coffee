# this file makes a single slide in HTML
# if the section is not usable, it returns `undefined`

range = require "./range.coffee"
purify = require '../purify.coffee'

module.exports = (section) ->
  # we only care about the text, not the links
  sentences = section.content.map (sentence) -> sentence.text

  slideText = ""
  for sentence in sentences
    if sentence.length + slideText.length <= range.slide.max
      slideText += purify.sentence(sentence) + " "
    else
      break # it cannot handle any more sentences, so stop

  if slideText.length >= range.slide.min
    "<section><h2>#{section.title}</h2><p>#{slideText}</p></section>"
