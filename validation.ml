let valider_forward langage =
  let sous_matrice = 
    Array.init 
      (-1 + Array.length langage) 
      (fun i -> 
	Array.init 
	  (-1 + Array.length langage.(i)) 
	  (fun j -> 
	    Array.init 
	      (-1 + Array.length langage.(i).(j))
	      (fun k -> if langage.(i).(j).(k) > 0 then true else false)
	  )
      ) 
  in
  let en_commencant_par (i, j) =
    let lettres_atteintes = Array.make (Array.length sous_matrice ) false in
    let rec explorer i j =
      if lettres_atteintes.(i) then true 
      else
	begin
	  lettres_atteintes.(i) <- true ;
	  let k = ref 0 in
	  let valide = ref false in
	  while !k < Array.length sous_matrice && not (!valide) do
	    valide := sous_matrice.(i).(j).(!k) && (explorer j !k) ; (*&& est feignant*)
	    incr k
	  done ;
	  !valide
	end
    in
    explorer i j
  in
  let liste_departs = ref [] in
  for i=0 to -1 + Array.length sous_matrice do
    for j=0 to -1 + Array.length sous_matrice do
      if langage.(Array.length sous_matrice).(i).(j) <> 0 then 
	begin
	  liste_departs := (i, j)::(!liste_departs) ;
	end ;
    done ;
  done ;
  let valider_une_lettre =
    let j = ref 0 in
    while !j < Array.length sous_matrice && langage.(Array.length sous_matrice).(!j).(Array.length sous_matrice) = 0 do incr j done ;
    !j < Array.length sous_matrice
  in
  valider_une_lettre && 
  List.fold_left (fun acc depart -> acc || en_commencant_par depart) false (!liste_departs)
;;

(*Concrètement, on cherche à faire un cycle : on prend une lettre qu'on peut voir arriver dans un mot, et on regarde si elle amène une lettre déjà présente dans le mot, donc qu'on peut poursuivre indéfiniment. *)

(*A priori, le problème se pose dans les 2 sens *)

(*Transposer : c'est plus délicat. Il faut que nouvelle.(i).(j).(k) = ancienne.(k).(j).(i) *)

let valider_backward langage =
  let transposer matrice =
    let n = Array.length matrice in
    let p = if n=0 then 0 else Array.length matrice.(0) in
    let q = if n=0 || p=0 then 0 else Array.length matrice.(0).(0) in
    Array.init q (fun k -> Array.init p (fun j -> Array.init n (fun i -> matrice.(i).(j).(k))))
  in
  valider_forward (transposer langage)
;;

let valider langage =
  valider_forward langage && valider_backward langage
;;
