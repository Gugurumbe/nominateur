let premiere_lettre = int_of_char 'a' ;;

type sens =
| Forward (*Les mots sont cohérents, mais ne se terminent pas forcément comme prévu*)
| Backward (*Les mots se terminent comme les modèles, mais ne commencent pas toujours comme eux *)
;;

(*Attention : on ne peut pas créer de mot vide !*)
(* Peut échouer. *)
exception Mauvaise_analyse ;;
let rec creer_mot langage nombre_lettres = function
  | Forward ->
    begin
      let possibilites_vierges () = 
	let t = Array.make (Array.length langage) true in
	t.(-1 + Array.length langage) <- false ; (*On ne veut pas s'arrêter prématurément !*)
	t
      in
      let rec aux antepenultieme penultieme possibilites = function
	| 0 -> ([], true)
	| longueur_restante  ->
	  begin
	    let taille = ref 0 in
	    for i=0 to -1 + Array.length possibilites do
	      if possibilites.(i) then taille := !taille + langage.(antepenultieme).(penultieme).(i) ;
	    done ;
	    if !taille = 0 then ([], false) 
	    else
	      begin
		let roulette = ref (Random.int (!taille)) in
		let i = ref 0 in
		while !roulette >= langage.(antepenultieme).(penultieme).(!i) do
		  if possibilites.(!i) then
		    roulette := !roulette - langage.(antepenultieme).(penultieme).(!i) ;
		  incr i
		done ;
		let (suite, ok) = aux penultieme (!i) (possibilites_vierges ()) (longueur_restante - 1) in
		if ok then ((premiere_lettre + (!i))::suite, true)
		else 
		  begin
		    possibilites.(!i) <- false ;
		    aux antepenultieme penultieme possibilites longueur_restante
		  end
	      end
	  end
      in
      match aux (-1 + Array.length langage) (-1 + Array.length langage) (possibilites_vierges ()) nombre_lettres with
      | (liste, true) -> String.concat "" (List.map (String.make 1) (List.map (char_of_int) liste))
      | (_, false) -> raise Mauvaise_analyse
    end
  | Backward ->
    let inverser_chaine str =
      let s = String.make (String.length str) '0' in
      let n = String.length str in
      for i=0 to n-1 do
	s.[i] <- str.[n-1-i]
      done ;
      s
    in
    let transposer matrice =
      let n = Array.length matrice in
      let p = if n=0 then 0 else Array.length matrice.(0) in
      let q = if n=0 || p=0 then 0 else Array.length matrice.(0).(0) in
      Array.init q (fun k -> Array.init p (fun j -> Array.init n (fun i -> matrice.(i).(j).(k))))
    in
    inverser_chaine (creer_mot (transposer langage) nombre_lettres Forward)
;;
