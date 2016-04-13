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
        close)
        (* Still some problem here, I cannot put phrasing just yet. *)
        (* (a ~accesskey:'h'
          (text "This is just for show but we also put anchors in anchors.")
          (text "Isn't that all nice? ")
          (abbr ~title:"Oh My God"
            (text "OMG")
          close)
        close) *)
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
