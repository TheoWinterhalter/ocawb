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
                 ?contenteditable: bool -> 'a

(*** Some types to see clearer *)

(** The only important types are 'c, content model of the tag, *)
(** and 'd, content model of its parent  *)
type ('a,'b,'c,'d) tag =
  (('a, 'b, 'c, 'd) element -> 'a) gentag

(** 'b is the content model of the parent *)
type ('a,'b,'c) void_tag =
  (unit -> (('a, 'b, 'c, 'b) k, 'b, 'c, 'b) element) gentag

type target =
  | Target_blank
  | Target_parent
  | Target_self
  | Target_top

(* Text (normal character data) *)
val text : string -> (('a, 'b, 'c, 'd) k, 'b, 'c, 'd) element

(* All tags (flow and phrasing mixed) *)
val a : ?id: string ->
        ?href: string ->
        ?download: string ->
        ?target: target ->
        ('a, 'b, 'c, 'c) tag
val abbr : ?id:string -> ?title: string -> ('a, 'b, phrasing, phrasing) tag
val address : ?id:string -> ('a, 'b, flow, flow) tag
(* area TODO? *)
val article : ?id:string -> ('a, 'b, flow, flow) tag
val aside : ?id:string -> ('a, 'b, flow, flow) tag
(* TODO audio *)
val b : ?id:string -> ('a, 'b, phrasing, phrasing) tag
val blockquote : ?id: string ->
                 ?cite: string ->
                 ('a, 'b, flow, flow) tag
val br : ?id:string -> ('a, phrasing, 'c) void_tag
(* TODO button *)
val canvas : ?id: string ->
             ?height: string ->
             ?width: string ->
             ('a, 'b, 'c, 'c) tag
val cite : ?id:string -> ('a, 'b, phrasing, phrasing) tag
val code : ?id:string -> ('a, 'b, phrasing, phrasing) tag
(* TODO col *)
(* TODO colgroup *)
(* TODO datalist *)
(* TODO dd *)
(* TODO del *)
(* TODO details *)
(* TODO dfn *)
(* TODO dialog *)
val div : ?id:string -> ('a, 'b, flow, flow) tag
val em : ?id:string -> ('a, 'b, phrasing, phrasing) tag
val footer : ?id:string -> ('a, 'b, flow, flow) tag
val h1 : ?id:string -> ('a, 'b, phrasing, flow) tag
val h2 : ?id:string -> ('a, 'b, phrasing, flow) tag
val h3 : ?id:string -> ('a, 'b, phrasing, flow) tag
val h4 : ?id:string -> ('a, 'b, phrasing, flow) tag
val h5 : ?id:string -> ('a, 'b, phrasing, flow) tag
val h5 : ?id:string -> ('a, 'b, phrasing, flow) tag
val p : ?id:string -> ('a, 'b, phrasing, flow) tag
val close : ((('a, 'b, 'c, 'd) k, 'b, 'c, 'd) element, 'h, 'h, 'b) element

val body : ?id:string -> ('a, 'b, flow, flow) tag
val body_end : (flow body, flow, 'c, 'd) element

type html
val html : head -> flow body -> html

val export : html -> string
