val close : a * (a -> b) ->
            b list * c ->
            (b list * c -> d) ->
            d

val close : (((a, b, c) k, d, e) element, f, g) element
          : (f, g) content -> ((a, b, c) k, d, e) element
          : f body * (g body -> g full_tag) ->
            (d, e) content ->
            (a, b, c) k
          : f body * (g body -> g full_tag) ->
            d body * (e body -> e full_tag) ->
            (a, b, c) element ->
            a
          : f body * (g body -> g full_tag) ->
            d body * (e body -> e full_tag) ->
            ((b, c) content -> a) ->
            a
          : f body * (g body -> g full_tag) ->
            d body * (e body -> e full_tag) ->
            (b body * (c body -> c full_tag) -> a) ->
            a

a <-> f body
a <-> g body                 ==>   f = g
b <-> g full_tag             ==>   b list <-> g body
b list <-> d body            ==>   g = d
c <-> e body -> e full_tag
b list <-> b body            ==>   g = b
c <-> c body -> c full_tag   ==>   e = c
d <-> a
d <-> a

====> a b=d=f=g c=e
=========> (((a, b, c) k, b, c) element, b, b) element
