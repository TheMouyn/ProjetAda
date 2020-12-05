with ada.text_io, ada.integer_text_io, ada.float_text_io, Outils, Gestion_Dates, Gestion_Sites, Gestion_Medicament, nt_console;
USE Ada.Text_Io, Ada.Integer_Text_Io, Ada.Float_Text_Io, Outils, Gestion_Dates, Gestion_Sites, Gestion_Medicament, nt_console;

pragma elaborate_body -- permet de forcer la compilation du body, je pense que l'on pourra le retirer quandon aura des procedure

PACKAGE BODY Gestion_Personnel IS

   PROCEDURE VisualisationPersonnel (T : IN T_registrePersonnel; regSite : T_registreSite) IS --Procedure pour visualiser le registre du personnel

   BEGIN
      put("NU EMPLOYE - NOM - PRENOM - NUMERO SITE - VILLE - NB PRODUIT - ACTIVITE"); new_line;
      FOR I IN T'RANGE LOOP
         IF T(I).Libre = False THEN
            put(i, 1); put(" - "); afficherTexte(T(I).Nom); Put(" "); afficherTexte(T(I).Prenom);Put(" - "); Put(T(I).Site, 1); put(" - ");
            afficherTexte(regSite(T(I).Site).ville); put(" - "); Put(T(I).NbProduit, 1); put(" - ");
            IF T(I).RetD = True THEN
               Put("R&D uniquement"); New_line;
            ELSE
              Put ("Production uniquement"); New_line;
            END IF;

         END IF;
      END LOOP;
   END VisualisationPersonnel;

---------------------------------------------------------------------------------------------------------------

PROCEDURE AjoutPersonnel (T : IN OUT T_RegistrePersonnel; S : IN OUT T_RegistreSite) IS
   --variable ok pour verifier que l'ajout a bien ete realise
   --procedure ajout d'un nouveau responsable
   -- variables temporaires pour confirmation
   NomEmp,
   PrenomEmp : T_Mot   := (OTHERS => ' ');
   SiteEmp   : Integer := - 1;
   RetDEmp,
   ProdEmp   : Boolean := False;

   Numlibre     : Integer   := - 1;
   Choix        : Character;
   Confirm      : Boolean   := False;
   ChoixQuitter,
   ExisteDeja   : Boolean   := False;
   ChoixBool    : Boolean   := False;
   Ok : boolean :=False;

BEGIN
 FOR I IN T'RANGE LOOP
    IF T(I).Libre = True THEN
       Numlibre := I;
       Ok := True;
       EXIT;
    END IF;
 END LOOP;


 IF Ok = True AND NbSiteActif(S) > 0 THEN
    --on verifie que la case est libre et qu'il existe un site avant de faire la saisie
    LOOP -- saisie de confirmation
       LOOP -- saisie de nom
          Put("Saisir votre nom : ");
          New_Line;
          SaisieString(NomEmp);
          Put("Saisir votre prenom : ");
          New_Line;
          SaisieString(PrenomEmp);
          New_Line;

          -- verification homonymie
          FOR I IN T'RANGE LOOP
             IF T(I).Nom = NomEmp AND THEN T(I).Prenom = PrenomEmp THEN
                ExisteDeja := True;
                EXIT;
             END IF;
          END LOOP;

          IF ExisteDeja THEN
             Put_Line(
                "Ajout impossible car un personnel de ce nom existe deja");
             ChoixQuitter := DesirQuitter;
             IF ChoixQuitter THEN
                EXIT;
             END IF;
          ELSE
             EXIT;
          END IF;

       END LOOP;

       IF ChoixQuitter THEN
          EXIT;
       END IF;

       -- saisie du type fonction

       Put("Etes-vous charge R&D ou Production ? (A- R&D et B- Prod)");
       New_Line;
       LOOP
          Put("Quel est votre choix ? => ");
          Get(Choix);
          Skip_Line;
          CASE Choix IS
             WHEN 'A' =>
                RetDEmp := True;
                ProdEmp := False;
                EXIT;
             WHEN 'B' =>
                RetDEmp := False;
                ProdEmp := True;
                EXIT;
             WHEN OTHERS =>
                Put("Le choix n'est pas propose");
                New_Line;
          END CASE;
       END LOOP;

       LOOP  -- saisie du numero de site
          Put("Saisir votre numero de site : ");
          New_Line;
          Put_Line("Voulez-vous voir le registre des sites ? ");
          SaisieBoolean(ChoixBool);
          IF ChoixBool THEN
             VisualisationSite(S);
             New_Line;
             Put_Line("Saisir votre numero de site : ");
          END IF;
          SaisieInteger(1, MaxS, SiteEmp);

          IF S(SiteEmp).Libre = False THEN
             IF (RetDEmp AND S(SiteEmp).RetD) OR (ProdEmp AND S(SiteEmp).Prod) THEN -- TODO: a verifier
                EXIT;
             ELSE
                Put_Line("Le site selectionne n'est pas coherant avec votre domaine");
                ChoixQuitter := DesirQuitter;
                Clear_Screen(Black);
             END IF;

          ELSE
             Put_Line("Ce site n'est pas un site du registre");
             ChoixQuitter := DesirQuitter;
          END IF;

          IF ChoixQuitter THEN
             EXIT;
          END IF;

       END LOOP;

       IF ChoixQuitter THEN
          EXIT;
       END IF;

       -- confirmation
       Put_Line("Vous voulez ajouter un personnel :");
       afficherTexte(NomEmp);
       Put(" ");
       afficherTexte(PrenomEmp);
       Put(" Site : ");
       Put(SiteEmp, 1);
       Put(" - ");
       afficherTexte(S(SiteEmp).Ville);
       Put(" ");

       IF RetDEmp = True THEN
          Put("Type d'activite : Recherche et developpement");
       ELSE
          Put ("Type d'activite : Production");
       END IF;
       New_Line;

       Put("Confirmer ?");
       New_Line;
       SaisieBoolean(Confirm);
       IF Confirm = True THEN
          T(Numlibre).Nom := NomEmp;
          T(Numlibre).Prenom := PrenomEmp;
          T(Numlibre).RetD := RetDEmp;
          T(Numlibre).Prod := ProdEmp;
          T(Numlibre).Site := SiteEmp;
          T(Numlibre).NbProduit := 0;
          T(Numlibre).Libre := False;

          EXIT;
       ELSE
          Put("Recommencer la saisie ou quitter");
          ChoixQuitter := DesirQuitter;
       END IF;

       IF ChoixQuitter THEN
          EXIT;
       END IF;



    END LOOP;
 ELSE
    Put("Le registre est sature");
 END IF;

