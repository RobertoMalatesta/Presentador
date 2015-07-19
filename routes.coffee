express = require 'express'
router = express.Router()

router.get '/', (request, response) ->
    response.render 'index.jade'

router.get '/:topic', (request, response) ->
    response.render 'index.jade'

module.exports = router
