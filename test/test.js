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

describe("slide", function() {
  it("converts a section from Easypedia to a slide", function() {
    var mock = {
      title: "Intro",
      content: [
        {text: "France, officially the French Republic is a sovereign state comprising territory in western Europe and several overseas regions and territories."},
        {text: "It is a unitary semi-presidential republic."},
        {text: "The capital of France is Paris, the country\'s largest city and the main cultural and commercial center."},
        {text: "The Constitution of France establishes the state as secular and democratic, with its sovereignty derived from the people."},
        {text: "During the Iron Age, what is now Metropolitan France was inhabited by the Gauls, a Celtic people."},
        {text: "The Gauls were conquered by the Roman Empire in 51 BC, which held Gaul until 486."}
      ]
    };

    var paragraph = mock.content[0].text + " " + mock.content[1].text + " " + mock.content[2].text + " " + mock.content[3].text;
    expect(slide(mock)).to.equal("<section><h2>" + mock.title + "</h2><p>" + paragraph + " </p></section>");
  });

  it("ignores very small sections", function() {
    var mock = {
      title: "Intro",
      content: [
        {text: "France, officially the French Republic is a sovereign state comprising territory in western Europe and several overseas regions and territories."},
      ]
    };

    expect(slide(mock)).to.equal(undefined);
  });
});
