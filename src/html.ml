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

type preload_behavior =
  | Preload_none
  | Preload_metadata
  | Preload_auto

let export_preload b =
  match b with
  | Preload_none -> "none"
  | Preload_metadata -> "metadata"
  | Preload_auto -> "auto"

type audio_info = {
  autoplay : bool ;
  preload : preload_behavior option ;
  controls : bool ;
  loop : bool ;
  mediagroup : string option ;
  muted : bool ;
  src : string option
}

let export_audio_info i =
  (match i.autoplay with
   | false -> ""
   | true  -> " autoplay") ^
  (match i.preload with
   | None -> ""
   | Some u -> " preload=\"" ^ (export_preload u) ^ "\"") ^
  (match i.controls with
   | false -> ""
   | true  -> " controls") ^
  (match i.loop with
   | false -> ""
   | true  -> " loop") ^
  (match i.mediagroup with
   | None -> ""
   | Some u -> " mediagroup=\"" ^ u ^ "\"") ^
  (match i.muted with
   | false -> ""
   | true -> " muted") ^
  (match i.src with
   | None -> ""
   | Some u -> " src=\"" ^ u ^ "\"")

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

type canvas_info = {
  height : string option ;
  width  : string option
}

let export_canvas_info i =
  (match i.height with
   | None -> ""
   | Some u -> " height=\"" ^ u ^ "\"") ^
  (match i.width with
   | None -> ""
   | Some u -> " width=\"" ^ u ^ "\"")

(* We could enrich it with a supertype to add general attributes. *)
(* This also might be insufficient as we may want users to define their own
 * tags. *)
type general_attributes = {
  accesskey : char option ;
  classes : string option ; (* TODO Use a list instead? *)
  contenteditable : bool option ;
  id : string option
}

let empty_attributes = {
  accesskey       = None ;
  classes         = None ;
  contenteditable = None ;
  id              = None
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
   | Some a -> Printf.sprintf " contenteditable=\"%b\"" a) ^
  (match attr.id with
   | None -> ""
   | Some a -> Printf.sprintf " id=\"%s\"" a)

type flow
type phrasing

type _ body_tag =
  | Text           : string                      -> 'a       body_tag
  | Tag_a          : a_info * 'a body            -> 'a       body_tag
  | Tag_abbr       : abbr_info * phrasing body   -> phrasing body_tag
  | Tag_address    : flow body                   -> flow     body_tag
  | Tag_article    : flow body                   -> flow     body_tag
  | Tag_aside      : flow body                   -> flow     body_tag
  | Tag_audio      : audio_info * 'a body        -> 'a       body_tag
  | Tag_b          : phrasing body               -> phrasing body_tag
  | Tag_blockquote : blockquote_info * flow body -> flow     body_tag
  | Tag_br         :                                phrasing body_tag
  | Tag_canvas     : canvas_info * 'a body       -> 'a       body_tag
  | Tag_cite       : phrasing body               -> phrasing body_tag
  | Tag_code       : phrasing body               -> phrasing body_tag
  | Tag_div        : flow body                   -> flow     body_tag
  | Tag_em         : phrasing body               -> phrasing body_tag
  | Tag_footer     : flow body                   -> flow     body_tag
  | Tag_h1         : phrasing body               -> flow     body_tag
  | Tag_h2         : phrasing body               -> flow     body_tag
  | Tag_h3         : phrasing body               -> flow     body_tag
  | Tag_h4         : phrasing body               -> flow     body_tag
  | Tag_h5         : phrasing body               -> flow     body_tag
  | Tag_h6         : phrasing body               -> flow     body_tag
  | Tag_p          : phrasing body               -> flow     body_tag

