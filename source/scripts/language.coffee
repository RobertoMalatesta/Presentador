# this file determines what language to use

dom = require './dom.coffee'

usable = (language) ->
    language.length is 2 or language.toLowerCase() is "simple"

module.exports = ->
    rawLanguage = dom.form.language.val()
    if usable rawLanguage
        rawLanguage
    else
        switch rawLanguage.toLowerCase()
            when "francais", "français", "french"
                "fr"
            when "espanol", "español", "spanish"
                "es"
