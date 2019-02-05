URL Embed Gitbook Plugin
==============

This plugins requires gitbook `>=2.0.0`.

### Install

Add this to your `book.json`, then run `gitbook install`:

```
{
    "plugins": ["url-embed"]
}
```

### Usage

The plugin allows you to embed dynamic content in your Gitbook as an iframe, and if you generate a PDF or ePub version of the book, it will instead insert an image of the corresponding content.

The plugin expects that you will have a .png image in your /assets/ folder with a name that matches the path of the url. For instance:

```
{% urlembed %}
https://website.org/stuff/this-is-the-path-name
{% endurlembed %}

```

For the example above, you should include a file in /assets/ called 'this-is-the-path-name.png'
