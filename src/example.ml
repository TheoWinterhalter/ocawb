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
      (p "We write paragraphs!")
      (a ~href:"index.html" ~download:"filename" ~target:Target_self
        (p "We can also add [p] inside [a]")
        (a ~accesskey:'h'
          (p "This is just for show but we also put anchors in anchors.")
          (p "Isn't that all nice?")
          (abbr ~title:"Oh My God" "OMG")
          (address
            (p "Maybe we don't want to put [p] inside [address].")
          close)
        close)
        (p "Isn't it awesome?")
      close)
      (article
        (p "Because for now this is the only thing we can do.")
        (p "It indeed works!")
      close)
      (aside
        (p "This is some aside, so wonderful.")
        (blockquote ~cite:"lulz.com"
          (p "Everything is better than HTML...")
          (p "-- Somebody dead")
        close)
      close)
    body_end)

let () =
  print_string (export my_html)
