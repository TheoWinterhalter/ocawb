open Html

(* let my_html =
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
            r"Isn't that all nice? " ++
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
  print_string (export my_html) *)
