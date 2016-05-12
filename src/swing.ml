(* This example is an instance of the Side-Winged Document I wish to create. *)
open Html

(* HEAD *)
let swing_head =
  head
    ~links:[link ~href:"style.css" ~rel:Rel_stylesheet ()]
    ~title: "Side Winged Document Instance" ()

(* To make up for the missing tags *)
let nav = div
let aside = div
let main = div

(* STRUCTURE *)
let swing_body =
  body
    (nav
      (h3
        (text "Structure of the document.")
      close)
      (text "This basically contains the table of contents.")
    close)
    (aside
      (h3
        (text "Side Notes.")
      close)
      (text @@ "The idea is that there are no footnotes or such things. " ^
               "Some figures might also appear here if it is relevant for " ^
               "the main body.")
    close)
    (main
      (h3
        (text "Body of the text.")
      close)
      (text "It is the main content of the document.")
    close)
  body_end

(* PAGE *)
let swing_page = html swing_head swing_body

(* EXPORT *)
let () =
  let open Printf in
  let oc = open_out "swingdoc/index.html" in
  fprintf oc "%s\n" (export swing_page) ;
  close_out oc
