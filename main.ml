Random.self_init () ;;

type usage =
| Analyser
| Lister
| Menage
| Generer
| Inconnu
| PasLister
;;

let rec input_all_text fichier =
  try
    let ligne = input_line fichier in
    ligne^(input_all_text fichier)
  with
  | End_of_file -> ""
;;

let rec charger_lignes fichier =
  try
    let ligne = input_line fichier in
    ligne::(charger_lignes fichier)
  with
  | End_of_file -> []
;;

let output_endline flux str =
  output_string flux str ;
  output_string flux "\n" ;
  flush flux
;;

let faire_analyser (langage : string) (fichier_texte : string) (forcer : bool) : unit =
  try
    let fichier = open_in fichier_texte in
    let contenu = input_all_text fichier in
    let matrice = Analyseur.analyser contenu in
    close_in fichier ;
    let valide = Validation.valider matrice in
    if valide || forcer then
      begin
	let fichier = open_out_bin langage in
	Array.iter (Array.iter (output_binary_int fichier)) matrice ;
	close_out fichier ;
	let noms_fichiers = 
	  try
	    let fichier = open_in "liste" in
	    let l = List.map (String.trim) (charger_lignes fichier) in
	    close_in fichier ;
	    l
	  with
	  |Sys_error("liste: No such file or directory") -> []
	in
	let fichier = open_out "liste" in
	List.iter (output_endline fichier) (langage::noms_fichiers) ;
	close_out fichier ;
	if not(valide) then print_endline "Attention : l'analyse du texte n'est pas suffisante pour garantir des mots de toutes tailles." ;
      end 
    else
      print_endline "! Le langage n'est pas validé !"
  with
  | Sys_error(s) when s = fichier_texte^": No such file or directory" -> 
    print_endline 
      ("! Erreur : le fichier \""^(fichier_texte)^"\" n'est pas accessible !")
;;

let faire_generer langage nombre majuscule backward taille variation =
  let afficher mot =
    if majuscule && String.length mot <> 0 then
      mot.[0] <- char_of_int ((int_of_char mot.[0]) - (int_of_char 'a') + (int_of_char 'A')) ;
    print_endline mot
  in
  try
    let fichier = open_in langage in
    let matrice = Array.init 27 (fun _ -> Array.init 27 (fun _ -> input_binary_int fichier)) in
    close_in fichier ;
    for i=0 to nombre - 1 do
      afficher (Createur.creer_mot matrice (int_of_float ((float_of_int taille) *. (1. +. (variation *. (-.1. +. 2.*.(Random.float 1.)))))) (if backward then Createur.Backward else Createur.Forward)) ;
		done ;
  with
  | Sys_error(s) when s = langage^": No such file or directory" -> 
    print_endline ("! Erreur : le fichier \""^(langage)^"\" n'est pas accessible !")
;;

let faire_lister () =
  let noms_fichiers = 
    try
      let fichier = open_in "liste" in
      let l = List.map (String.trim) (charger_lignes fichier) in
      close_in fichier ;
      l
    with
    |Sys_error("liste: No such file or directory") -> []
  in
  List.iter (print_endline) noms_fichiers
;;

let faire_menage liste =
  let noms_fichiers = 
    try
      let fichier = open_in "liste" in
      let l = List.map (String.trim) (charger_lignes fichier) in
      close_in fichier ;
      l
    with
    |Sys_error("liste: No such file or directory") -> []
  in
  let rec contient e = function
    | [] -> false
    | x::_ when e = x -> true
    | _::t -> contient e t
  in
  let rec eliminer = function
    |[] -> []
    |fichier::reste when contient fichier liste ->
      eliminer reste
    |fichier::reste -> fichier::(eliminer reste)
  in
  let resultat = eliminer noms_fichiers in
  let fichier = open_out_bin "liste" in
  List.iter (output_endline fichier) resultat ;
  close_out fichier
;;

