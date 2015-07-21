# this file manages the DOM objects
# that way, the are cached at the start of the programme
# by caching once, the programme runs much faster
module.exports =
    div:
        slides: $ ".slides"
        inputArea: $ "#input-area"
    section:
        title: $ "#title-section"
    form:
        title: $ "#title"
        language: $ "#language"
    button:
        generate: $ "#generate"
