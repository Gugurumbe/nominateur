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
	    mots := (string_of_char_list !mot_courant)::(!mots) ;
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

let make_cube n v =
  Array.init n (fun _ -> Array.make_matrix n n v)
;;
  
let analyser chaine =
  let mots = decomposer_en_mots chaine in
  let i_of_c c = (int_of_char c) - premiere_lettre in
  let table_occurences = make_cube (nombre_lettres + 1) 0 in
  let incr i j k =
    table_occurences.(i).(j).(k) <- table_occurences.(i).(j).(k) + 1
  in
  let rec inscrire_mots = function
    |[] -> ()
    |mot::liste -> 
      begin
	(*Le mot n'est pas vide*)
	let n = String.length mot in
	inscrire_mots liste ;
	(*if n <> 0 then begin ... *)
	for i=0 to n-3 do
	  incr (i_of_c mot.[i]) (i_of_c mot.[i+1]) (i_of_c mot.[i+2])
	done ;
	incr (-1 + Array.length table_occurences) (-1 + Array.length table_occurences) (i_of_c mot.[0]) ;
	incr (i_of_c mot.[n-1]) (-1 + Array.length table_occurences) (-1 + Array.length table_occurences) ; 
	if n <= 1 then
	  begin
	    incr (-1 + Array.length table_occurences) (i_of_c mot.[0]) (-1 + Array.length table_occurences) 
	  end
	else
	  begin
	    incr (-1 + Array.length table_occurences) (i_of_c mot.[0]) (i_of_c mot.[1]) ;
	    incr (i_of_c mot.[n-2]) (i_of_c mot.[n-1]) (-1 + Array.length table_occurences) ;
	  end 
      end
  in
  inscrire_mots mots ;
  table_occurences
;;