END AjoutPersonnel;
-----------------------------------------------------------------------------------------------------------------

   PROCEDURE DepartProd (T: IN OUT T_RegistrePersonnel; Ok : OUT Boolean) IS
      --procedure depart d'un chef de produit
      --variable ok pour verifier que l'ajout a bien ete realise

   BEGIN
      Ok := False;
      Put("Quel chef de produit voulez-vous supprimer ?"); put("Appuyer sur entrer pour visualiser tous les personnels");
      VisualisationPersonnel(T);
      Put("Saisir le nom du chef de produit :");
      SaisieString(T(I).Nom);

      FOR I IN T'RANGE LOOP -- If T(i).nom in T'range then
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

------------------------------------------------------------------------------------------------------------------

   PROCEDURE DepartRetD (T: IN OUT T_RegistrePersonnel; M : IN OUT T_RegistreMedicamment) IS
      --procedure depart d'un responsable de recherche
      --variable ok pour verifier que l'ajout a bien ete realise
      ChoixBool    : Boolean   := False;
      Ok : Boolean :=False;
      NomEmp,PrenomEmp : T_Mot   := (OTHERS => ' ');
      RetDEmp: Boolean := False;

   BEGIN
      Ok := False;
      LOOP --saisie du responsable a supprimer
         Put("Quel responsable voulez-vous supprimer ?"); New_Line;
         Put_Line("Voulez vous voir le registre des personnels ?");
         SaisieBoolean(ChoixBool);
          IF ChoixBool THEN
             VisualisationPersonnel(T);
             New_Line;
             Put_Line("Saisir le nom et le prenom du responsable : ");
          END IF;
         SaisieString(NomEmp);New_Line;
         SaisieString(PrenomEmp);New_Line;
         Put_Line("Le personnel que vous voulez supprimer est un responsable de recherche ?");
         SaisieBoolean(RetDEmp);


      -- verification que le responsable existe et qu'il soit en RetD
          FOR I IN T'RANGE LOOP
             IF T(I).Nom = NomEmp AND THEN T(I).Prenom = PrenomEmp AND THEN T(i).RetD = RetDEmp THEN
                Existe := True;
                EXIT;
             END IF;
          END LOOP;

          IF Existe THEN
             Put_Line(
                "Suppression du responsable de recherche possible");
             ChoixQuitter := DesirQuitter;
             IF ChoixQuitter THEN
                EXIT;
             END IF;
          ELSE
             EXIT;
          END IF;




-- confirmation
       Put_Line("Vous voulez ajouter un personnel :");
       afficherTexte(NomEmp);
       Put(" ");
       afficherTexte(PrenomEmp);
       Put(" Site : ");
       Put(SiteEmp, 1);
       Put(" - ");
       afficherTexte(S(SiteEmp).Ville);
       Put(" ");

       IF RetDEmp = True THEN
          Put("Type d'activite : Recherche et developpement");
       ELSE
          Put ("Type d'activite : Production");
       END IF;
       New_Line;

       Put("Confirmer ?");
       New_Line;
       SaisieBoolean(Confirm);
       IF Confirm = True THEN
          T(Numlibre).Nom := NomEmp;
          T(Numlibre).Prenom := PrenomEmp;
          T(Numlibre).RetD := RetDEmp;
          T(Numlibre).Prod := ProdEmp;
          T(Numlibre).Site := SiteEmp;
          T(Numlibre).NbProduit := 0;
          T(Numlibre).Libre := False;

          EXIT;
       ELSE
          Put("Recommencer la saisie ou quitter");
          ChoixQuitter := DesirQuitter;
       END IF;

       IF ChoixQuitter THEN
          EXIT;
         END IF;









      -- verification que le responsable fasse parti de RetD
      FOR I IN T'RANGE LOOP
         IF T(I).Libre = False AND T(I).RetD := true THEN
               T(I).Nom :=(OTHERS => ' ');
               T(I).Prenom :=(OTHERS => ' ');
               T(I).Site :=0;
               T(I).nbproduit :=0 and M(T(i).nbproduit).RetD := 0; --produits supprimes
               T(I).Libre:= True;
               Ok := True;
               exit;
         END IF;
      END LOOP;
   END DepartRetD;


end Gestion_Personnel;
