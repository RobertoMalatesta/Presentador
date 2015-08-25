make =
    id: require "./id.coffee"

module.exports = (image) ->
    id = make.id image.name
    section = document.getElementById "img-#{id}"
    section.src = image.url
