# this file manages the DOM objects
# that way, the are cached at the start of the programme
# by caching once, the programme runs much faster
module.exports =
  div:
    slides: $ ".slides"
    input: $ "#input-area"
  section:
    title: $ "#title-section"
  form:
    title: $ "#title"
    language: $ "#language"
  button:
    generate: $ "#generate"
    fullscreen: $ "#fullscreen"
    hide: $ "#hide"
    clear: $ "#clear"
    show: $ "#show"

    dpad:
      up: $ ".navigate-up"
      down: $ ".navigate-down"
      left: $ ".navigate-left"
      right: $ ".navigate-right"
