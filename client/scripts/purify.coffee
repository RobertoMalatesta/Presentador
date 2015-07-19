module.exports =
    sentence: (sentence) ->
        sentence
            .replace /\s*/, "" # strip starting whitespace
