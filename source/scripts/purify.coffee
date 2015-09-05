# this object removes unwanted text

module.exports =
  sentence: (sentence) ->
    sentence
      .replace /\s*/, "" # strip starting whitespace
      .replace /\s\(.*?\)/g, "" # remove everything inside (...)
