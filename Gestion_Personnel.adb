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

   PROCEDURE DepartProd (T: IN OUT T_RegistrePersonnel; S : IN OUT T_RegistreSite; M : IN OUT T_RegistreMedicamment) IS
      --procedure depart d'un chef de produit

      ChoixBool : Boolean := False;
      Ok : Boolean :=False; --variable ok pour verifier que la suppression a bien ete realisee
      NomEmp,PrenomEmp : T_Mot   := (OTHERS => ' ');
      ProdEmp: Boolean := False;
      SiteEmp, Min, Numlibre : Integer := - 1;

   BEGIN
      FOR I IN T'RANGE LOOP
    IF T(I).Libre = false THEN
       Numlibre := I;
       Ok := True;
       EXIT;
    END IF;
      END LOOP;

      LOOP --saisie du chef de produit a supprimer
         Put("Quel chef de produit voulez-vous supprimer ?"); New_Line;
         Put_Line("Voulez vous voir le registre des personnels ?");
         SaisieBoolean(ChoixBool);
          IF ChoixBool THEN
             VisualisationPersonnel(T);
             New_Line;
             Put_Line("Saisir le nom et le prenom du chef de produit : ");
          END IF;
         SaisieString(NomEmp);New_Line;
         SaisieString(PrenomEmp);New_Line;
         Put_Line("Le personnel que vous voulez supprimer est un chef de produit ?");
         SaisieBoolean(ProdEmp);New_Line;
         Put_Line("Quel est son numero de site ?");
         SaisieInteger(1, MaxS, SiteEmp);New_line;

      -- verification que le chef existe et qu'il soit en Prod
      FOR I IN T'RANGE LOOP
             IF T(I).Nom = NomEmp AND THEN T(I).Prenom = PrenomEmp AND THEN T(i).Prod = ProdEmp THEN
                Existe := True;
                EXIT;
             END IF;
          END LOOP;

          IF Existe THEN
             Put_Line(
                "Suppression du chef de produit possible");
             ChoixQuitter := DesirQuitter;
             IF ChoixQuitter THEN
                EXIT;
             END IF;
          ELSE
             EXIT;
          END IF;

       -- confirmation
       Put_Line("Etes vous sur de vouloir supprimer ce chef de produit ? :");
       afficherTexte(NomEmp);
       Put(" ");
       afficherTexte(PrenomEmp);
       Put(" Site : ");
       Put(SiteEmp, 1);
       Put(" - ");
       afficherTexte(S(SiteEmp).Ville);
       Put(" ");
       Put("Type d'activite : Production");
       New_Line;

       Put("Confirmer ?");
       New_Line;
       SaisieBoolean(Confirm);
       IF Confirm = True THEN
          T(Numlibre).Nom := (OTHERS => ' ');
          T(Numlibre).Prenom := (OTHERS => ' ');
          T(Numlibre).RetD := false;
          T(Numlibre).Prod := false;
          T(Numlibre).Site := 0;
          T(Numlibre).Libre := True;

          Min := T(T'First); --recherche du chef de produit qui a le moins de produit
          I := T'First +1;
            WHILE I <= T'Last LOOP
               IF T(I) < Min THEN
                  Min := T(I);
               END IF;
            END LOOP;
            IF Min < (MaxProdCh - T(Numlibre).NbProduit)  THEN
            Min := T(Numlibre).NbProduit; --transfert des produits a son collegues qui a le moins de produit
               T(Numlibre).NbProduit := 0; --supression de ses produits
               M(T(Numlibre).Nbproduit).Prod := 0; --suppression des produits dans le registre medicament
            ELSE
               T(Numlibre).NbProduit := 0; --supression de ses produits
               M(T(Numlibre).Nbproduit).Prod := 0; --suppression des produits dans le registre medicament
            END IF;

         EXIT;
       ELSE
          Put("Recommencer la saisie ou quitter");
          ChoixQuitter := DesirQuitter;
       END IF;

       IF ChoixQuitter THEN
          EXIT;
         END IF;

   END DepartProd;

------------------------------------------------------------------------------------------------------------------

PROCEDURE DepartRetD (T: IN OUT T_RegistrePersonnel; M : IN OUT T_RegistreMedicament; S : IN OUT T_RegistreSite) IS
  --procedure depart d'un responsable de recherche
  choixQuitter : boolean := false;
  choixBool : Boolean := False;
  choixEmp : integer;

BEGIN

  loop -- boucle de confirmation
    LOOP --saisie du responsable a supprimer
     Put_Line("Quel est le numero du responsable R&D que vous voulez supprimer ?");
     Put_Line("Voulez vous voir le registre des personnels ?");
     SaisieBoolean(ChoixBool);
      IF ChoixBool THEN
         VisualisationPersonnel(T, S);
         New_Line;
         Put_Line("Quel est le numero du responsable R&D que vous voulez supprimer ?");
      END IF;
      SaisieInteger(1, MaxEmp, choixEmp);

      if T(choixEmp).libre = false then
        if T(choixEmp).RetD then
          exit;
        else
          Put_Line("Ce personnel n'est pas responsable de recherche, veuillez utiliser l'autre option du menu");
          ChoixQuitter := true;
        end if;

      ELSE
        Put_Line("Ce personnel n'est pas dans le registre");
        ChoixQuitter := DesirQuitter;
      end if;


      IF ChoixQuitter THEN
       EXIT;
      END IF;
    end loop; --saisie du responsable a supprimer

    IF ChoixQuitter THEN
     EXIT;
    END IF;

    -- confirmation
    Put_Line("Vous voulez supprimer le personnel :");
    afficherTexte(T(choixEmp).nom); Put(" "); afficherTexte(T(choixEmp).prenom); Put(" Type d'activite : Recherche et developpement"); new_line;
    Put("Site : "); Put(T(choixEmp).site, 1); Put(" - "); afficherTexte(S(T(choixEmp).site).Ville); new_line;

    -- Afficher les medicmants qui vont etre supprimés car ils ne sont qu'en recherche
    if T(choixEmp).nbProduit > 0 then
      put_line("Le(s) medicament(s) suivants vont etre supprimés :");
      for i in M'range loop
        if M(i).libre = false and then M(i).respRecherche = choixEmp and then M(i).AMM = false then
          afficherTexte(M(i).nom); put(" ");
        end if;
      end loop;
      new_line;
    end if;

    New_Line;
    Put_Line("Confirmer ?");
    SaisieBoolean(choixBool);
    IF choixBool THEN
      -- application dans le registre
      for i in M'range loop
        if M(i).libre = false and then M(i).respRecherche = choixEmp then
          if M(i).AMM = false then -- si encore en recherche
            M(i).nom := (others => ' ');
            M(i).EnProd := false;
            M(i).libre := true;

          else -- si il n'est en recherche : en prod ou en attente de prod
            M(i).respRecherche := -1;

          end if;
        end if;
      end loop;

       T(choixEmp).Nom := (OTHERS => ' ');
       T(choixEmp).Prenom := (OTHERS => ' ');
       T(choixEmp).RetD := false;
       T(choixEmp).Prod := false;
       T(choixEmp).Site := 0;
       T(choixEmp).NbProduit := 0;
       T(choixEmp).Libre := True;

       EXIT;
    ELSE
       Put("Recommencer la saisie ou quitter");
       ChoixQuitter := DesirQuitter;
    END IF;

    IF ChoixQuitter THEN
     EXIT;
    END IF;


    end loop; -- boucle de confirmation

  END DepartRetD;


end Gestion_Personnel;
