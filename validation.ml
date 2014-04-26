let valider_forward langage =
  if Matrice.profondeur langage >= 2 then
    begin
      let sous_matrice = 
	Matrice.init (List.map (fun d -> d-1) (Matrice.dimensions langage))
	  (fun coord_inverses -> if Matrice.get langage (List.rev coord_inverses) > 0 then true else false)
      in
      let n_lettres = List.hd (Matrice.dimensions sous_matrice) in
      let rec premiers_elements = function
	| [] -> failwith "grr" 
	| [a] -> []
	| a::b -> a::(premiers_elements b)
      in
      let en_commencant_par predecesseurs =
	let lettres_atteintes = Array.make (n_lettres) false in
	let rec explorer coord =
	  match coord with
	  | i::reste ->
	    begin
	      if lettres_atteintes.(i) then true 
	      else
		begin
		  lettres_atteintes.(i) <- true ;
		  let j = ref 0 in
		  let valide = ref false in
		  while !j < n_lettres && not (!valide) do
		    valide := Matrice.get sous_matrice (i::reste@[!j]) && (explorer (reste@[!j])) ; (*&& est feignant*)
		    incr j
		  done ;
		  !valide
		end
	    end
	  | _ -> failwith "Euh..."
	in
	explorer predecesseurs
      in
      let liste_departs = ref [] in
      Matrice.iteri (
	fun coord_inverses v -> 
	  let coord = List.rev coord_inverses in
	  if Matrice.get langage coord <> 0 then liste_departs := (premiers_elements coord)::(!liste_departs) ;
      ) sous_matrice ;
      List.fold_left (fun acc depart -> acc || en_commencant_par depart) false (!liste_departs)
    end
  else true
;;

(*Concrètement, on cherche à faire un cycle : on prend une lettre qu'on peut voir arriver dans un mot, et on regarde si elle amène une lettre déjà présente dans le mot, donc qu'on peut poursuivre indéfiniment. *)

(*A priori, le problème se pose dans les 2 sens *)

(*Transposer : c'est plus délicat. Il faut que nouvelle.(i).(j).(k) = ancienne.(k).(j).(i) *)

let valider_backward langage =
  valider_forward (Matrice.transposer langage)
;;

let valider langage =
  valider_forward langage && valider_backward langage
;;
