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

type media =
  | Media_or  of media * media
  | Media_and of media * media
  | Media_not of media
  | Media_val of media_value

type rel_value =
  | Rel_icon
  | Rel_stylesheet
  (* Are the others necessary? *)

type link
val link : ?href:  string -> (* Some better idea? *)
           ?media: media ->
           rel:    rel_value ->
           unit -> link

type head
val head : (* ?styles: style list -> *)
           (* ?base: ? -> *)
           ?links: link list ->
           (* ?metas: meta list -> *)
           (* ?scripts: scrupt list -> *)
           (* ?noscripts? *)
           title: string ->
           unit -> head

type flow
type phrasing

type 'a body
type ('a,'b,'c,'d) element
type ('a,'b,'c,'d) k = ('a, 'b, 'c, 'd) element -> 'a
type 'a gentag = ?accesskey: char ->
                 ?classes: string ->
                 ?contenteditable : bool -> 'a

type target =
  | Target_blank
  | Target_parent
  | Target_self
  | Target_top

(* Text (normal character data) *)
val text : string -> (('a, 'b, 'c, 'd) k, 'b, 'c, 'd) element

(* All tags (flow and phrasing mixed) *)
val a : ?href: string ->
        ?download: string ->
        ?target: target ->
        (('a, 'b, 'c, 'c) element -> 'a) gentag
val abbr : ?title: string ->
           (('a, 'b, phrasing, phrasing) element -> 'a) gentag
val address : ?id:string -> (('a, 'b, flow, flow) element -> 'a) gentag
(* area TODO? *)
val article : ?id:string -> (('a, 'b, flow, flow) element -> 'a) gentag
val aside : ?id:string -> (('a, 'b, flow, flow) element -> 'a) gentag
(* TODO audio *)
val b : ?id:string -> (('a, 'b, phrasing, phrasing) element -> 'a) gentag
val blockquote : ?cite: string -> (('a, 'b, flow, flow) element -> 'a) gentag
val br : ?id:string ->
         (unit ->
          (('a, phrasing, 'c, phrasing) k, phrasing, 'c, phrasing) element)
          gentag
(* TODO button *)
val canvas : ?height: string ->
             ?width: string ->
             (('a, 'b, 'c, 'c) element -> 'a) gentag
val cite : ?id:string -> (('a, 'b, phrasing, phrasing) element -> 'a) gentag
val code : ?id:string -> (('a, 'b, phrasing, phrasing) element -> 'a) gentag
(* TODO col *)
(* TODO colgroup *)
(* TODO datalist *)
(* TODO dd *)
(* TODO del *)
(* TODO details *)
(* TODO dfn *)
(* TODO dialog *)
val div : ?id:string -> (('a, 'b, flow, flow) element -> 'a) gentag
val em : ?id:string -> (('a, 'b, phrasing, phrasing) element -> 'a) gentag
val footer : ?id:string -> (('a, 'b, flow, flow) element -> 'a) gentag
val p : ?id:string -> (('a, 'b, phrasing, flow) element -> 'a) gentag
val close : ((('a, 'b, 'c, 'd) k, 'b, 'c, 'd) element, 'h, 'h, 'b) element

val body : ?id:string -> (('a, 'b, flow, flow) element -> 'a) gentag
val body_end : (flow body, flow, 'c, 'd) element

type html
val html : head -> flow body -> html

val export : html -> string
