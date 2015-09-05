mongoose = require 'mongoose'

imageSchema = new mongoose.Schema
  name: String
  language: String
  url: String

Page = mongoose.model "Image", imageSchema
module.exports = Page
