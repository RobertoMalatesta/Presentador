purify = require '../purify.coffee'

extractSentences = (section) ->
    section.map (sentence) -> sentence.text

descriptors = ["is", "are", "was", "were", "will be", "been"]

isDescription = (sentence) ->
    for descriptor in descriptors
        if sentence.indexOf(" #{descriptor} ") isnt -1
            return true
    return false

description = (sentence) ->
    regex = /\s(is|are|was|were)\s.*/

    return sentence.match(regex)[0]

capitalize = (text) ->
    noLeadingSpaces = text.replace /\s*/, ""
    noLeadingSpaces.charAt(0).toUpperCase() + noLeadingSpaces.slice 1

module.exports = (intro) ->
    for sentence in extractSentences intro
        if isDescription sentence
            return capitalize purify.sentence description sentence
    return ""
