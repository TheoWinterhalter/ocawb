val close : a * (a -> b) ->
            b list * c ->
            (b list * c -> d) ->
            d

val close : (((a, b, c, d) k, e, f, g) element, h, i, j) element
          : (h, i, j) content -> ((a, b, c, d) k, e, f, g) element
          : h body * (i body -> j full_tag) ->
            (e, f, g) content ->
            (a, b, c, d) k
          : h body * (i body -> j full_tag) ->
            e body * (f body -> g full_tag) ->
            (a, b, c, d) element ->
            a
          : h body * (i body -> j full_tag) ->
            e body * (f body -> g full_tag) ->
            ((b, c, d) content -> a) ->
            a
          : h body * (i body -> j full_tag) ->
            e body * (f body -> g full_tag) ->
            (b body * (c body -> d full_tag) -> a) ->
            a

a <-> h body
a <-> i body                 ==>   h = i
b <-> j full_tag             ==>   b list <-> j body
b list <-> e body            ==>   e = j
c <-> f body -> g full_tag
b list <-> b body            ==>   b = j
c <-> c body -> d full_tag   ==>   c = f , d = g
d <-> a
d <-> a

====> a b=e=j c=f d=g h=i
=========> (((a, b, c, d) k, b, c, d) element, h, h, b) element
