SRC = matrice.ml analyseur.ml createur.ml validation.ml main.ml
INTERFACES = matrice.mli analyseur.mli createur.mli validation.mli

EXEC = nominateur

TO_LINK = $(SRC:.ml=.cmo)
TO_COMPILE = $(INTERFACES:.mli=.cmi) $(TO_LINK)

.PHONY : all clean

all : $(TO_COMPILE)
	ocamlc $(TO_LINK) -o $(EXEC)

%.cmi : %.mli
	ocamlc -c $^ -o $@

%.cmo : %.ml
	ocamlc -c $^ -o $@

clean :
	rm -rf $(TO_COMPILE) $(EXEC)