with ada.text_io, ada.integer_text_io, ada.float_text_io, Outils, Gestion_Dates, Gestion_Sites, Gestion_Medicament, Gestion_Personnel;
USE Ada.Text_Io, Ada.Integer_Text_Io, Ada.Float_Text_Io, Outils, Gestion_Dates, Gestion_Sites, Gestion_Medicament, Gestion_Personnel;

PACKAGE BODY Gestion_Personnel IS

   PROCEDURE VisualisationP (T : IN T_registrePersonnel) IS --Procedure pour visualiser le registre du personnel

   BEGIN
      FOR I IN T'RANGE LOOP
         IF T(I).Libre = False THEN
            Put("Nom : ");Put(T(I).Nom);Put(" ");Put(T(I).Prenom);Put(" ");Put(T(I).Site);Put(" ");Put(T(I).NbProduit);Put(" ");Put(T(I).RetD);Put(" ");Put(T(I).Prod);New_Line;
            --peut etre long sur une seule ligne
            --afficher put le ..est prod
         END IF;
      END LOOP;
   END VisualisationP; --changer dans ads



   PROCEDURE Ajout (T : IN OUT T_RegistrePersonnel;S : IN OUT T_RegistreSite; LeNom,LePrenom IN T_Mot; LeSite: IN integer; LeRetD,LaProd IN Boolean, Ok OUT Boolean) IS
      --variable ok pour verifier que l'ajout a bien ete realise
      --procedure ajout d'un nouveau responsable
      Numlibre : Integer := -1;
      Choix : Character;
      confirm : boolean := false;

   BEGIN
      ok :=false;
         FOR I IN T'RANGE LOOP
         IF T(I).Libre = True THEN
            Numlibre := I;
            Ok := True;
            EXIT;
         END IF;
      END LOOP;


      IF Ok = True THEN
         LOOP
            Put("Saisir votre nom : ");new_line;
            SaisieString(T(I).Nom);
            Put("Saisir votre prenom : ");New_Line;
            SaisieString(T(I).Prenom);
            Put("Saisir votre numero de site : ");New_Line;
            VisualisationS(S);
            SaisieInteger(1,nbsiteactif(S),T(I).site));

            put("Etes-vous charge R&D ou Production ? (A- R&D et B- Prod)");new_line;
            LOOP
               put("Quel est votre choix ? =>");get(choix);skip_line;
               CASE Choix IS
                  WHEN A => T(I).RetD := true;T(I).Prod := false;exit;
                  WHEN B =>T(I).RetD := False;T(I).Prod := True;exit;
                  WHEN OTHERS => Put("Le choix n'est pas propose");
               END CASE;
            END LOOP;
         ELSE Ok = False; Put("Le registre est sature");

         END IF;
         Affichagetexte(T(I).Nom);Put(' ');AffichagetextePut(T(I).Prenom);Put(' ');Put(T(I).Site);Put(' ');Affichagetexte(S(T(I).Site).Ville);Put(' ');

         IF T(I).RetD := true THEN
               put("
            ELSE T(I).Prod := true;
            END IF;

         Put("Confirmer ?");new_line;
            SaisieBoolean(confirm);
               IF Confirm = True THEN
               EXIT;
            ELSE
              put("Recommencer la saisie");
               END IF;


               END LOOP;
            END IF;

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