let main () =
  let analyser = ref false in
  let lister_langues = ref false in
  let supprimer_langue = ref false in
  let nombre_mots = ref 1 in
  let fichier = ref "" in
  let fichier_a_analyser = ref "" in
  let majuscule = ref false in
  let backward = ref false in
  let taille = ref 10 in
  let variation = ref 0.3 in
  let forcer = ref false in
  let usage_souhaite = ref Inconnu in
  let erreur = ref false in
  let liste_anonymes = ref [] in
  let set_analyser () =
    analyser := true ;
    match !usage_souhaite with
    | Inconnu | PasLister -> usage_souhaite := Analyser 
    | Analyser -> ()
    | _ when not (!erreur) ->
      begin
	print_endline "! Erreur : vous ne pouvez pas utiliser '-a' ici !" ;
	erreur := true
      end
    | _ -> ()
  in
  let set_lister () =
    lister_langues := true ;
    match !usage_souhaite with
    | Inconnu -> usage_souhaite := Lister 
    | Lister -> ()
    | _ when not (!erreur) ->
      begin
	print_endline "! Erreur : vous ne pouvez pas utiliser '-l' ici !" ;
	erreur := true
      end
    | _ -> ()
  in
  let set_supprimer () =
    supprimer_langue := true ;
    match !usage_souhaite with
    | Inconnu | PasLister -> usage_souhaite := Menage 
    | Menage -> ()
    | _ when not (!erreur) ->
      begin
	print_endline "! Erreur : vous ne pouvez pas utiliser '-d' ici !" ;
	erreur := true
      end
    | _ -> ()
  in
  let set_nmots n = 
    nombre_mots := n ;
    match !usage_souhaite with
    | Inconnu | PasLister -> usage_souhaite := Generer
    | Generer -> ()
    | _ when not (!erreur) -> 
      begin
	print_endline "! Erreur : vous ne pouvez pas utiliser '-n' ici !" ;
	erreur := true
      end
    | _ -> ()
  in
  let set_langage nom =
    fichier := nom ;
    match !usage_souhaite with
    | Inconnu -> usage_souhaite := PasLister
    | PasLister when not (!erreur) -> 
      begin
	print_endline "! Erreur : vous ne pouvez pas utiliser '-i' ici !" ;
	erreur := true
      end
    | _ -> ()
  in
  let set_source src = 
    fichier_a_analyser := src ;
    match !usage_souhaite with
    | Inconnu | PasLister -> usage_souhaite := Analyser
    | Analyser -> ()
    | _ when not (!erreur) -> 
      begin
	print_endline "! Erreur : vous ne pouvez pas utiliser '-s' ici !" ;
	erreur := true
      end
    | _ -> ()
  in
  let set_majuscule () =
    majuscule := true ;
    match !usage_souhaite with
    | Inconnu | PasLister -> usage_souhaite := Generer 
    | Generer -> ()
    | _ when not (!erreur) ->
      begin
	print_endline "! Erreur : vous ne pouvez pas utiliser '-c' ici !" ;
	erreur := true
      end
    | _ -> ()
  in
  let set_backward () =
    backward := true ;
    match !usage_souhaite with
    | Inconnu | PasLister -> usage_souhaite := Generer 
    | Generer -> ()
    | _ when not (!erreur) ->
      begin
	print_endline "! Erreur : vous ne pouvez pas utiliser '-b' ici !" ;
	erreur := true
      end
    | _ -> ()
  in
  let set_taille t = 
    taille := t ;
    match !usage_souhaite with
    | Inconnu | PasLister -> usage_souhaite := Generer
    | Generer -> ()
    | _ when not (!erreur) -> 
      begin
	print_endline "! Erreur : vous ne pouvez pas utiliser '-t' ici !" ;
	erreur := true
      end
    | _ -> ()
  in
  let set_variation v = 
    variation := v ;
    match !usage_souhaite with
    | Inconnu | PasLister -> usage_souhaite := Generer
    | Generer -> ()
    | _ when not (!erreur) -> 
      begin
	print_endline "! Erreur : vous ne pouvez pas utiliser '-v' ici !" ;
	erreur := true
      end
    | _ -> ()
  in
  let set_forcer () =
    forcer := true ;
    match !usage_souhaite with
    | Inconnu | PasLister -> usage_souhaite := Analyser 
    | Analyser -> ()
    | _ when not (!erreur) ->
      begin
	print_endline "! Erreur : vous ne pouvez pas utiliser '-f' ici !" ;
	erreur := true
      end
    | _ -> ()
  in
  let ajouter_anonyme mot =
    liste_anonymes := mot::(!liste_anonymes) 
  in
  let speclist = 
    [("-a", 
      Arg.Unit (set_analyser), 
      " si vous voulez analyser un texte dans une nouvelle langue.") ;
     ("-l", 
      Arg.Unit (set_lister),
      " si vous voulez lister les langages disponibles.") ;
     ("-d", 
      Arg.Unit (set_supprimer),
      " si vous voulez supprimer un langage.") ;
     ("-n",
      Arg.Int (set_nmots),
      " si vous voulez générer plusieurs mots.") ;
     ("-i",
      Arg.String (set_langage),
      " pour définir le nom du langage.") ;
     ("-s",
      Arg.String (set_source),
      " pour définir le nom du fichier contenant le texte à analyser.") ;
     ("-c",
      Arg.Unit (set_majuscule),
      " si vous voulez une majuscule devant tous les noms à générer.") ;
     ("-b",
      Arg.Unit (set_backward),
      " si vous voulez générer un mot en commençant par la désinence.") ;
     ("-t", 
      Arg.Int (set_taille),
      " si vous voulez que les mots aient une taille différente de 10.") ;
     ("-v",
      Arg.Float (set_variation),
      " pour changer la variation de taille des mots. Par défaut : 30%.") ;
     ("-f",
      Arg.Unit (set_forcer),
      " si vous voulez ajouter ce langage même si l'analyse est insuffisante.")
    ] in
  let message_utilisation = "En manque d'inspiration ? Créez des mots aléatoires. Il suffit d'analyser un texte dans votre langue favorite (alphabet latin), et si cette analyse est validée, vous pourrez générer des mots qui y ressemblent !" in
  Arg.parse speclist (ajouter_anonyme) message_utilisation ;
  liste_anonymes := List.rev (!liste_anonymes) ;
  let pas_anonymes = match !liste_anonymes with
    | [] -> true
    | _  -> false
  in
  if !erreur then print_endline "Impossible de comprendre ce que vous voulez."
  else
    match !usage_souhaite with
    | Inconnu when pas_anonymes-> print_endline "! Je n'ai pas assez d'information pour comprendre ce que vous voulez !"
    | PasLister -> print_endline "! '-i' ne me suffit pas pour comprendre. Essayez '-help'."
    | Analyser when pas_anonymes && !fichier <> "" && !fichier_a_analyser <> "" ->
      begin
	faire_analyser !fichier !fichier_a_analyser !forcer
      end
    | Analyser when pas_anonymes &&  !fichier = "" -> print_endline "! Si vous voulez analyser un langage, encore faut-il préciser lequel (via -i <nom>) !"
    | Analyser (*when !fichier_a_analyser = ""*) -> print_endline "! Et comment je fais pour deviner quel texte vous voulez analyser ? Faites plutôt -s <chemin> !"
    | Generer when pas_anonymes &&  !fichier <> "" ->
      begin
	faire_generer !fichier !nombre_mots !majuscule !backward !taille !variation
      end
    | Generer when pas_anonymes -> print_endline "! Dans quelle langue voulez-vous générer des mots ? -i <langage> !"
    | Lister when pas_anonymes ->
      begin
	faire_lister () ;
      end
    | Menage when !fichier <> "" ->
      begin
	faire_menage ((!fichier)::(!liste_anonymes)) ;
      end
    | Menage -> print_endline "! Et si vous me disiez quels langages je dois supprimer ? !"
    | _ -> 
      begin
	print_endline "! Je ne sais pas quoi faire de ces arguments : " ;
	List.iter (print_endline) !liste_anonymes ;
	print_endline "!"
      end
;;

let _ = main () ;;
