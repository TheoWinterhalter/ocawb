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
  | Media_min_width of string (* TODO A type for int + unit *)
  (* TODO *)

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
           head

type body
type 'a element

val p : string -> ('a element -> 'a) element

val body : 'a element -> 'a
val body_end : body element

type html
val html : head -> body -> html

val export : html -> string
