example:
	ocamlbuild src/example.native
	./example.native

swing:
	ocamlbuild src/swing.native
	mkdir -p swingdoc # swingdoc is where the swing html is put
	./swing.native

clean:
	ocamlbuild -clean
