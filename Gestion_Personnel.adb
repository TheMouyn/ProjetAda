with ada.text_io, ada.integer_text_io, ada.float_text_io, Outils, Gestion_Dates, Gestion_Sites, Gestion_Medicament, Gestion_Personnel;
USE Ada.Text_Io, Ada.Integer_Text_Io, Ada.Float_Text_Io, Outils, Gestion_Dates, Gestion_Sites, Gestion_Medicament, Gestion_Personnel;

PACKAGE BODY Gestion_Personnel IS

   PROCEDURE Visualisation (T : IN T_registrePersonnel) IS --Procedure pour visualiser le registre du personnel

   BEGIN
      FOR I IN T'RANGE LOOP
         IF T(I).Libre = False THEN
            Put(T(I).Nom);Put(" ");Put(T(I).Prenom);Put(" ");Put(T(I).Site);Put(" ");Put(T(I).NbProduit);Put(" ");Put(T(I).RetD);Put(" ");Put(T(I).Prod);New_Line;
            --peut etre long sur une seule ligne
         END IF;
      END LOOP;
   END Visualisation;



   PROCEDURE Ajout (T : IN OUT T_RegistrePersonnel, LeNom,LePrenom IN T_Mot; LeSite,Lenbproduit: IN integer; LeRetD,LaProd IN Boolean, Ok OUT Boolean) IS
      --variable ok pour verifier que l'ajout a bien ete realise
      --procedure ajout d'un nouveau responsable

   BEGIN
      ok :=false;
         FOR I IN T'RANGE LOOP
         IF T(I).libre = true THEN
            T(I).Nom := LeNom;
            T(I).Prenom := LePrenom;
            T(I).Site := LeSite;
            T(i).nbproduit := Lenbproduit;
            T(I).RetD := LeRetD;
            T(I).Prod := LaProd;
            Ok := True;
            exit;
         END IF;
      END LOOP;
   End Ajout;


   PROCEDURE DepartProd (T: IN OUT T_RegistrePersonnel; Ok : OUT Boolean) IS
      --procedure depart d'un chef de produit
      --variable ok pour verifier que l'ajout a bien ete realise

   BEGIN
      Ok := False;
      FOR I IN T'RANGE LOOP
         IF T(I).Libre = False AND T(I).Prod := true THEN
               T(I).Nom :=(OTHERS => ' ');
               T(I).Prenom :=(OTHERS => ' ');
               T(I).Site :=0;
               T(I).nbproduit :=0; --produits transferes a ses collegues a reflechir
               T(I).Libre:= True;
               Ok := True;
               exit;
         END IF;
      END LOOP;
   END DepartProd;


   PROCEDURE DepartRetD (T: IN OUT T_RegistrePersonnel; Ok : OUT Boolean) IS
      --procedure depart d'un responsable de recherche
      --variable ok pour verifier que l'ajout a bien ete realise

   BEGIN
      Ok := False;
      FOR I IN T'RANGE LOOP
         IF T(I).Libre = False AND T(I).RetD := true THEN
               T(I).Nom :=(OTHERS => ' ');
               T(I).Prenom :=(OTHERS => ' ');
               T(I).Site :=0;
               T(I).nbproduit :=0; --produits supprimes
               T(I).Libre:= True;
               Ok := True;
               exit;
         END IF;
      END LOOP;
   END DepartRetD;


end Gestion_Personnel;
