inside =
    braces:
        parentheses: /\s\(.*?\)/g

module.exports =
    text: (text) ->
        text
            .replace inside.braces.parentheses, ""
            .replace /(\[|\]|\{|\})/g, ""
