let premiere_lettre = int_of_char 'a' ;;
let derniere_lettre = int_of_char 'z' ;;
let nombre_lettres = derniere_lettre - premiere_lettre + 1 ;;

let lettre_correspondante c =
  let code = int_of_char c in
  let premiere_majuscule = int_of_char 'A' in
  let derniere_majuscule = int_of_char 'Z' in
  if code >= premiere_lettre && code <= derniere_lettre then Some(char_of_int code)
  else if code >= premiere_majuscule && code <= derniere_majuscule then Some(char_of_int (code - premiere_majuscule + premiere_lettre))
  else None
;;

let string_of_char_list l =
  let rec aux i = function
    | [] -> 
      ref (String.make i ' ') 
    | c::t ->
      begin
	let s = aux (i+1) t in
	(!s).[i] <- c ;
	s
      end
  in
  !(aux 0 l)
;;

let decomposer_en_mots str =
  let mot_courant = ref [] in
  let mots = ref [] in
  for i=0 to -1 + String.length str do
    match lettre_correspondante str.[i] with
    | None ->
      begin
	match !mot_courant with
	| [] -> ()
	| _ ->
	  begin
	    mots := (string_of_char_list (List.rev !mot_courant))::(!mots) ;
	    mot_courant := []
	  end
      end
    | Some(c) -> 
      begin
	mot_courant := c::(!mot_courant) ;
      end
  done ;
  !mots
;;

let init_list taille fonct =
  let rec aux i =
    if i = taille then []
    else (fonct i)::(aux (i+1))
  in
  aux 0
;;
  
let analyser chaine profondeur =
  let mots = decomposer_en_mots chaine in
  let table_occurences = Matrice.make_cube (nombre_lettres + 1) profondeur 0 in
  let i_of_c c = if c = '|' then nombre_lettres else (int_of_char c) - premiere_lettre in
  let incr coord =
    Matrice.set table_occurences coord (1 + Matrice.get table_occurences coord)
  in
  let rec inscrire_mots = function
    |[] -> ()
    |mot::liste -> 
      begin
	(*Le mot n'est pas vide*) 
	inscrire_mots liste ;
	(*if n <> 0 then begin ... *)
	let mot = (String.make profondeur '|')^mot^(String.make profondeur '|') in
	let n = String.length mot in
	for i=0 to n-profondeur do
	  incr (init_list profondeur (fun j -> i_of_c mot.[i+j]))
	done  
      end
  in
  inscrire_mots mots ;
  table_occurences
;;

