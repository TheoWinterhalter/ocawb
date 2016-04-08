# ocawb

The purpose of this repository is to build an ocaml tool to write html.
The first phase of this work is to reflect (a subset of) HTML in ocaml.  
Later on, I will try to provide more functionalities.

Thanks to the power of continuations, on currently can write the following
ocaml code:

```ocaml
open Html

let my_head =
  head ~links:[link ~href:"style.css" ~rel:Rel_stylesheet ()]
       ~title:"My first page" ()

let my_body =
  body
    (p "We write paragraphs!")
    (a ~href:"index.html" ~download:"filename" ~target:Target_self
      (p "We can also add [p] inside [a]")
      (a
        (p "This is just for show but we also put anchors in anchors.")
        (p "Isn't that all nice?")
      close)
      (p "Isn't it awesome?")
    close)
    (p "Because for now this is the only thing we can do.")
    (p "It indeed works!")
  body_end

let my_html =
  html my_head my_body

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
  </head>
  <body>
    <p>We write paragraphs!</p>
    <a href="index.html" download="filename" target="_self">
      <p>We can also add [p] inside [a]</p>
      <a>
        <p>This is just for show but we also put anchors in anchors.</p>
        <p>Isn't that all nice?</p>
      </a>
      <p>Isn't it awesome?</p>
    </a>
    <p>Because for now this is the only thing we can do.</p>
    <p>It indeed works!</p>
  </body>
</html>
```
