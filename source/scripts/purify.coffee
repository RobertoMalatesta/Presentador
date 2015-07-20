module.exports =
    sentence: (sentence) ->
        sentence
            .replace /\s*/, "" # strip starting whitespace
            .replace /\s\(.*?\)/g, "" # remove everything inside (...)
