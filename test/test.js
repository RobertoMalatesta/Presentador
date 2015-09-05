var expect = require('chai').expect;
var id = require('../source/scripts/create/id.coffee');
var name = require('../source/scripts/create/name.coffee');
var purify = require('../source/scripts/purify.coffee');
var slide = require('../source/scripts/create/slide.coffee');
var section = require('../source/scripts/create/section.coffee');
var range = require('../source/scripts/create/range.coffee');

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

describe("purify", function() {
  it("trims whitespace", function() {
    expect(purify(" the dog ")).to.equal("the dog");
  });

  it("removes content inside ()", function() {
    expect(purify("hello (useless) how are you")).to.equal("hello how are you");
  });

  it("removes content inside []", function() {
    expect(purify("hello [useless] how are you")).to.equal("hello how are you");
  });

  it("removes content inside {}", function() {
    expect(purify("hello {useless} how are you")).to.equal("hello how are you");
  });
});

describe("slide", function() {
  it("converts a section from Easypedia to a slide", function() {
    var mock = require("./examples/France.json").sections[0];

    var expected = "<section><h2>Intro</h2><p>France, officially the French Republic a sovereign state comprising territory in western Europe and several overseas regions and territories. The European part of France, called Metropolitan France, extends from the Mediterranean Sea to the English Channel and the North Sea, and from the Rhine to the Atlantic Ocean; France covers 640679 km2 and has a population of 66.6 million. It is a unitary semi-presidential republic. </p></section>";
    expect(slide(mock)).to.equal(expected);
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
