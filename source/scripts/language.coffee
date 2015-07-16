# this file determines what language code to use
# require('./language.coffee')() returns the code
# it defaults to "en" if no language code is found

anglicize = require 'anglicize'
languages = require 'langs'
dom = require './dom.coffee'

capitalize = (word) ->
    word.charAt(0).toUpperCase() + word.slice(1).toLowerCase()

codeFrom =
    code: (code) ->
        if languages.has("1", code)
            code

    local: (local) ->
        if languages.has "local", local
            languages.where("local", local)["1"]
    anglo: (anglo) ->
        anglo = capitalize anglo
        anglicized = languages.all().map (entry) ->
            anglo: capitalize anglicize entry.local
            local: entry.local
        for language in anglicized
            if language.anglo is anglo
                return codeFrom.local language.local
    english: (english) ->
        if languages.has "name", capitalize english
            languages.where("name", capitalize english)["1"]

codeOf = (source) ->
    for sourceType, method of codeFrom
        if method(source)?
            return method(source)

module.exports = () ->
    codeOf(dom.form.language.val()) or "en"
