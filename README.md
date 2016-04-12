# ocawb

The purpose of this repository is to build an ocaml tool to write html.
The first phase of this work is to reflect (a subset of) HTML in ocaml.  
Later on, I will try to provide more functionalities.

*This needs some refactoring so no example for now, sorry...*

<!-- Thanks to the power of continuations, on currently can write the following
ocaml code:

```ocaml
open Html

let my_html =
  html
    (head
      ~links:[
        link ~href:"style.css" ~rel:Rel_stylesheet () ;
        link ~href:"icon.png" ~rel:Rel_icon ()
      ]
      ~title:"My first page" ())
    (body
      (p @@ r"We write paragraphs!")
      (a ~href:"index.html" ~download:"filename" ~target:Target_self
        (p @@ r"We can also add [p] inside [a]")
        (a ~accesskey:'h'
          (p @@ r"This is just for show but we also put anchors in anchors.")
          (p @@
            r"Isn't that all nice?" ++
            (abbr ~title:"Oh My God" (r"OMG")))
          (address
            (p @@ r"Maybe we don't want to put [p] inside [address].")
          close)
        close)
        (p @@ r"Isn't it awesome?")
      close)
      (article
        (p @@ r"Because for now this is the only thing we can do.")
        (p @@ r"It indeed works!")
      close)
      (aside
        (p @@ r"This is some aside, so wonderful.")
        (blockquote ~cite:"lulz.com"
          (p @@ r"Everything is better than HTML...")
          (p @@ r"-- Somebody dead")
        close)
      close)
    body_end)

let () =
  print_string (export my_html)
```

To produce the following html:
```html
<!doctype html>
<html>
  <head>
    <title>My first page</title>
    <link href="style.css" rel="stylesheet">
    <link href="icon.png" rel="icon">
  </head>
  <body>
    <p>We write paragraphs!</p>
    <a href="index.html" download="filename" target="_self">
      <p>We can also add [p] inside [a]</p>
      <a accesskey="h">
        <p>This is just for show but we also put anchors in anchors.</p>
        <p>Isn't that all nice?<abbr title="Oh My God">OMG</abbr></p>
        <address>
          <p>Maybe we don't want to put [p] inside [address].</p>
        </address>
      </a>
      <p>Isn't it awesome?</p>
    </a>
    <article>
      <p>Because for now this is the only thing we can do.</p>
      <p>It indeed works!</p>
    </article>
    <aside>
      <p>This is some aside, so wonderful.</p>
      <blockquote cite="lulz.com">
        <p>Everything is better than HTML...</p>
        <p>-- Somebody dead</p>
      </blockquote>
    </aside>
  </body>
</html>
``` -->
