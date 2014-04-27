(** Ce fichier est au service de l'État. Il part en mission secrète. Son objectif : substituer des matrices, à dimension fixée mais quelconque ! **)

type 'a matrice =
| Valeur of 'a ref
| Ligne of 'a matrice array

exception Out_of_bounds 
exception Invalid_dimension

val init : int list -> (int list -> 'a) -> 'a matrice
(** !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! PIÈGE ÉNORME !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!**)
(** Les coordonnées sont données DANS L'ORDRE INVERSE !!!!!!!!!!!!!!!!!!!!!!!!!!**)
val make : int list -> 'a -> 'a matrice
val init_cube : int -> int -> (int list -> 'a) -> 'a matrice
(** !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! PIÈGE ÉNORME !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!**)
(** Les coordonnées sont données DANS L'ORDRE INVERSE !!!!!!!!!!!!!!!!!!!!!!!!!!**)
(** En premier, c'est la taille (l'arête du cube), et en second, la dimension de**)
(** l'espace du cube.                                                           **)
val make_cube : int -> int -> 'a -> 'a matrice
val dimensions : 'a matrice -> int list
val profondeur : 'a matrice -> int
val iteri : (int list -> 'a -> unit) -> 'a matrice -> unit
(** !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! PIÈGE ÉNORME !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!**)
(** Les coordonnées sont données DANS L'ORDRE INVERSE !!!!!!!!!!!!!!!!!!!!!!!!!!**)
val iter : ('a -> unit) -> 'a matrice -> unit
val sub : 'a matrice -> int list -> 'a matrice
(** !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!**)
(** !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!**)
(** !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! PIÈGE ÉNORME !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!**)
(** !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!**)
(** !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!**)
(** Les coordonnées sont données DANS LE BON ORDRE !!!!!!!!!!!!!!!!!!!!!!!!!!!!!**)
(** ____________________________________________________________________________**)
val get : 'a matrice -> int list -> 'a
val set : 'a matrice -> int list -> 'a -> unit
(** idem **)
val transposer : 'a matrice -> 'a matrice
(** de sorte que ancienne.(i).(j).(k).(...).(z) = nouvelle.(z).(...).(k).(j).(i)**)

