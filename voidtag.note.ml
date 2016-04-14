abbr close = mktag (fun c -> Tag_abbr ({}, c)) close
           = close ([], (fun c -> {} , Tag_abbr ({}, c)))
           = fun (c2,h2) k -> k (({}, Tag_abbr ({}, [])) :: c2, h2)

val br : ?id:'a ->
         ?accesskey:char ->
         ?classes:string ->
         ?contenteditable:bool ->
         (general_attributes * phrasing body_tag) list * 'b ->
         ((general_attributes * phrasing body_tag) list * 'b -> 'c) -> 'c

val br : ?id:string ->
         (('a, 'b, 'c, phrasing) k, 'b, 'c, phrasing) element gentag
       : ?id:string ->
         ?accesskey:char ->
         ?classes:string ->
         ?contenteditable:bool ->
         (('a, 'b, 'c, phrasing) k, 'b, 'c, phrasing) element
       : ?id:string ->
         ?accesskey:char ->
         ?classes:string ->
         ?contenteditable:bool ->
         ('b, 'c, phrasing) content ->
         ('a, 'b, 'c, phrasing) k
        : ?id:string ->
          ?accesskey:char ->
          ?classes:string ->
          ?contenteditable:bool ->
          'b body * ('c body -> phrasing full_tag) ->
          ('a, 'b, 'c, phrasing) element ->
          'a
        : ?id:string ->
          ?accesskey:char ->
          ?classes:string ->
          ?contenteditable:bool ->
          'b body * ('c body -> phrasing full_tag) ->
          (('b, 'c, phrasing) content -> 'a) ->
          'a
        : ?id:string ->
          ?accesskey:char ->
          ?classes:string ->
          ?contenteditable:bool ->
          'b body * ('c body -> phrasing full_tag) ->
          ('b body * ('c body -> phrasing full_tag) -> 'a) ->
          'a

========> b = phrasing
