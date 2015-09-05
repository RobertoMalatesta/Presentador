var expect = require('chai').expect;
var id = require('../source/scripts/create/id.coffee');
var name = require('../source/scripts/create/name.coffee');
var slide = require('../source/scripts/create/slide.coffee');

describe("id", function() {
  it("converts the name of a Wikipedia to an HTML-valid ID", function() {
    var mocks = [
      {title: "Abhinav", id: "Abhinav"},
      {title: "Italy", id: "Italy"},
      {title: "Democratic Republic of the Congo", id: "Democratic-Republic-of-the-Congo"},
      {title: "Français", id: "Français"},
      {title: "Français Language", id: "Français-Language"}
    ];

    for (var i in mocks) {
      var mock = mocks[i];
      expect(id(mock.title)).to.equal(mock.id);
    }
  });
});

describe("name", function() {
  it("converts the name of a Wikipedia article to a prettier form", function() {
    var mocks = [
      {original: "Abhinav", final: "Abhinav"},
      {original: "Abhinav-Madahar", final: "Abhinav Madahar"},
      {original: "Langley Village", final: "Langley Village"}
    ];

    for (var i in mocks) {
      var mock = mocks[i];
      expect(name(mock.original)).to.equal(mock.final);
    }
  });

  it("converts the name of a subsection to a prettier form", function() {
    var mocks = [
      {original: "Abhinav#etymology", final: "Etymology"},
      {original: "Community#Characters", final: "Characters"},
      {original: "Community#Britta Perry", final: "Britta Perry"}
    ];

    for (var i in mocks) {
      var mock = mocks[i];
      expect(name(mock.original)).to.equal(mock.final);
    }
  });
});
