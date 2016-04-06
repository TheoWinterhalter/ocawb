(* With this file we experiment with continuations to encapsulate html *)

type shadow_element = Elt

let body : type a. (shadow_element list -> a) -> a =
  fun elt -> elt []

let element l k = k (Elt :: l)

let endb l = l

(* mybody = [Elt ; Elt ; Elt] *)
(* This is great magic right? And we can hide all the types in the mli so it
 * becomes even more magical. *)
let mybody =
  body
    element
    element
    element
  endb
