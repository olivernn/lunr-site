---
title: Getting Started
---

# Getting Started

This guide will walk you through setting up your first Lunr index. It assumes you have some familiarity with JavaScript. After finishing this guide you will have a script that will perform a search on some documents.

## Installation

Install Lunr with npm:

```shell
$ npm install -g lunr
```

Lunr is also available as a single file for use in browsers using script tags, it can be included from the unpkg CDN like this:

```html
  <script src="https://unpkg.com/lunr/lunr.min.js"></script>
```

The following examples will use node for simplicity, but the same code will work in any JavaScript environment.

## Creating an Index

We will create a simple index of some documents and then perform some searches on those documents.

First, we need some documents. A document is a JavaScript object, it should have an id field that Lunr will use to tell us which documents matched a search, as well as some fields that we want to search on.

```javascript
var documents = [{
  "name": "Lunr",
  "text": "Like Solr, but much smaller, and not as bright."
}, {
  "name": "React",
  "text": "A JavaScript library for building user interfaces."
}, {
  "name": "Lodash",
  "text": "A modern JavaScript utility library delivering modularity, performance & extras."
}]
```

We will use the above array of documents to build our index. We want to search the `text` field, and the `name` field will be our id. Lets define our index and add these documents to it.

```javascript
var idx = lunr(function () {
  this.ref('name')
  this.field('text')

  documents.forEach(function (doc) {
    this.add(doc)
  }, this)
})
```

Now that we have our index created, we can try out some searches:

```javascript
idx.search("bright")
```

TODO: Embed the example with runkit.

TODO: Conculusion
