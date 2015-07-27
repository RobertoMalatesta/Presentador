fs = require 'fs'

mkdir = (name) ->
    if not fs.existsSync name
        fs.mkdir name

database =
    init: ->
        mkdir "database"
        mkdir "database/articles"
        mkdir "database/images"

    language: (language) ->
        language = language.toLowerCase()
        mkdir "database/images/#{language}"
        mkdir "database/images/#{language}"

module.exports =
    article:
        has: (name, language) ->
            name = name.toLowerCase()
            try
                require("./database/articles/#{language}/#{name}.json")
                return true
            catch
                return false

        read: (name, language) ->
            name = name.toLowerCase()
            require "./database/articles/#{language}/#{name}.json"

        save: (article, language) ->
            name = article.name.toLowerCase()
            dir = "database/articles/#{language}/#{name}.json"
            text = JSON.stringify(article)

            fs.writeFile dir, text

    images:
        has: (name, language) ->
            name = name.toLowerCase()
            try
                require "./database/images/#{language}/#{name}.json"
                return true
            catch error
                return false

        read: (name, language) ->
            name = name.toLowerCase()
            require "./database/images/#{language}/#{name}.json"

        save: (name, links, language) ->
            dir = "database/images/#{language}/#{name}.json"
            name = name.toLowerCase()

            database.language language
            fs.writeFile dir, JSON.stringify links
