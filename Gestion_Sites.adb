with ada.text_io, ada.integer_text_io, ada.float_text_io, Outils, Gestion_Dates, Gestion_Medicament, Gestion_Personnel, nt_console;
USE Ada.Text_Io, Ada.Integer_Text_Io, Ada.Float_Text_Io, Outils, Gestion_Dates, Gestion_Medicament, Gestion_Personnel, nt_console;

pragma elaborate_body; -- permet de forcer la compilation du body, je pense que l'on pourra le retirer quandon aura des procedure

PACKAGE BODY Gestion_Sites IS


  function nbSiteActif(regSite : in T_registreSite) return integer is
    nombre : integer :=0;

  begin -- nbSiteActif
    for i in regSite'range loop
      if regSite(i).libre = false then
        nombre := nombre+1;
      end if;
    end loop;
    return(nombre);
  end nbSiteActif;


   PROCEDURE VisualisationSite (T : IN T_registreSite) IS --Procedure pour visualiser le registre des sites

   BEGIN
     put_line("NUMERO DE SITE - VILLE - ACTIVITE(S)");
      FOR I IN T'RANGE LOOP
         IF T(I).Libre = False THEN
            Put(I, 1); Put(" - "); afficherTexte(T(I).Ville);Put(" - ");

            IF T(I).RetD = True and T(i).prod = true THEN
               Put("R&D et Production");New_Line;
             elsif T(I).RetD = true and T(I).prod = false then
               put("R&D Uniquement"); new_line;
             elsif T(I).RetD = false and T(I).prod = true then
               put("Production Uniquement"); new_line;
            END IF;
         END IF;
      END LOOP;
   END VisualisationSite;

-----------------------------------------------------------------------------------------------------------------------------

PROCEDURE AjoutSite (T : IN OUT T_RegistreSite; Ok : OUT Boolean) IS
   --variable ok pour verifier que l'ajout a bien ete realise
   --procedure ajout d'un nouveau site

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

    loop
      IF Ok = True THEN
         Put("Saisir votre ville : ");new_line;
         SaisieString(T(Numlibre).Ville);


         put("Quelle est l'activitee abritee ? (A- R&D / B- Prod / C- Les deux)");new_line;
         LOOP
            put("Quel est votre choix ? =>"); get(choix); skip_line; new_line;
            CASE Choix IS
               WHEN 'A' => T(Numlibre).RetD := true; T(Numlibre).Prod := false; exit;
               WHEN 'B' => T(Numlibre).RetD := False; T(Numlibre).Prod := True; exit;
               when 'C' => T(Numlibre).RetD := True; T(Numlibre).Prod := True; exit;
               WHEN OTHERS => Put("Le choix n'est pas propose"); new_line;
            END CASE;
         END LOOP;
      ELSE
       Put("Le registre est sature");
      END IF;
      new_line;

      put("Numero site : "); put(Numlibre, 1); put(" - ");
      afficherTexte(T(Numlibre).Ville);Put(" - ");
      IF T(Numlibre).RetD = True and T(Numlibre).prod = true THEN
         Put("R&D et Production");New_Line;
       elsif T(Numlibre).RetD = true and T(Numlibre).prod = false then
         put("R&D Uniquement"); new_line;
       elsif T(Numlibre).RetD = false and T(Numlibre).prod = true then
         put("Production Uniquement"); new_line;
      END IF;

      Put("Confirmer ?");New_Line;
      SaisieBoolean(confirm);
      IF Confirm = True THEN
          T(Numlibre).libre := false;
        EXIT;
      ELSE
         put("Recommencer la saisie"); new_line;
      END IF;

  end loop;
End AjoutSite;

--------------------------------------------------------------------------------------------------------------

   PROCEDURE FermetureSite (T: IN OUT T_RegistreSite; M : IN T_registreMedicament; P: IN OUT T_RegistrePersonnel;) IS
      --procedure fermeture d'un site

      ChoixBool : Boolean := False;
      Ok : Boolean := False;  --variable ok pour verifier que la suppression a bien ete realisee
      NomVille : T_Mot   := (OTHERS => ' ');
      ProdSite: Boolean := False;
      Numlibre: Integer := - 1;
      SiteEmp : Integer := - 1;

   BEGIN
       FOR I IN T'RANGE LOOP
    IF T(I).Libre = false THEN
       Numlibre := I;
       Ok := True;
       EXIT;
    END IF;
      END LOOP;

      LOOP --saisie du site a supprimer
         Put("Quel site voulez-vous supprimer ?"); New_Line;
         Put_Line("Voulez vous voir le registre des sites ?");
         SaisieBoolean(ChoixBool);
          IF ChoixBool THEN
             VisualisationSite(T);
             New_Line;
             Put_Line("Saisir la ville : ");
          END IF;
         SaisieString(NomVille);New_Line;
         Put_Line("Le site que vous voulez supprimer est un site de production ?");
         SaisieBoolean(ProdSite);New_Line;
         Put_Line("Quel est son numero de site ?");
         SaisieInteger(1, MaxS, SiteEmp);New_Line;

         -- verification que le site existe
          FOR I IN T'RANGE LOOP
             IF T(I).Ville = NomVille THEN
                Existe := True;
                EXIT;
             END IF;
          END LOOP;

          IF Existe THEN
             Put_Line(
                "Suppression du site possible");
             ChoixQuitter := DesirQuitter;
             IF ChoixQuitter THEN
                EXIT;
             END IF;
          ELSE
             EXIT;
          END IF;

       -- confirmation
       Put_Line("Etes vous sur de vouloir supprimer ce site ? :");
       afficherTexte(NomVille);
       Put(" Site : ");
       Put(SiteEmp, 1);
       Put(" - ");
         IF SaisieBoolean THEN
            Put ("Type d'activite : Production");
         ELSE
            Put ("Type d'activite : Recherche et developpement");
         END IF;
       Put("Type d'activite : Recherche et developpement");
       New_Line;

       Put("Confirmer ?");
       New_Line;
       SaisieBoolean(Confirm);
         IF Confirm = True THEN
            M(P(T(I).Site).Prod).EnProd = False; --fermeture s'il n'y a plus de M en prod et plus de personnel sur un site
            M(P(T(I).Site).RetD).AMM = False;  --fermeture s'il n'y a plus de M en RetD et plus de personnel sur un site
            T(Numlibre).Ville := (OTHERS => ' ');
            T(Numlibre).RetD := false;
            T(Numlibre).Prod := false;
            T(Numlibre).Site := 0;

          EXIT;
       ELSE
          Put("Recommencer la saisie ou quitter");
          ChoixQuitter := DesirQuitter;
       END IF;

       IF ChoixQuitter THEN
          EXIT;
         END IF;

    END FermetureSite;

end Gestion_Sites;
