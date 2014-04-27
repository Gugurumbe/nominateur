SRC = matrice.ml gestionnaire_fichiers.ml analyseur.ml createur.ml validation.ml main.ml
INTERFACES = matrice.mli gestionnaire_fichiers.mli analyseur.mli createur.mli validation.mli
EXEC = nominateur

TO_LINK = unix.cma $(SRC:.ml=.cmo)
TO_COMPILE = $(INTERFACES:.mli=.cmi) $(SRC:.ml=.cmo)

ifdef SystemRoot
	EXEC = nominateur.exe
	REMOVE = del
	DOC_PATH = "$(USERPROFILE)\.nominateur\langages\"
	MAKE_DOC = if not exist $(DOC_PATH) mkdir $(DOC_PATH)
	EXEC_PATH = "$(ProgramFiles)\nominateur"
	MAKE_EXEC_P = if not exist $(EXEC_PATH) mkdir $(EXEC_PATH)
	COPY_EXEC = copy /v /y $(EXEC) /b $(EXEC_PATH)
else 
	EXEC = nominateur
	REMOVE = rm -rf
	DOC_PATH = $(HOME)/.nominateur/langages
	MAKE_DOC = mkdir -p $(DOC_PATH)
	EXEC_PATH = /usr/bin
	MAKE_EXEC_P =
	COPY_EXEC = cp nominateur $(EXEC_PATH)
endif

.PHONY : program install clean

program : $(TO_COMPILE)
	ocamlc $(TO_LINK) -o $(EXEC)

preinstall : 
	$(MAKE_DOC)

install : program preinstall
	$(MAKE_EXEC_P)
	$(COPY_EXEC)

%.cmi : %.mli
	ocamlc -c $^ -o $@

%.cmo : %.ml
	ocamlc -c $^ -o $@

clean :
	$(REMOVE) $(TO_COMPILE) $(EXEC)