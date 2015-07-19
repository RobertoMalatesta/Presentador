module.exports = (name) ->
    if "#" in name # if only a section is wanted
        # only get things after the hash
        startingPoint = name.indexOf("#") + 1
        name.substring(startingPoint).replace(/_/g, " ")
    else # if the whole thing is wanted
        name.replace(/_/g, " ")
