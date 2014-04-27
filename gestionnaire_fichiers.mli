(** Ce fichier a une tâche presque impossible à réaliser : trouver des chemins  **)
(** vers des fichiers quel que soit le système d'exploitation ! Ça marche avec  **)
(** Debian, garanti. Les autres linux : je sais pas, les windows : je sais pas, **)
(** les mac : j'en ai jamais croisé un. Suggestions bienvenues.                 **)

val working_directory : unit -> string
val liste_langages : unit -> string array
val ouvrir_langage_in : string -> in_channel
val ouvrir_langage_out : string -> out_channel
val sauver : string -> int Matrice.matrice -> unit
val charger : string -> int Matrice.matrice
val supprimer : string -> unit
