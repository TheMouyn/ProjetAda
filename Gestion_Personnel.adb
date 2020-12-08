with ada.text_io, ada.integer_text_io, declaration, Outils, Gestion_Sites, nt_console;
USE Ada.Text_Io, Ada.Integer_Text_Io, Outils, Gestion_Sites, nt_console;


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

PROCEDURE DepartProd (regMedicament : IN OUT T_registreMedicament; regPersonnel : IN OUT T_RegistrePersonnel; regSite : IN OUT T_registreSite) IS
   --procedure depart d'un chef de produit
   choixBool : Boolean := False;
   choixEmp : integer;
   choixQuitter : boolean;
   medicamentAArreter : boolean := false; -- est vrai il y a des medicament en prod a stopper

BEGIN
  loop -- boucle de confirmation
   LOOP --saisie du chef de produit a supprimer
      Put_Line("Quel est le numero du chef de produit que vous voulez supprimer ?");
      Put_Line("Voulez vous voir le registre des personnels ?");
      SaisieBoolean(choixBool);
      IF ChoixBool THEN
         VisualisationPersonnel(regPersonnel, regSite);
         New_Line;
         Put_Line("Quel est le numero du chef de produit que vous voulez supprimer ?");
      END IF;
      saisieInteger(1, MaxEmp, choixEmp);

      if regPersonnel(choixEmp).libre = false then
        if regPersonnel(choixEmp).prod then
          exit;
        else
          put_line("Ce personnel n'est pas chef de production, veuillez utiliser l'autre option du menu");
          choixQuitter := true;
          skip_line;
        end if;

      else
        put_line("Ce personnel n'est pas dans le registre");
        choixQuitter := desirQuitter;
      end if;

      IF ChoixQuitter THEN
         EXIT;
      END IF;

    end loop; -- boucle saisie chef de prod

  IF ChoixQuitter THEN
     EXIT;
  END IF;

  -- confirmation
  Put_Line("Vous voulez supprimer le personnel :");
  afficherTexte(regPersonnel(choixEmp).nom); Put(" "); afficherTexte(regPersonnel(choixEmp).prenom); Put(" Type d'activite : chef de production"); new_line;
  Put("Site : "); Put(regPersonnel(choixEmp).site, 1); Put(" - "); afficherTexte(regSite(regPersonnel(choixEmp).site).Ville); new_line;

  -- Afficher les medicmants dont la production va etre transfere aux collegues si possible

  -- permet de verifier si il y a au moins un medicmaent a stopper la production
  for i in regMedicament'range loop
    if regMedicament(i).libre = false and then regMedicament(i).EnProd then
      for j in regMedicament(i).chefProd'range loop
        if regMedicament(i).chefProd(j).libre = false and then regMedicament(i).chefProd(j).nuEmpolye = choixEmp then
          medicamentAArreter := true;
          exit;
        end if;
      end loop;
    end if;
    if medicamentAArreter then
      exit;
    end if;
  end loop;

  --Afiche la liste des medicaments qui vont etre transfere ou stopper uniquement si il y en a
  if medicamentAArreter then
    put_line("La production de(s) medicament(s) suivant(s) sera transfere ou arreter :");
    for i in regMedicament'range loop
      if regMedicament(i).libre = false and then regMedicament(i).EnProd then
        for j in regMedicament(i).chefProd'range loop
          if regMedicament(i).chefProd(j).libre = false and then regMedicament(i).chefProd(j).nuEmpolye = choixEmp then
            put(i, 1);
            put(" - ");
            afficherTexte(regMedicament(i).nom);
            new_line;
          end if;
        end loop;
      end if;
    end loop;
  end if;

  new_line; new_line;
  Put_Line("Vous confirmez ?");
  SaisieBoolean(choixBool);
  if choixBool then
    if medicamentAArreter then -- si il y a des med a stopper
      --transfere ou stop
      -- changer le numero d'emp dans le tableau prod du med
      -- faire +1 au nb produit charge dans la limite de MaxProdCh

      for i in regMedicament'range loop
        if regMedicament(i).libre = false and then regMedicament(i).EnProd then
          for j in regMedicament(i).chefProd'range loop
            if regMedicament(i).chefProd(j).libre = false and then regMedicament(i).chefProd(j).nuEmpolye = choixEmp then
              for k in regPersonnel'range loop
                if regPersonnel(k).libre = false and then regPersonnel(k).site = regPersonnel(choixEmp).site and then regPersonnel(k).prod and then k /= choixEmp and then regPersonnel(k).nbProduit < MaxProdCh then
                  regMedicament(i).chefProd(j).nuEmpolye := k;
                  regPersonnel(k).nbProduit := regPersonnel(k).nbProduit +1;
                  regPersonnel(choixEmp).nbProduit := regPersonnel(choixEmp).nbProduit -1;
                  exit;
                end if;
              end loop;
              exit; -- 1 seule chaine de prod pour ce med i sur ce site
            end if;
          end loop;
        end if;
      end loop;
      -- les tranferes on ete fait.

      --arret des chaines de prod si il reste des medicmants a la charge de choixEmp

      if regPersonnel(choixEmp).nbProduit > 0 then
        for i in regMedicament'range loop
          if regMedicament(i).libre = false and then regMedicament(i).EnProd then
            for j in regMedicament(i).chefProd'range loop
              if regMedicament(i).chefProd(j).libre = false and then regMedicament(i).chefProd(j).nuEmpolye = choixEmp then
                regMedicament(i).chefProd(j).nuEmpolye := 0;
                regMedicament(i).chefProd(j).libre := true;

                --verifie si il y a encore des chaines de prod acitve -> bool enprod a mettre en false
                for z in regMedicament(i).chefProd'range loop
                  if regMedicament(i).chefProd(z).libre = false then
                    regMedicament(i).EnProd := true;
                    exit;
                  else
                    regMedicament(i).EnProd := false;
                  end if;

                end loop;
                exit;
              end if;
            end loop;
          end if;
        end loop;
      end if;

    end if;

  regPersonnel(choixEmp).Nom := (OTHERS => ' ');
  regPersonnel(choixEmp).Prenom := (OTHERS => ' ');
  regPersonnel(choixEmp).RetD := False;
  regPersonnel(choixEmp).Prod := False;
  regPersonnel(choixEmp).nbProduit := 0;
  regPersonnel(choixEmp).Libre := True;
  choixQuitter := true;
  exit;

  else
    put_line("Suppression annulee, recommencer la saisie ou quitter la procedure");
    choixQuitter := desirQuitter;

  end if;

  IF ChoixQuitter THEN
     EXIT;
  END IF;


  end loop; -- boucle de confirmation


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
