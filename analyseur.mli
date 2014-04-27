(** Incroyable ! Ce fichier poursuit un but dissimulé : obtenir une matrice **)
(**      de succession (d'ordre 1) à partir de l'analyse d'un texte !       **)

val analyser : string -> int -> int Matrice.matrice
(** Analyse le texte pour en déduire les éléments ayant le droit de se      **)
(** succéder. La dernière ligne et la dernière colonne correspondent aux    **)
(** éléments qui commencent et qui terminent un mot. Il y a exactement 26   **)
(**lettres, les lettres latines.                                            **)
