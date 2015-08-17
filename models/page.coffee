mongoose = require 'mongoose'

pageSchema = new mongoose.Schema
    name: String
    language: String
    links: [String]
    text: Array

Page = mongoose.model "Page", pageSchema
module.exports = Page
