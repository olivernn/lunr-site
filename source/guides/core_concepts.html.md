---
title: Core Concepts
index: 1
---

# Core Concepts

Creating a basic search index with Lunr is simple, understanding some of the concepts and terminology that Lunr uses will allow you to provide powerful search functionality.

## Documents

A document contains the text that you want to be able to search. A document is a JavaScript object with one or more fields as well as a reference that will be returned in the results from a search. A document representing a blog post might look like this:

```javascript
{
  "id": "http://my.blog/blah",
  "title": "Blah",
  "body": "Some more blah"
}
```

In this document there are two fields that could be searched on `title` and `body` as well as an `id` field that can be used as a reference. Typically fields are strings of text, but they can be anything that responds to `toString`. Array's can also be used, in which case the result of calling `toString` on each element will be available for search, this can be used for things such as tags.

The documents that are passed to Lunr for indexing do not have to be the exact same structure that the data is represented in your application or site, for example to provide a search on email addresses the email addresses could be split, for example:

```javascript
{
  "id": "Bob",
  "emailDomain": "example.com",
  "emailLocal": "bob.bobson"
}
```

## Text Processing

Before Lunr can start building an index it must first process the text in the document fields. The first step in this process is splitting a string into words, Lunr calls these tokens. A string such as "foo bar baz" will be split into three separate tokens; "foo", "bar" and "baz".

Once the text of a field has been split into tokens each token is passed through a text processing pipeline. A pipeline is a combination of one or more pipeline functions that either modify the token, or extract and store some kind of meta-data about the token. The default pipeline in Lunr provides functions for trimming any punctuation, ignoring stop words and reducing a word to its stem.

The pipeline Lunr uses can be modified, either removing, rearranging or adding custom processors to the pipeline. A custom pipeline function can either prevent a token from entering the index (like the stop word filter), or modify a token (as with stemming). A token can also be expanded, which might be useful for adding synonyms to an index. An example pipeline function that splits email addresses into a local and domain part is below:

### Stemming

Stemming is the process of reducing inflected or derived words to their base or stem form. For example, the stem of "searching", "searched" and "searchable" should be "search". This has two benefits, firstly the number of tokens in the search index (and therefore its size) is significantly reduced, in addition, it increases the amount of recall when performing a search. A document containing the word "searching" is likely to be relevant to a query for "search".

There are two ways in which stemming can be achieved, dictionary based or algorithm based. In dictionary based stemming a dictionary that maps _all_ words to their stems is used. This approach can give good results but requires a very complete dictionary, which must be maintained and is large in size. A more pragmatic approach is an algorithmic stemming, such as a [Porter Stemmer](https://tartarus.org/martin/PorterStemmer/), which is used in Lunr.

The stemmer used by Lunr does not guarantee that the stem of a word it finds is an actual word, but all inflections and derivitaves of that word _should_ produce the same stem.

## Search Results

The result of a search contains an array of result objects representing each document that was matched by a search. Each result has three properties:

<dl>
  <div>
    <dt><code>ref</code></dt>
    <dd>the document reference.</dd>
  </div>

  <div>
    <dt><code>score</code></dt>
    <dd>a relative measure of how similar this document is to the query, the results are sorted by this property.
  </div>

  <div>
    <dt><code>metadata</code></dt>
    <dd>any metadata associated with query tokens found in this document.</dd>
  </div>
</dl>

The metadata contains a key for each search term found in the document and in which field of the document it was found. Inside this will be all the metadata that was captured about this term in this field, for example the position of the term matches, e.g.

```javascript
{
  "ref": "123",
  "score": 0.123456,
  "metadata": {
    "test": {
      "body": {
        "positions": [[0, 4], [24, 4]]
      }
    }
  }
}
```
