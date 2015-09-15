make =
  id: require "./id.coffee"

module.exports = (image) ->
  id = make.id image.name
  console.log id
  imageNode = document.getElementById "img-#{id}"
  imageNode.src = image.url
  return
