example:
	ocamlbuild src/example.native

swing:
	ocamlbuild src/swing.native
	mkdir -p swingdoc # swingdoc is where the swing html is put

clean:
	ocamlbuild -clean
