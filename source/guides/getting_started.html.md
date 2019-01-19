---
title: Getting Started
number: 0
---

# Getting Started

This guide will walk you through setting up your first search index with Lunr. It assumes you have some familiarity with JavaScript. After finishing this guide you will have a script that will be able to perform a search on a collection of documents.

## Installation

Install Lunr with npm:

```shell
$ npm install lunr
```

Lunr is also available as a single file for use in browsers using script tags. It can be included from the unpkg CDN like this:

```html
  <script src="https://unpkg.com/lunr/lunr.js"></script>
```

The following examples will use node.js for simplicity; the same code will work in any JavaScript environment.

## Creating an Index

We will create a simple index on a collection of documents and then perform searches on those documents.

First, we need a collection of documents. A document is a JavaScript object. It should have an identifier field that Lunr will use to tell us which documents in the collection matched a search, as well as any other fields that we want to search on.

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

We will use the above array of documents to build our index. We want to search the `text` field, and the `name` field will be our identifier. Let's define our index and add these documents to it.

```javascript
var idx = lunr(function () {
  this.ref('name')
  this.field('text')

  documents.forEach(function (doc) {
    this.add(doc)
  }, this)
})
```

Now that we have created our index we can try out a search:

```javascript
idx.search("bright")
```

## Conclusion

The above example shows how to quickly get full text search with Lunr. From here you can learn more about the [core concepts](/guides/core_concepts.html) involved in a Lunr index, explore the [advanced search capability](/guides/searching.html) provided by Lunr and see [how to customise Lunr](/guides/customising.html) to provide a great search experience.
