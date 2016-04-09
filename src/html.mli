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

type body
type 'a element
type 'a k = 'a element -> 'a

type target =
  | Target_blank
  | Target_parent
  | Target_self
  | Target_top

val a : ?href: string ->
        ?download: string ->
        ?target: target ->
        'a element -> 'a
(* TODO Allow to be in text (and nothing else right?) *)
val abbr : ?title: string -> string -> 'a k element
val address : 'a element -> 'a
(* area TODO? *)
val article : 'a element -> 'a
(* TODO Accept more than text *)
val p : string -> 'a k element
val close : 'a k element element

val body : 'a element -> 'a
val body_end : body element

type html
val html : head -> body -> html

val export : html -> string
