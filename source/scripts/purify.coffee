# this object removes unwanted text

module.exports = (sentence) ->
  sentence
    .trim()
    .replace /\s\(.*?\)/g, "" # remove everything inside (...)
    .replace /\s\[.*?\]/g, "" # remove everything inside [...]
    .replace /\s\{.*?\}/g, "" # remove everything inside {...}
