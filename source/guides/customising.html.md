---
title: Customisation
index: 5
---

# Customisation

Lunr ships with sensible defaults that will produce good results for most use cases. Lunr also provides the ability to customise the index to provide extra features, or more control over how documents are indexed and scored.

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

## Pipeline Functions

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

## Token Meta-data

Pipeline functions in Lunr are able to attach meta-data to a token, an example of this is the tokens position data, i.e. where the token is in the document being indexed. By default no meta-data is stored in the index, this is to reduce the size of the index. It is possible to white list certain token meta-data though. White listed meta-data will be returned with search results, it can also be used by other pipeline functions.

A `lunr.Token` has support for adding meta-data, for example, the following plugin will attach the length of a token as meta-data with key `tokenLength`. For it to be available in search results this meta-data key is also added to the meta-data white list:

```javascript
var tokenLengthMetadata = function (builder) {
  // Define a pipeline function that stores the token length as metadata
  var pipelineFunction = function (token) {
    token.metadata['tokenLength'] = token.toString().length
    return token
  }

  // Register the pipeline function so the index can be serialised
  lunr.Pipeline.registerFunction(pipelineFunction, 'tokenLenghtMetadata')

  // Add the pipeline function to the indexing pipeline
  builder.pipeline.before(lunr.stemmer, pipelineFunction)

  // Whitelist the tokenLength metadata key
  builder.metadataWhitelist.push('tokenLength')
}
```

As with all plugins, using it an index is simple:

```javascript
var idx = lunr(function () {
  this.use(tokenLengthMetadata)
})
```

## Similarity Tuning

The algorithm used by Lunr to calculate similarity between a query and a document can be tuned using two parameters. Lunr ships with sensible defaults here, but to these can be adjusted to provide the best results for a given collection of documents.


<dl>
  <div>
    <dt><code>b</code></dt>
    <dd>
      This parameter controls the importance given to the length of a document and its fields. This value must be between 0 and 1, and by default it has a value of 0.75. Reducing this value reduces the affect that different length documents have on a terms importance to that document.
    </dd>
  </div>

  <div>
    <dt><code>k1</code></dt>
    <dd>
      This controls how quickly the boost given by a common word reaches saturation. Increasing this will slow down the rate of saturation, lower values result in quicker saturation. The default value is 1.2. If the collection of documents being indexed have some high occurances of words that are not covered by a stop word filter, these words can quickly dominate any similarity calculation. In these cases it can make sense to reduce this value to get more balanced results.
    </dd>
  </div>
</dl>

Both of these parameters can be adjusted when building the index:

```javascript
var idx = lunr(function () {
  this.k1(1.3)
  this.b(0)
})
```
