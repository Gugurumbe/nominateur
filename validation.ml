let valider_forward langage =
  let sous_matrice = 
    Array.init 
      (-1 + Array.length langage) 
      (fun i -> 
	Array.init 
	  (-1 + Array.length langage.(i)) 
	  (fun j -> if langage.(i).(j) > 0 then true else false)
      ) 
  in
  let en_commencant_par i =
    let lignes_atteintes = Array.make (Array.length sous_matrice ) false in
    let rec explorer i =
      if lignes_atteintes.(i) then true 
      else
	begin
	  lignes_atteintes.(i) <- true ;
	  let j = ref 0 in
	  let valide = ref false in
	  while !j < Array.length sous_matrice && not (!valide) do
	    valide := sous_matrice.(i).(!j) && (explorer !j) ; (*&& est feignant*)
	    incr j
	  done ;
	  !valide
	end
    in
    explorer i
  in
  let liste_departs = ref [] in
  for i=0 to -1 + Array.length sous_matrice do
    if langage.(Array.length sous_matrice).(i) <> 0 then liste_departs := i::(!liste_departs) ;
  done ;
  List.fold_left (fun acc i -> acc || en_commencant_par i) false !liste_departs
;;

(*Concrètement, on cherche à faire un cycle : on prend une lettre qu'on peut voir arriver dans un mot, et on regarde si elle amène une lettre déjà présente dans le mot, donc qu'on peut poursuivre indéfiniment. *)

(*A priori, le problème se pose dans les 2 sens *)

let valider_backward langage =
  let transposer matrice =
    let n = Array.length matrice in
    let p = if n=0 then 0 else Array.length matrice.(0) in
    Array.init p (fun j -> Array.init n (fun i -> matrice.(i).(j)))
  in
  valider_forward (transposer langage)
;;

let valider langage =
  valider_forward langage && valider_backward langage
;;
