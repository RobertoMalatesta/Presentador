mongoose = require 'mongoose'

pageSchema = new mongoose.Schema
    name: String
    language: String
    links: [String]
    text: Object

Page = mongoose.model "Page", pageSchema
module.exports = Page
