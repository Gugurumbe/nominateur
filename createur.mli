(** Ce fichier a reçu une quête : créer un mot dans un langage spécifique !!!!! **)

(** Attention : on crée un mot en avançant (Forward) ou en reculant (Backward). **)
(** En avançant, on garantit que le mot commencera par une lettre qui débute un **)
(** mot du modèle. En reculant, on garantit que le mot aura une fin semblable   **)
(** au modèle (pratique pour le latin, où les désinences jouent un rôle clé).   **)
(** En contrepartie, un mot créé en avançant ne se terminera pas forcément      **)
(** comme un modèle, et un mot créé en avançant ne commencera pas forcément     **)
(** comme un modèle.                                                            **)

(** Attention : la procédure peut échouer si le texte analysé est trop court !  **)
(** Voici quelques exemples en avançant :                                       **)
(** Exemple : analyser "t". On peut faire un mot de 1 lettre, "t". On ne peut   **)
(** pas faire de mot plus long.                                                 **)
(** Autre exemple : "to". On peut faire 1 lettre : "t", 2 lettres : "to", mais  **)
(** pas plus : o ne peut pas être suivi par quoi que ce soit, selon le modèle.  **)
(** Le module "Validation" permet de savoir si une analyse suffit à fournir au  **)
(** moins un mot pour chaque taille.                                            **)

type sens =
| Forward
| Backward

exception Mauvaise_analyse
val creer_mot : int Matrice.matrice-> int -> sens -> string
(** Résultat de l'analyse^^^^^^^^^^                                             **)
(**                                     taille ^^^                              **)