and 'a body = 'a full_tag list
and 'a full_tag = general_attributes * 'a body_tag
type ('a, 'b, 'c) content = 'a body * ('b body -> 'c full_tag)

type ('a,'b,'c,'d) element = ('b, 'c, 'd) content -> 'a
type ('a,'b,'c,'d) k = ('a, 'b, 'c, 'd) element -> 'a
type 'a gentag = ?accesskey: char ->
                 ?classes: string ->
                 ?contenteditable: bool -> 'a

type ('a,'b,'c,'d) tag = ?id: string ->
  (('a, 'b, 'c, 'd) element -> 'a) gentag
type ('a,'b,'c) void_tag = ?id: string ->
  (unit -> (('a, 'b, 'c, 'b) k, 'b, 'c, 'b) element) gentag

let text s (c,h) k =
  k ((empty_attributes, Text s) :: c, h)

let mktag id tag ?accesskey ?classes ?contenteditable elt =
  elt ([], (fun c -> { accesskey ; classes ; contenteditable ; id } , tag c))

let voidtag id tag ?accesskey ?classes ?contenteditable () (c,h) k =
  k (({ accesskey ; classes ; contenteditable ; id } , tag) :: c, h)

let a ?href ?download ?target ?id =
  mktag id (fun c -> Tag_a ({ href ; download ; target }, c))

let abbr ?title ?id =
  mktag id (fun c -> Tag_abbr ({ title }, c))

let address ?id =
  mktag id (fun c -> Tag_address c)

let article ?id =
  mktag id (fun c -> Tag_article c)

let aside ?id =
  mktag id (fun c -> Tag_aside c)

let audio ?autoplay:(autoplay=false) ?preload ?controls:(controls=false)
          ?loop:(loop=false) ?mediagroup ?muted:(muted=false) ?src ?id =
  let attrs = {
    autoplay ; preload ; controls ; loop ; mediagroup ; muted ; src
  } in
  mktag id (fun c -> Tag_audio (attrs, c))

let b ?id =
  mktag id (fun c -> Tag_b c)

let blockquote ?cite ?id =
  mktag id (fun c -> Tag_blockquote ({ cite }, c))

let br ?id =
  voidtag id Tag_br

let canvas ?height ?width ?id =
  mktag id (fun c -> Tag_canvas ({ height ; width }, c))

let cite ?id =
  mktag id (fun c -> Tag_cite c)

let code ?id =
  mktag id (fun c -> Tag_code c)

let div ?id =
  mktag id (fun c -> Tag_div c)

let em ?id =
  mktag id (fun c -> Tag_em c)

let footer ?id =
  mktag id (fun c -> Tag_footer c)

let h1 ?id =
  mktag id (fun c -> Tag_h1 c)

let h2 ?id =
  mktag id (fun c -> Tag_h2 c)

let h3 ?id =
  mktag id (fun c -> Tag_h3 c)

let h4 ?id =
  mktag id (fun c -> Tag_h4 c)

let h5 ?id =
  mktag id (fun c -> Tag_h5 c)

let h6 ?id =
  mktag id (fun c -> Tag_h6 c)

let p ?id =
  mktag id (fun c -> Tag_p c)

let close (c1,h1) (c2,h2) k =
  k ((h1 c1) :: c2, h2)

let body ?id = mktag id (fun c -> assert false)

let body_end (c,_) = c

let rec export_content : type a. string -> a body -> string
= fun indent content ->
  List.fold_left (fun a b -> a ^ (export_tag indent b)) "" (List.rev content)

(* TODO Make a generic function? *)
and export_tag : type a. string -> a full_tag -> string
= fun indent (attr,tag) -> indent ^
  match tag with
  | Text s -> s ^ "\n"
  | Tag_a (i,c) ->
    "<a" ^ (export_a_info i) ^ (export_generic_attr attr) ^ ">\n" ^
    (export_content (indent ^ tab) c) ^
    indent ^ "</a>\n"
  | Tag_abbr (i,c) ->
    "<abbr" ^ (export_abbr_info i) ^ (export_generic_attr attr) ^ ">\n" ^
    (export_content (indent ^ tab) c) ^
    indent ^ "</abbr>\n"
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
  | Tag_audio (i,c) ->
    "<audio" ^ (export_audio_info i) ^ (export_generic_attr attr) ^ ">\n" ^
    (export_content (indent ^ tab) c) ^
    indent ^ "</audio>\n"
  | Tag_b c ->
    "<b" ^ (export_generic_attr attr) ^ ">\n" ^
    (export_content (indent ^ tab) c) ^
    indent ^ "</b>\n"
  | Tag_blockquote (i,c) ->
    "<blockquote" ^
      (export_blockquote_info i) ^
      (export_generic_attr attr) ^
    ">\n" ^
    (export_content (indent ^ tab) c) ^
    indent ^ "</blockquote>\n"
  | Tag_br -> "<br" ^ (export_generic_attr attr) ^ " />\n"
  | Tag_canvas (i,c) ->
    "<canvas" ^ (export_canvas_info i) ^ (export_generic_attr attr) ^ ">\n" ^
    (export_content (indent ^ tab) c) ^
    indent ^ "</canvas>\n"
  | Tag_cite c ->
    "<cite" ^ (export_generic_attr attr) ^ ">\n" ^
    (export_content (indent ^ tab) c) ^
    indent ^ "</cite>\n"
  | Tag_code c ->
    "<code" ^ (export_generic_attr attr) ^ ">\n" ^
    (export_content (indent ^ tab) c) ^
    indent ^ "</code>\n"
  | Tag_div c ->
    "<div" ^ (export_generic_attr attr) ^ ">\n" ^
    (export_content (indent ^ tab) c) ^
    indent ^ "</div>\n"
  | Tag_em c ->
    "<em" ^ (export_generic_attr attr) ^ ">\n" ^
    (export_content (indent ^ tab) c) ^
    indent ^ "</em>\n"
  | Tag_footer c ->
    "<footer" ^ (export_generic_attr attr) ^ ">\n" ^
    (export_content (indent ^ tab) c) ^
    indent ^ "</footer>\n"
  | Tag_h1 c ->
    "<h1" ^ (export_generic_attr attr) ^ ">\n" ^
    (export_content (indent ^ tab) c) ^
    indent ^ "</h1>"
  | Tag_h2 c ->
    "<h2" ^ (export_generic_attr attr) ^ ">\n" ^
    (export_content (indent ^ tab) c) ^
    indent ^ "</h2>"
  | Tag_h3 c ->
    "<h3" ^ (export_generic_attr attr) ^ ">\n" ^
    (export_content (indent ^ tab) c) ^
    indent ^ "</h3>"
  | Tag_h4 c ->
    "<h4" ^ (export_generic_attr attr) ^ ">\n" ^
    (export_content (indent ^ tab) c) ^
    indent ^ "</h4>"
  | Tag_h5 c ->
    "<h5" ^ (export_generic_attr attr) ^ ">\n" ^
    (export_content (indent ^ tab) c) ^
    indent ^ "</h5>"
  | Tag_h6 c ->
    "<h6" ^ (export_generic_attr attr) ^ ">\n" ^
    (export_content (indent ^ tab) c) ^
    indent ^ "</h6>"
  | Tag_p c ->
    "<p" ^ (export_generic_attr attr) ^ ">\n" ^
    (export_content (indent ^ tab) c) ^
    indent ^ "</p>\n"

let export_body body =
  tab ^ "<body>\n" ^
  (export_content tabtab body) ^
  tab ^ "</body>\n"

type html = {
  head : head ;
  body : flow body
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
