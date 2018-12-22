# Akedia

## Features

* Bare minimum micropub
* Sending webmentions
* Receiving webmentions through webmention.io
* POSSE to github via brid.gy <3
* Image upload

## Deployment

* Dependencies on the target system:
  * `build_essential`
  * `imagemagick`

Nginx needs to be configured to alias requests to `/upload` to the uploads dir:

```
location /uploads {
    alias <APP_DIR>/release/akedia/uploads;
}
```


build a release:

```
mix edeliver build release
mix edeliver deploy release to production --version=x.x.x
mix edeliver restart production
mix edeliver migrate production
```

## Webmention

```
%{
  "post" => %{
    "author" => %{
      "name" => "Jonathan Jenne",
      "photo" => "https://webmention.io/avatar/inhji.de/8562c1bc852d1eca8f314d7f46c8e29bd5636efb1c4cdc1682aa8a80c5fd4167.jpg",
      "type" => "card",
      "url" => "https://inhji.de/"
    },
    "content" => %{
      "content-type" => "text/html",
      "html" => "<p>Replying to <a href=\"https://inhji.de/posts/1\" class=\"u-in-reply-to\">myself</a> again. And a simple mention on top: <a href=\"https://inhji.de/posts/1\">https://inhji.de/posts/1</a></p>",
      "text" => "Replying to myself again. And a simple mention on top: https://inhji.de/posts/1",
      "value" => "<p>Replying to <a href=\"https://inhji.de/posts/1\" class=\"u-in-reply-to\">myself</a> again. And a simple mention on top: <a href=\"https://inhji.de/posts/1\">https://inhji.de/posts/1</a></p>"
    },
    "in-reply-to" => "https://inhji.de/posts/1",
    "published" => "2018-11-25T13:59:11",
    "type" => "entry",
    "url" => "https://inhji.de/posts/43",
    "wm-id" => 564717,
    "wm-private" => false,
    "wm-property" => "in-reply-to",
    "wm-received" => "2018-11-25T13:59:14Z"
  },
  "private" => false,
  "secret" => "46042c23-6ce4-4d3e-bfdc-297877a16066",
  "source" => "https://inhji.de/posts/43",
  "target" => "https://inhji.de/posts/1"
}
```
