###
This file determines what language to use

It checks to see if something is entered into the DOM form
If it's blank, it uses English.
If something is entered into the form, it will try to understand the input

For example, all of the following set the language to French:
    fr
    francais
    français
    french
And it's not case sensitive either
###

anglicize = require 'anglicize'
languages = require 'langs'
dom = require './dom.coffee'

capitalize = (word) ->
    word.charAt(0).toUpperCase() + word.slice(1).toLowerCase()

codeFrom = # get the language code like 'en' or 'fr'
    code: (code) -> # makes sure that the code is valid
        if languages.has("1", code.toLowerCase())
            code.toLowerCase()

    # from something like 'français'
    local: (local) ->
        if languages.has "local", local
            languages.where("local", local)["1"]

    # this is for when you anglicize a word
    # français -> francais
    # español -> espanol
    anglo: (anglo) ->
        # to get the language code, convert the anglo back to local
        # then just get the language code from the local langauge

        anglo = capitalize anglo # to avoid case-sensitivity

        anglicized = languages.all().map (entry) ->
            anglo: capitalize anglicize entry.local # to avoid case-sensitivity
            local: entry.local # so we don't have to search again

        for language in anglicized
            if language.anglo is anglo # if a match is found
                return codeFrom.local language.local

    # from something like 'Spanish' or 'French' or 'Arabic'
    english: (english) ->
        if languages.has "name", capitalize english
            languages.where("name", capitalize english)["1"]

# find the code of any input
# this will try to use every possible method to find the code
codeOf = (source) ->
    for sourceType, method of codeFrom
        if method(source)?
            return method(source)

module.exports = ->
    codeOf(dom.form.language.val()) or "en"
