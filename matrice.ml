type 'a matrice =
| Valeur of 'a ref
| Ligne of 'a matrice array
;;

let init dimensions fonction =
  let rec aux coord_fixees = function
    | [] -> Valeur (ref (fonction coord_fixees))
    | dimension::hyperplan -> Ligne(Array.init dimension (fun i -> aux (i::coord_fixees) hyperplan))
  in
  aux [] dimensions
;;

let make dimensions valeur =
  init dimensions (fun _ -> valeur)
;;

let init_cube dim profondeur fonct =
  let liste = ref [] in
  for i=0 to profondeur-1 do
    liste := dim::(!liste)
  done ;
  init !liste fonct
;;

let make_cube dim prof valeur = init_cube dim prof (fun _ -> valeur) ;;

let rec dimensions = function
  | Ligne(ligne) when Array.length ligne > 0 -> (Array.length ligne)::(dimensions ligne.(0))
  | _ -> []
;;

let rec profondeur = function
  | Ligne(ligne) when Array.length ligne > 0 -> 1 + profondeur ligne.(0)
  | _ -> 0
;;

let iteri fonct =
  let rec aux coord_fixees = function
    | Valeur(x) -> fonct coord_fixees (!x)
    | Ligne(ligne) -> Array.iteri (fun i -> aux (i::coord_fixees)) ligne
  in
  aux [] 
;;

let iter fonct =
  iteri (fun _ v -> fonct v)
;;
(*
let matrice = init [3 ; 2 ; 4] 
  (function
  | [k ; j ; i] -> i * 8 + j * 4 + k
  | _ -> 0)
;;

dimensions matrice ;;*)

exception Out_of_bounds ;;
exception Invalid_dimension ;;

let rec get matrice coordonnees = 
  match (coordonnees, matrice) with
  | ([], Valeur(v)) -> !v
  | (i::suite, Ligne(l)) when i < Array.length l ->
    get l.(i) suite
  | (i::suite, Ligne(l)) -> raise Out_of_bounds
  | _ -> raise Invalid_dimension
;;

let rec sub matrice coordonnees = 
  match (coordonnees, matrice) with
  | ([], _) -> matrice
  | (i::suite, Ligne(l)) when i < Array.length l ->
    sub l.(i) suite
  | (i::suite, Ligne(l)) -> raise Out_of_bounds
  | _ -> raise Invalid_dimension
;;

let get matrice coordonnees =
  match sub matrice coordonnees with
  | Valeur(x) -> !x
  | _ -> raise Invalid_dimension
;;

let rec set matrice coordonnees valeur =
  match (coordonnees, matrice) with
  | ([], Valeur(v)) -> v := valeur
  | (i::suite, Ligne(l)) when i < Array.length l ->
    set l.(i) suite valeur
  | (i::suite, Ligne(l)) -> raise Out_of_bounds
  | _ -> raise Invalid_dimension
;;

let transposer matrice =
  let dimensions = List.rev (dimensions matrice) in
  init dimensions (fun liste -> get matrice liste) 
;;

(*
get matrice [0 ; 1 ; 2] ;;
set matrice [2 ; 1 ; 0] 42 ;;
matrice ;;
transposer matrice ;;
iteri (fun coord_inverses valeur -> print_endline ("["^(String.concat " ; " (List.map (string_of_int) (List.rev coord_inverses)))^"] : "^(string_of_int valeur))) matrice ;;
*)
