express = require 'express'
http = require 'http'
logarithmic = require 'logarithmic'

app = express()
server = http.createServer app

app.get '/', (request, response) ->
	response.render "index.jade"

port = process.env.PORT ? 8080
hostname = process.env.HOSTNAME ? "0.0.0.0"
backlog = process.env.BACKLOG ? 512
server.listen port, hostname, backlog, () ->
	logarithmic.ok "Server running on port", port
