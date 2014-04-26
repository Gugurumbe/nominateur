let premiere_lettre = int_of_char 'a' ;;

type sens =
| Forward (*Les mots sont cohérents, mais ne se terminent pas forcément comme prévu*)
| Backward (*Les mots se terminent comme les modèles, mais ne commencent pas toujours comme eux *)
;;

let roulette tableau masque =
  let t = Array.copy tableau in
  let n = Array.length t in
  for i=0 to n-1 do
    if not (masque.(i)) then t.(i) <- 0 ;
  done ;
  let somme = Array.fold_left (+) 0 t in
  let roulette = ref (Random.int (somme)) in (*On sélectionne le dernier indice dont la valeur est <= roulette*)
  let i = ref 0 in
  while !i < n && t.(!i) <= !roulette do 
    roulette := !roulette - t.(!i) ;
    incr i 
  done ;
  !i
;; 

let rec make_list taille element =
  match taille with
  | 0 -> []
  | _ -> element::(make_list (taille-1) element)
;;

let get_sub_1 matrice coords =
  match Matrice.sub matrice coords with
  | Matrice.Ligne(ligne) ->
    begin
      Array.map (function
      | Matrice.Valeur(x) -> !x
      | _ -> failwith "Vivien est un abruti")
	ligne
    end
  | _ -> failwith "Qui est un imbécile ?" 
;;

(*Attention : on ne peut pas créer de mot vide !*)
(* Peut échouer. *)
exception Mauvaise_analyse ;;
let rec creer_mot langage nombre_lettres = function
  | Forward ->
    begin
      let avancer liste nouveau =
	match liste with
	| [] -> []
	| h::t -> t@[nouveau]
      in
      let n = 
	match langage with
	| Matrice.Ligne(t) -> Array.length t
	| _ -> 0
      in
      let possibilites_vierges () = 
	let t = Array.make n true in
	t.(n-1) <- false ; (*On ne veut pas s'arrêter prématurément !*)
	t
      in
      let rec aux predecesseurs possibilites = function
	| 0 -> 
	  begin
	    ([], true)
	  end
	| longueur_restante ->
	  begin
	    let taille = ref 0 in
	    for i=0 to -1 + Array.length possibilites do
	      if Matrice.get langage (predecesseurs@[i]) = 0 then possibilites.(i) <- false ;
	      if possibilites.(i) then taille := !taille + Matrice.get langage (predecesseurs@[i]) ;
	    done ;
	    if !taille = 0 then ([], false) 
	    else
	      begin
		let i = roulette (get_sub_1 langage predecesseurs) possibilites in
		let (suite, ok) = aux (avancer predecesseurs i) (possibilites_vierges ()) (longueur_restante - 1) in
		if ok then ((premiere_lettre + i)::suite, true)
		else 
		  begin
		    possibilites.(i) <- false ;
		    aux predecesseurs possibilites longueur_restante
		  end
	      end
	  end
      in
      match aux (make_list (-1 + Matrice.profondeur langage) (n-1)) (possibilites_vierges ()) nombre_lettres with
      | (liste, true) -> String.concat "" (List.map (String.make 1) (List.map (char_of_int) liste))
      | (_, false) -> raise Mauvaise_analyse
    end
  | Backward -> (*Attention : on transpose une GROSSE matrice à chaque nouveau mot*)
    let inverser_chaine str =
      let s = String.make (String.length str) '0' in
      let n = String.length str in
      for i=0 to n-1 do
	s.[i] <- str.[n-1-i]
      done ;
      s
    in
    inverser_chaine (creer_mot (Matrice.transposer langage) nombre_lettres Forward)
;;
