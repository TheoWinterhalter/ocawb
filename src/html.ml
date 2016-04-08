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
  | Media_min_width  of string
  | Media_max_width  of string
  | Media_width      of string
  | Media_min_height of string
  | Media_max_height of string
  | Media_height     of string

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
  | Media_min_width  s -> "(min-width:" ^ s ^ ")"
  | Media_max_width  s -> "(max-width:" ^ s ^ ")"
  | Media_width      s -> "(width:" ^ s ^ ")"
  | Media_min_height s -> "(min-height:" ^ s ^ ")"
  | Media_max_height s -> "(max-height:" ^ s ^ ")"
  | Media_height     s -> "(height:" ^ s ^ ")"

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

let head ?links:(links=[]) ~title () = {
  links ;
  title
}

let export_head head =
  tab ^ "<head>\n" ^
  tabtab ^ "<title>" ^ head.title ^ "</title>\n" ^
  (List.fold_left (fun a b -> a ^ export_link tabtab b) "" head.links) ^
  tab ^ "</head>\n"

type target =
  | Target_blank
  | Target_parent
  | Target_self
  | Target_top

let export_target = function
  | Target_blank  -> "_blank"
  | Target_parent -> "_parent"
  | Target_self   -> "_self"
  | Target_top    -> "_top"

type a_info = {
  href : string option ;
  download : string option ;
  target : target option
}

let export_a_info i =
  (match i.href with
   | None -> ""
   | Some u -> " href=\"" ^ u ^ "\"") ^
  (match i.download with
   | None -> ""
   | Some v -> " download=\"" ^ v ^ "\"") ^
  (match i.target with
   | None -> ""
   | Some v -> " target=\"" ^ (export_target v) ^ "\"")

(* We could enrich it with a supertype to add general attributes. *)
(* This also might be insufficient as we may want users to define their own
 * tags. *)
type body_tag =
  | Tag_p of string
  | Tag_a of a_info * body_tag list

type body = body_tag list
type content = body * (body -> body_tag)

type 'a element = content -> 'a
type 'a k = 'a element -> 'a

let a ?href ?download ?target elt =
  elt ([], fun c -> Tag_a ({ href ; download ; target }, c))

let close (c1,h1) (c2,h2) k =
  k ((h1 c1) :: c2, h2)

let p s (c,h) k = k (Tag_p s :: c, h)

let body elt = elt ([], fun c -> assert false)

let body_end (c,_) = c

let rec export_content indent content =
  List.fold_left (fun a b -> a ^ (export_tag indent b)) "" (List.rev content)

and export_tag indent tag = indent ^
  match tag with
  | Tag_p s -> "<p>" ^ s ^ "</p>\n"
  | Tag_a (i,c) ->
    "<a" ^ (export_a_info i) ^ ">\n" ^
    (export_content (indent ^ tab) c) ^
    indent ^ "</a>\n"

let export_body body =
  tab ^ "<body>\n" ^
  (export_content tabtab body) ^
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
