###
This file makes the name that will be put into the h1 tag
To use it, pass in the section's name.

If it detects that the section refers to a subsection of the article,
it will use the subsection's name
###

capitalize = (word) -> word.slice(0, 1).toUpperCase() + word.slice(1)

isSubtitle = (name) ->
  "#" in name

from =
  subtitle: (name) ->
    # the hash separates the title and subtitle
    # to get the subtitle, find everything after the hash
    # after we get the subtitle, we can treat it as a normal title

    startingPoint = name.indexOf("#") + 1
    from.title name.substring startingPoint

  title: (name) ->
    name
      .replace(/_/g, " ")
      .replace(/-/g, " ")

module.exports = (name) ->
  if isSubtitle name
    capitalize from.subtitle name
  else
    capitalize from.title name
