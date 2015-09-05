# this file makes a single slide in HTML
# if the section is not usable, it returns `undefined`

range = require "./range.coffee"
purify = require '../purify.coffee'

module.exports = (section) ->
  # we only care about the text, not the links
  sentences = section.content.map (sentence) -> sentence.text

  # XXX: relies on the state of slideText so is not fully-functional
  enoughSpace = (sentence) ->
    sentence.length + slideText.length <= range.slide.max

  goodLength = (sentence) ->
    range.sentence.min <= sentence.length

  slideText = ""
  for sentence in sentences
    if enoughSpace(sentence) and goodLength(sentence)
      slideText += purify.sentence(sentence) + " "
    else if not enoughSpace sentence
      break # it cannot handle any more sentences, so stop

  if slideText.length >= range.slide.min
    "<section><h2>#{section.title}</h2><p>#{slideText}</p></section>"
