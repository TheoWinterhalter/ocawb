let tab = "  "
let tabtab = tab ^ tab

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

let export_media_value v =
  match v with
  | Media_all        -> "all"
  | Media_aural      -> "aural"
  | Media_braille    -> "braille"
  | Media_handheld   -> "handheld"
  | Media_projection -> "projection"
  | Media_print      -> "print"
  | Media_screen     -> "screen"
  | Media_tty        -> "tty"
  | Media_tv         -> "tv"
  | Media_min_width s -> "(min-width:" ^ s ^ ")"

type media =
  | Media_or  of media * media
  | Media_and of media * media
  | Media_not of media
  | Media_val of media_value

let rec export_media media = "(" ^
  (match media with
  | Media_or  (a,b) -> (export_media a) ^ ","     ^ (export_media b)
  | Media_and (a,b) -> (export_media a) ^ " and " ^ (export_media b)
  | Media_not a     -> "not " ^ (export_media a)
  | Media_val v     -> export_media_value v) ^ ")"

type rel_value =
  | Rel_icon
  | Rel_stylesheet

let export_rel r =
  match r with
  | Rel_icon       -> "icon"
  | Rel_stylesheet -> "stylesheet"

type link = {
  href  : string option ;
  media : media option ;
  rel   : rel_value
}

let link ?href
         ?media
         ~rel ()
= {
  href ;
  media ;
  rel
}

let export_link indent link =
  indent ^ "<link" ^
  (match link.href with None -> "" | Some u -> " href=\"" ^ u ^ "\"") ^
  (match link.media with
   | None -> ""
   | Some m -> " media=\"" ^ (export_media m) ^ "\"") ^
  " rel=\"" ^ (export_rel link.rel) ^ "\"" ^
  ">\n"

type head = {
  links : link list ;
  title : string
}

let head ?links:(links=[]) ~title = {
  links ;
  title
}

let export_head head =
  tab ^ "<head>\n" ^
  tabtab ^ "<title>" ^ head.title ^ "</title>\n" ^
  (List.fold_left (fun a b -> a ^ export_link tabtab b) "" head.links) ^
  tab ^ "</head>\n"

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

let export_tag indent tag =
  match tag with
  | Tag_p s -> indent ^ "<p>" ^ s ^ "</p>\n"

let export_body body =
  tab ^ "<body>\n" ^
  (List.fold_left (fun a b -> a ^ (export_tag tabtab b)) "" (List.rev body)) ^
  tab ^ "</body>\n"

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
