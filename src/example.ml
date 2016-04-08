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
