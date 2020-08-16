---
title: Pre-building Indexes
number: 4
---

# Pre-building Indexes

For large numbers of documents, it can take time for Lunr to build an index. The time taken to build the index can lead a browser to block; making your site seem unresponsive.

A better way is to pre-build the index, and serve a serialised index that Lunr can load on the client side much quicker.

This technique is useful with large indexes, or with documents that are largely static, such as with a static website.

## Serialization

Lunr indexes support serialisation in JSON. Assuming that the index has already been created, it can be serialised using the built-in `JSON` object:

```javascript
var serializedIdx = JSON.stringify(idx)
```

This serialized index can then be written to a file, compressed, and served along side other static assets.

The below example is a script that can be used to build a serialised index. It assumes that the documents will be available in JSON format on STDIN, and have fields `title` and `body` and a ref of `id`.

```javascript
var lunr = require('lunr'),
    stdin = process.stdin,
    stdout = process.stdout,
    buffer = []

stdin.resume()
stdin.setEncoding('utf8')

stdin.on('data', function (data) {
  buffer.push(data)
})

stdin.on('end', function () {
  var documents = JSON.parse(buffer.join(''))

  var idx = lunr(function () {
    this.ref('id')
    this.field('title')
    this.field('body')

    documents.forEach(function (doc) {
      this.add(doc)
    }, this)
  })

  stdout.write(JSON.stringify(idx))
})
```

Assuming that the above script is in a file called `build-index.js` in the current directory, it can be used to create a serialised index with JSON from STDIN:

```bash
$ echo '[{ "id": "1", "title": "Foo", "body": "Bar" }]' | node build-index.js > index.json
```

## Loading

Loading a serialised index is significantly quicker than building the index from scratch. Assuming a variable named `data` contains the serialised index, loading the index is done like this:

```javascript
var idx = lunr.Index.load(JSON.parse(data))
```
