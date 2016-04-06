(* In order to see where to go, this file is a concept example.               *)
(* For this example, we exhibit low level html production from ocaml.         *)
(* The idea is that an inhabitant of html is actually valid in html5 (would   *)
(* be nice right?)                                                            *)

let mkhead title : head =
  head
    ~title: ("Ocawb official website -- " ^ title)
    ~meta: < some meta list? >

(* For this one, I'm not sure how to do it in a nice way, maybe just an
 * inductive type. *)
let homepage_body : body =
  body (...)

let homepage : page =
  html
    ~head: (mkhead "Homepage")
    ~body: homepage_body
