---
title: Extending Lunr
index: 5
---

# Extending Lunr

Lunr has some sensible defaults that should allow it to produce good results for most use cases. It is 

## Plugins

Any customisation, or extensions, can be packaged as a plugin. This makes it easier to share your customisations between indexes and other people, and provides a single, supported, way of customising Lunr.

A plugin is just a function that Lunr executes in the context of an index builder. For example, a plugin that adds some default fields to the index would look like this:

```javascript
var articleIndex = function () {
  this.field('text')
}
```

This plugin can then be used when defining an index:

```javascript
var idx = lunr(function () {
  this.use(articleIndex)
})
```

Plugin functions have their context set to the index builder, and the builder is also passed as the first argument to the plugin. Additional parameters can also be passed to the plugin when using it in an index. For example, taking the above plugin and passing it fields to add could look like this:

```javascript
var parameterisedPlugin = function (builder, fields) {
  fields.forEach(function (field) {
    builder.field(field)
  })
}
```

```javascript
var idx = lunr(function () {
  this.use(parameterisedPlugin, ['title', 'body'])
})
```

## Pipeline Customisation

The most common part of Lunr to customise is the text processing pipeline. For example, if you wanted to support searching on either British or American spelling you could add a pipeline function to normalise certain words. Lets say we want to normalise the term "grey" so users can search by either British spelling "grey" or American spelling "gray". To do this we can add a pipeline function to do the normalisation:

```javascript
var normaliseSpelling = function (builder) {

  // Define a pipeline function that converts 'gray' to 'grey'
  var pipelineFunction = function (token) {
    if (token.toString() == "gray") {
      return token.update(function () { return "grey" })
    } else {
      return token
    }
  }

  // Register the pipeline function so the index can be serialised
  lunr.Pipeline.registerFunction(pipelineFunction, 'normaliseSpelling')

  // Add the pipeline function to both the indexing pipeline and the
  // searching pipeline
  builder.pipeline.before(lunr.stemmer, pipelineFunction)
  builder.searchPipeline.before(lunr.stemmer, pipelineFunction)
}
```

As before, this plugin can then be used in an index:

```javascript
var idx = lunr(function () {
  this.use(normaliseSpelling)
})
```

## Token Metadata

TODO

## Result Ranking

TODO
