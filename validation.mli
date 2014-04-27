(** Ce fichier va changer la face du monde : il permet de dire si l'analyse d'un **)
(** texte suffit à produire au moins un mot de chaque longueur, dans un sens     **)
(** comme dans l'autre ! Concrètement, on regarde si on peut faire un cycle qui  **)
(** se répète.                                                                   **)

val valider : int Matrice.matrice -> bool
