type media_value =
  | Media_all
  | Media_aural
  | Media_braille
  | Media_handheld
  | Media_projection
  | Media_print
  | Media_screen
  | Media_tty
  | Media_tv
  | Media_min_width of string

type media =
  | Media_or  of media * media
  | Media_and of media * media
  | Media_not of media
  | Media_val of media_value

type rel_value =
  | Rel_icon
  | Rel_stylesheet

type link = {
  href  : string ;
  media : media ;
  rel   : rel_value
}

let link ?href:(href="")
         ?media:(media=(Media_val Media_all))
         ~rel ()
= {
  href ;
  media ;
  rel
}

let export_link link =
  "\t\t<link/>\n"

type head = {
  links : link list ;
  title : string
}

let head ?links:(links=[]) ~title = {
  links ;
  title
}

let export_head head =
  "\t<head>\n" ^
  "\t\t<title>" ^ head.title ^ "</title>\n" ^
  (List.fold_left (fun a b -> a ^ export_link b) "" head.links) ^
  "\t</head>\n"

(* We could enrich it with a supertype to add general attributes. *)
(* This also might be insufficient as we may want users to define their own
 * tags. *)
type body_tag =
  | Tag_p of string

type body = body_tag list

type 'a element = body -> 'a

let p s content k = k (Tag_p s :: content)

let body k = k []

let body_end content = content

let export_tag tag =
  match tag with
  | Tag_p s -> "\t\t<p>" ^ s ^ "</p>\n"

let export_body body =
  "\t<body>\n" ^
  (List.fold_left (fun a b -> a ^ (export_tag b)) "" (List.rev body)) ^
  "\t</body>\n"

type html = {
  head : head ;
  body : body
}

let html head body = {
  head ;
  body
}

let export html =
  "<!doctype html>\n" ^
  "<html>\n" ^
  (export_head html.head) ^
  (export_body html.body) ^
  "</html>\n"
