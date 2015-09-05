###
This function takes the Easypedia JSON and makes the section's HTML.
However, it doesn't interact with the DOM, so another file has to add it.

quick definitions:
  sentence: a single sentence
  slide: sentences grouped on a single screen
  subsection: a subsection from Wikipedia that Easypedia returned
  section: all the slides- goes linearly vertically
###

make =
  id: require "./create/id.coffee"
  name: require "./create/name.coffee"
  pseudosection: require "./create/pseudosection.coffee"
  section: require "./create/section.coffee"

module.exports = (page) ->
  # set up the variables that will be used
  id = make.id page.name
  name = make.name page.name

  # if the section is already added, don't readd it
  if document.getElementById(id)?
    return

  # hash separates the title and subtitle
  # if there is a hash, it means that only part should be added
  if "#" in page.name # only add a subsection
    make.pseudosection page
  else # add every section from the JSON
    make.section page
