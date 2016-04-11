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

type abbr_info = {
  title : string option
}

let export_abbr_info i =
  (match i.title with
   | None -> ""
   | Some t -> " title=\"" ^ t ^ "\"")

type blockquote_info = {
  cite : string option
}

let export_blockquote_info i =
  (match i.cite with
   | None -> ""
   | Some u -> " cite=\"" ^ u ^ "\"")

(* We could enrich it with a supertype to add general attributes. *)
(* This also might be insufficient as we may want users to define their own
 * tags. *)
type general_attributes = {
  accesskey : char option ;
  classes : string option ; (* TODO Use a list instead? *)
  contenteditable : bool option
}

let export_generic_attr attr =
  (match attr.accesskey with
   | None -> ""
   | Some a -> Printf.sprintf " accesskey=\"%c\"" a) ^
  (match attr.classes with
   | None -> ""
   | Some a -> Printf.sprintf " class=\"%s\"" a) ^
  (match attr.contenteditable with
   | None -> ""
   | Some a -> Printf.sprintf " contenteditable=\"%b\"" a)

type text =
  | Cat of text * text
  | String of string
  | Text_abbr of abbr_info * text
  | Text_b of text

type body_tag =
  | Tag_p of text
  | Tag_a of a_info * body
  | Tag_address of body
  | Tag_article of body
  | Tag_aside of body
  | Tag_blockquote of blockquote_info * body
and body = full_tag list
and full_tag = general_attributes * body_tag
type content = body * (body -> full_tag)

type 'a element = content -> 'a
type 'a k = 'a element -> 'a
type 'a gentag = ?accesskey: char ->
                 ?classes: string ->
                 ?contenteditable : bool -> 'a

let r s = String s
let (++) s1 s2 = Cat (s1,s2)
let abbr ?title s = Text_abbr ({ title }, s)
let b s = Text_b s


let mktag tag ?accesskey ?classes ?contenteditable elt =
  elt ([], (fun c -> { accesskey ; classes ; contenteditable } , tag c))

let a ?href ?download ?target =
  mktag (fun c -> Tag_a ({ href ; download ; target }, c))

let address ?foo =
  mktag (fun c -> Tag_address c)

let article ?foo =
  mktag (fun c -> Tag_article c)

let aside ?foo =
  mktag (fun c -> Tag_aside c)

let blockquote ?cite =
  mktag (fun c -> Tag_blockquote ({ cite }, c))

let p ?accesskey ?classes ?contenteditable s (c,h) k =
  k (({ accesskey ; classes ; contenteditable }, Tag_p s) :: c, h)

let close (c1,h1) (c2,h2) k =
  k ((h1 c1) :: c2, h2)

let body ?foo = mktag (fun c -> assert false)

let body_end (c,_) = c

let rec export_text = function
  | Cat (a,b) -> (export_text a) ^ (export_text b)
  | String s -> s
  | Text_abbr (i,s) ->
    "<abbr" ^ (export_abbr_info i) ^ ">" ^
    (export_text s) ^
    "</abbr>"
  | Text_b s -> "<b>" ^ (export_text s) ^ "</b>"

let rec export_content indent content =
  List.fold_left (fun a b -> a ^ (export_tag indent b)) "" (List.rev content)

(* TODO Make a generic function? *)
and export_tag indent (attr,tag) = indent ^
  match tag with
  | Tag_a (i,c) ->
    "<a" ^ (export_a_info i) ^ (export_generic_attr attr) ^ ">\n" ^
    (export_content (indent ^ tab) c) ^
    indent ^ "</a>\n"
  | Tag_address c ->
    "<address" ^ (export_generic_attr attr) ^ ">\n" ^
    (export_content (indent ^ tab) c) ^
    indent ^ "</address>\n"
  | Tag_article c ->
    "<article" ^ (export_generic_attr attr) ^ ">\n" ^
    (export_content (indent ^ tab) c) ^
    indent ^ "</article>\n"
  | Tag_aside c ->
    "<aside" ^ (export_generic_attr attr) ^ ">\n" ^
    (export_content (indent ^ tab) c) ^
    indent ^ "</aside>\n"
  | Tag_blockquote (i,c) ->
    "<blockquote" ^
      (export_blockquote_info i) ^
      (export_generic_attr attr) ^
    ">\n" ^
    (export_content (indent ^ tab) c) ^
    indent ^ "</blockquote>\n"
  | Tag_p s ->
    "<p" ^ (export_generic_attr attr) ^ ">" ^
    (export_text s) ^
    "</p>\n"

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
