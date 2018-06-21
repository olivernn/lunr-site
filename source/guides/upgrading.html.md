---
title: Upgrading
number: 3
---
# Upgrading

The 2.x versions of Lunr have a similar interface to previous versions and therefore upgrading shouldn't require large changes in how searches are performed. There are differences in how indexes are built and serialised, and the interface required of pipeline functions. This guide will cover the major differences and show how to upgrade.

## Index Building

The largest difference between 0.x/1.x and 2.x is that Lunr indexes are now **immutable**. Once they have been built, it is _not_ possible to add, update or remove any documents in the index. All documents must have been added before the definition function exits.

Previously adding documents to an index would look like this:

```javascript
var idx = lunr(function () {
  this.ref('id')
  this.field('text')
})

idx.add({ id: 1, text: 'hello' })
```

In 2.x the documents are added before the end of the configuration function:

```javascript
var idx = lunr(function () {
  this.ref('id')
  this.field('text')

  this.add({ id: 1, text: 'hello' })
})
```

## Searching

The search interface is backwards compatible with previous versions of Lunr. A search that worked in Lunr 0.x/1.x will continue to work in 2.x.

The _behaviour_ of the search has changed slightly, multi-term searches are now combined with OR, where they used to be combined with AND.

Practically this change means that a given search will return more documents in 2.x than it did previously, with the most relevant results returned first.

## Pipeline Functions

Previously, the interface required of pipeline functions was _very_ simple; tokens were just strings. In Lunr 2.x, tokens are now represented by a `lunr.Token`.

As an example, imagine a pipeline function that converts tokens to lower case (this isn't required but makes a simple example). In previous versions of Lunr this could be implemented like this:

```javascript
var downcaser = function (token) {
  return token.toLowerCase()
}
```

With Lunr 2.x this is only slightly more involved:

```javascript
var downcaser = function (token) {
  return token.update(function (str) {
    return str.toLowerCase()
  })
}
```

For more details on the new `lunr.Token` object see the API documentation.
