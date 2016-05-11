# ocawb

The purpose of this repository is to build an ocaml tool to write html.
The first phase of this work is to reflect (a subset of) HTML in ocaml.  
Later on, I will try to provide more functionalities.

Thanks to the power of continuations, one currently can write the following
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
      (p
        (text "We write paragraphs!")
        (a ~href:"sup.html"
          (text "We can put [a] inside flow.")
        close)
      close)
      (a ~href:"index.html" ~download:"filename" ~target:Target_self
        (p
          (text "We can also add [p] inside [a]")
          (a ~accesskey:'h'
            (text "This is just for show but we also put anchors in anchors.")
            (text "Isn't that all nice? ")
            (abbr ~title:"Oh My God"
              (text "OMG")
            close)
          close)
        close)
        (address
          (text "Maybe we don't want to put [p] inside [address].")
        close)
        (text "Isn't it awesome?")
      close)
      (article
        (text "Because for now this is the only thing we can do.")
        (text "It indeed works!")
      close)
      (aside
        (text "This is some aside, so wonderful.")
        (blockquote ~cite:"lulz.com"
          (text "Everything is better than HTML...")
          (text "-- Somebody dead")
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
    <p>
      We write paragraphs!
      <a href="sup.html">
        We can put [a] inside flow.
      </a>
    </p>
    <a href="index.html" download="filename" target="_self">
      <p>
        We can also add [p] inside [a]
        <a accesskey="h">
          This is just for show but we also put anchors in anchors.
          Isn't that all nice?
          <abbr title="Oh My God">
            OMG
          </abbr>
        </a>
      </p>
      <address>
        Maybe we don't want to put [p] inside [address].
      </address>
      Isn't it awesome?
    </a>
    <article>
      Because for now this is the only thing we can do.
      It indeed works!
    </article>
    <aside>
      This is some aside, so wonderful.
      <blockquote cite="lulz.com">
        Everything is better than HTML...
        -- Somebody dead
      </blockquote>
    </aside>
  </body>
</html>
```
