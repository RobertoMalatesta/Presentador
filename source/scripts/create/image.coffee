make =
  id: require "./id.coffee"

module.exports = (image) ->
  id = make.id image.name
  imageNode = document.getElementById "img-#{id}"
  imageNode.src = image.url
  return
