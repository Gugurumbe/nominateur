let rep_documents =
  Filename.concat
    begin
      try
	match Sys.os_type with
	| "Unix" -> Sys.getenv "HOME"
	| _ -> Sys.getenv "USERPROFILE"
      with
      | Not_found ->
	begin
	  print_endline "Je ne sais pas où enregistrer mes fichiers sur votre ordinateur. C'est très embêtant. En attendant, je mets tout dans un dossier temporaire." ;
	  Filename.get_temp_dir_name ()
	end
    end
    ".nominateur"
;;
let working_directory () = rep_documents ;;
let rep_langages = (Filename.concat rep_documents "langages") ;;
let liste_langages () =
  try
    Sys.readdir rep_langages
  with
  | _ -> 
    begin
      match Sys.os_type with
      | "Unix" ->
	begin
	  Unix.mkdir rep_documents 0o640 ;
	  Unix.mkdir rep_langages 0o640 ;
	  [||]
	end
      | _ ->
	begin
	  print_endline ("! Je ne sais pas créer un dossier avec votre O.S.. Créez-le vous-même : "^(rep_langages)^" !") ;
	  [||]
	end
    end
;;

let ouvrir_langage_in lang =
  open_in_bin (Filename.concat rep_langages lang)
;;

let ouvrir_langage_out lang =
  open_out_bin (Filename.concat rep_langages lang)
;;

let sauver nom langage =
  let fichier = ouvrir_langage_out nom in
  output_binary_int fichier (Matrice.profondeur langage) ;
  Matrice.iter (output_binary_int fichier) langage ;
  flush fichier ;
  close_out fichier
;;

let charger nom =
  try
    let fichier = ouvrir_langage_in nom in
    let profondeur = input_binary_int fichier in
    let matrice = Matrice.init_cube 27 profondeur (fun _ -> input_binary_int fichier) in
    close_in fichier ;
    matrice
  with
  | _ -> failwith ("! Impossible d'ouvrir ce langage : "^nom^" !")
;;

let supprimer nom =
  let nom_fichier = Filename.concat rep_langages nom in
  Sys.remove nom_fichier
;;
