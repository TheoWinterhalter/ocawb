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
type ('a,'b,'c) element
type ('a,'b,'c) k = ('a,'b,'c) element -> 'a
type 'a gentag = ?accesskey: char ->
                 ?classes: string ->
                 ?contenteditable : bool -> 'a

type target =
  | Target_blank
  | Target_parent
  | Target_self
  | Target_top

(*** DEBUG ***)
(* This is a comparison of mli type and actual type. *)
(* They can be matched but with a great overhead... *)
(* It would be nice to find a way to only make public a nice type! *)
(***
val text : string -> phrasing body * 'a -> (phrasing body * 'a -> 'b) -> 'b

val text : string -> (('a,'b,'c) k, 'b,'c) element
         : string -> ('b,'c) content -> ('a,'b,'c) k
         : string -> 'b body * ('c body -> 'c full_tag) -> ('a,'b,'c) element -> 'a
***)

(* Text (normal character data) *)
(* val text : string -> (('a,'b,'c) k, 'b,'c) element

(* All tags (flow and phrasing mixed) *)
val a : ?href: string ->
        ?download: string ->
        ?target: target ->
        (('a,'b,'c) element -> 'a) gentag
val abbr : ?title: string -> (('a,'b,'c) element -> 'a) gentag
val address : ?id:string -> (('a,'b,'c) element -> 'a) gentag
(* area TODO? *)
val article : ?id:string -> (('a,'b,'c) element -> 'a) gentag
val aside : ?id:string -> (('a,'b,'c) element -> 'a) gentag
(* TODO audio tag *)
val b : ?id:string -> (('a,'b,'c) element -> 'a) gentag
val blockquote : ?cite: string -> (('a,'b,'c) element -> 'a) gentag
val p : ?id:string -> (('a,'b,'c) element -> 'a) gentag
val close : ((('a,'b,'c) k,'b,'c) element,'b,'c) element

val body : ?id:string -> (('a,'b,'c) element -> 'a) gentag
val body_end : (flow body,flow,flow) element *)

type html
val html : head -> flow body -> html

val export : html -> string
