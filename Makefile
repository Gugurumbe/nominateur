SRC = matrice.ml gestionnaire_fichiers.ml analyseur.ml createur.ml validation.ml main.ml          #sources to compile
INTERFACES = matrice.mli gestionnaire_fichiers.mli analyseur.mli createur.mli validation.mli      #OCaml interfaces, to compile

TO_LINK_OPT = unix.cmxa $(SRC:.ml=.cmx)                                                           #Everything the linker (if it's opt) needs to link
TO_COMPILE_OPT = $(INTERFACES:.mli=.cmi) $(SRC:.ml=.cmx)					  #The compiler is expected to make these
TO_LINK_C = $($(TO_LINK_OPT:.cmxa=.cma):.cmx=.cmo)
TO_COMPILE_C = $(TO_COMPILE_OPT:.cmx=.cmo)

ifdef SystemRoot                                                                                  #SystemRoot is defined on (most ?) Windows
	EXEC = nominateur.exe                                                                     	
	REMOVE = del                                                                                    #Let us laugh at this amazing syntax
	DOC_PATH = "$(USERPROFILE)\.nominateur\langages\ "                                              
	MAKE_DOC = if not exist $(DOC_PATH) mkdir $(DOC_PATH)
	EXEC_PATH = "$(ProgramFiles)\nominateur"
	MAKE_EXEC_P = if not exist $(EXEC_PATH) mkdir $(EXEC_PATH)
	COPY_EXEC = copy /v /y $(EXEC) /b $(EXEC_PATH)
else 												  #On civilized computers, nothing more is needed.
	EXEC = nominateur
	REMOVE = rm -rf
	DOC_PATH = $(HOME)/.nominateur/langages
	MAKE_DOC = mkdir -p $(DOC_PATH)
	EXEC_PATH = /usr/bin
	MAKE_EXEC_P =
	COPY_EXEC = cp nominateur $(EXEC_PATH)
endif

.PHONY : information program_c program_opt install_c install_opt clean

information :
	echo "You have to chose between ocamlc or ocamlopt. For ocamlc, use 'make program_c' then 'make install_c' or only 'make install_c'. For ocamlopt, the same with 'opt' instead of 'c'. If you don't know what to chose, try ocamlopt then ocamlc. "

program_c : $(TO_COMPILE_C)
	ocamlc $(TO_LINK_C) -o $(EXEC)

program_opt : $(TO_COMPILE_OPT)
	ocamlopt $(TO_LINK_OPT) -o $(EXEC)

preinstall : 
	$(MAKE_DOC)

install : program preinstall
	$(MAKE_EXEC_P)
	$(COPY_EXEC)

%.cmi : %.mli
	ocamlc -c $^ -o $@

%.cmo : %.ml
	ocamlc -c $^ -o $@

%.cmx : %.ml
	ocamlopt -c $^ -o $@

clean :
	$(REMOVE) *.cmi *.cmo *.cmx $(TO_COMPILE) $(EXEC)