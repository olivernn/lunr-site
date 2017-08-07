---
title: Language Support
number: 6
---
# Language Support

Lunr has full support for the indexing and searching of documents in English. If your documents are in another language, you need to install the [Lunr Languages](https://github.com/MihaiValentin/lunr-languages) plugin to get the best search results. Currently the following languages are supported:

* <span class="flag flag-de">German</span>
* <span class="flag flag-dk">Danish</span>
* <span class="flag flag-es">Spanish</span>
* <span class="flag flag-fi">Finnish</span>
* <span class="flag flag-fr">French</span>
* <span class="flag flag-hu">Hungarian</span>
* <span class="flag flag-it">Italian</span>
* <span class="flag flag-jp">Japanese</span>
* <span class="flag flag-nl">Dutch</span>
* <span class="flag flag-no">Norwegian</span>
* <span class="flag flag-pt">Portuguese</span>
* <span class="flag flag-ro">Romanian</span>
* <span class="flag flag-ru">Russian</span>
* <span class="flag flag-th">Thai</span>

## Installing

First, install the `lunr-languages` package:

```shell
$ npm install lunr-languages
```

Next, load the `lunr.stemmer.support` plugin and the appropriate language extension, which is identified by the [ISO 639-1](https://en.wikipedia.org/wiki/List_of_ISO_639-1_codes) language code.

The following example sets up the French language plugin and uses it when defining an index:

```javascript
var lunr = require("lunr")
require("lunr-languages/lunr.stemmer.support")(lunr)
require("lunr-languages/lunr.fr")(lunr)

var idx = lunr(function () {
  this.use(lunr.de)
  this.ref('id')
  this.field('text')

  this.add({
    id: 1,
    text: "Ceci n'est pas une pipe"
  })
})

idx.search('pipe')
```

## Multi-Language Content

If you have documents in more than one language, it is still possible to index them together by combining two or more language extensions using the `lunr.multiLanguage` plugin, part of `lunr-languages` package.

The following example sets up an index with support for both English and German:

```javascript
var lunr = require("lunr")
require("lunr-languages/lunr.stemmer.support")(lunr)
require('lunr-languages/lunr.multi')(lunr)
require("lunr-languages/lunr.de")(lunr)

var idx = lunr(function () {
  this.use(lunr.multiLanguage('en', 'de'))
})
```
