# this object removes unwanted text

module.exports =
  sentence: (sentence) ->
    sentence
      .trim()
      .replace /\s\(.*?\)/g, "" # remove everything inside (...)
