fs = require 'fs'
express = require 'express'
router = express.Router()

random = (upperbound) -> Math.floor Math.random() * upperbound

nLoadingImages = fs.readdirSync("public/images/loading")

router.get '/', (request, response) ->
    response.render 'index.jade'

router.get '/:topic', (request, response) ->
    response.render 'index.jade'

module.exports = router
