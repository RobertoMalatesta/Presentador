module.exports = (name) ->
    name
        .replace(/[\.,-\/#!$%\^&\*;:{}=\-_`~()]/g, "")
        .replace(/\s{2,}/g,"")
        .replace(/ /g, "")
        .replace(/'/g, "")
        .toLowerCase()
