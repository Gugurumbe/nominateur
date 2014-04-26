#Description :
Grâce à ce petit outil, on peut imiter n'importe quelle langue : français, anglais, orc, ... 
#Restriction importante :
On doit se limiter à l'alphabet latin à 26 lettres. Les majuscules (non accentuées) sont traitées comme les minuscules associées.
#Description du fonctionnement :
À partir d'un texte (plus il est long, mieux c'est), le programme crée une sorte de matrice à plusieurs dimensions (plus il y en a, plus le mot ressemble au modèle, mais plus le texte analysé doit être long). À 3 dimensions, matrice.('a').('b').('c') contient le nombre de fois où on a vu la lettre c succéder au mot "ab", en gros. À partir de là, de deux choses l'unes :
* ou bien on peut faire un cycle suffisemment lisse (i.e. tous les enchaînements sont présents dans le modèle), dans ce cas l'analyse est validée.
* ou bien on ne peut pas faire de cycle, dans ce cas l'analyse peut être forcée, mais pour des mots trop longs il y a un risque d'erreur . 
Par exemple, si on analyse
    to
avec une profondeur de 2, alors on ne peut pas faire de mot de 3 lettres : comme début de mot, il semble qu'on ne puisse avoir que 't'. Après 't', on ne peut avoir qu'un 'o'. Et après 'o', eh bien...
Tout va mieux si on analyse
     tot
avec une profondeur de 2 : on peut répéter "to" autant de fois que l'on veut, et finir par un t si on souhaite un mot de longueur impaire. 
     tototototototototot est autorisé
Mais ça se gâte à nouveau en utilisant une profondeur de 3 : après 'rien' 'rien', on ne peut avoir qu'un 't'. Après 'rien' 't', on ne peut avoir qu'un 'o'. Après 't' 'o', un nouveau 't'. Mais après 'o' 't', tous les mots (!) que l'analyseur a rencontrés se terminent, donc on ne peut pas avoir de mots de longueur 4.

#Note sur la diversité :
Les mots formés sont moins diversifiés que la profondeur est grande. On obtient des résultats satisfaisants (pour le français) avec une profondeur de 4, un peu plus originaux avec une profondeur de 3.

#Note sur le sens de formation :
Les mots peuvent être construits de gauche à droite (forward), de droite à gauche (backward) ou simultanément dans les deux sens (forward + backward). À chaque interruption, on risque une discontinuité. Par exemple, en français, on voit souvent des consonnes doubles 'pp'. Un mot qui commence par 'Ppotina', par exemple, ne sonne pas très français. C'est l'inconvénient de la méthode "backward". En revanche, si vous analysez un texte en latin, les désinences fréquentes ("us", etc) sont préservées, contrairement à la méthode "forward". Celle-ci permet de commencer comme les mots du modèle, mais le résultat peut sembler un peu abrupt : 'Ombatr'. La méthode "forward + backward" permet d'avoir un commencement et une fin propres, mais des consonnes peuvent s'accumuler au milieu. Il y a de quoi s'énerver avec 'Apptte', par exemple. Interdire les groupes de plus d'un certain nombre de consonnes n'est pas la solution, surtout si vous visez --du polonais-- n'importe quelle langue utilisant plusieurs consonnes à la suite.

# Note sur les capacités usuelles :
Pour analyser un texte : avec une profondeur de 4, on peut analyser la page Wikipedia de Rousseau dans une seconde.
Pour générer des mots : avec une profondeur de 4, on peut faire ~50 mots de longueur 100 dans deux secondes (la première étant consommée par la préparation du "backward".
