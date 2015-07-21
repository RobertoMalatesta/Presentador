# the slides and sentences need to be useful
# one measure of usefulness is length
# this file manages the length limits for all the files
# by keeping it in a single file, the other files all use the same rules

module.exports =
    slide:
        max: 500 # anything more cannot fit on most screens well
        min: 300 # anything less is too short to get the point across
    sentence:
        # no maximum because there's no need for one
        min: 40 # anything less than this is probably malformed text
