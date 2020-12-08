with ada.text_io, ada.integer_text_io, Outils, Gestion_Dates, Gestion_Medicament, Gestion_Personnel, nt_console;
USE Ada.Text_Io, Ada.Integer_Text_Io, Outils, Gestion_Dates, Gestion_Medicament, Gestion_Personnel, nt_console;

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

PROCEDURE FermetureSite (regMedicament : IN T_registreMedicament; regPersonnel : IN T_RegistrePersonnel; regSite : IN OUT T_registreSite) IS
   --procedure fermeture d'un site
   ChoixBool    : Boolean := False;
   ChoixSite    : Integer;
   ChoixQuitter : Boolean := False;
   estUtilise : boolean := false;


BEGIN
   LOOP -- boucle de confirmation
      LOOP --saisie du site a supprimer
         Put("Quel est le numero du site que vous voulez supprimer ?");
         New_Line;
         Put_Line("Voulez vous voir le registre des sites ?");
         SaisieBoolean(ChoixBool);
         IF ChoixBool THEN
            VisualisationSite(regSite);
            New_Line;
            Put_Line("Quel est le numero du site que vous voulez supprimer ?");
         END IF;
         SaisieInteger(1, MaxS, ChoixSite);
         New_Line;

         IF RegSite(ChoixSite).Libre = false THEN
            EXIT;

         ELSE
            Put_Line("Ce site n'est pas dans le registre");
            ChoixQuitter := DesirQuitter;
         END IF;

         IF ChoixQuitter THEN
            EXIT;
         END IF;

      END LOOP; -- boucle de saisie site

      IF ChoixQuitter THEN
         EXIT;
      END IF;

      -- verification si il y a des medicaments en recherche sur ce site
      if regSite(ChoixSite).RetD then
        for i in regMedicament'RANGE loop
          if regMedicament(i).libre = false and then regPersonnel(regMedicament(i).respRecherche).site = ChoixSite and then regMedicament(i).AMM = false then
            put_line("Supression impossible il y a encore de(s) médicament(s) en recherche sur ce site");
            estUtilise := true;
            exit;
          end if;
        end loop;
      end if;

      -- verification si il y a des medicaments en production sur ce site
      if regSite(ChoixSite).prod then
        for i in regMedicament'range loop
          if regMedicament(i).libre = false and then regMedicament(i).EnProd then
            for j in regMedicament(i).chefProd'range loop
              if regMedicament(i).chefProd(j).libre = false and then regPersonnel(regMedicament(i).chefProd(j).nuEmpolye).site = ChoixSite then
                put_line("Supression impossible il y a encore de(s) medicament(s) en productions sur ce site");
                estUtilise := true;
                exit;
              end if;
            end loop;
          end if;
          if estUtilise then
            exit;
          end if;
        end loop;
      end if;

      -- verification si il y a du personnel en fonction sur ce site
      for i in regPersonnel'range loop
        if regPersonnel(i).libre = false and then regPersonnel(i).site = ChoixSite then
          put_line("Supression impossible il y a encore de(s) personnel(s) en fonction sur ce site");
          estUtilise := true;
          exit;
        end if;
      end loop;

      if estUtilise then
        exit;

      else
        -- confirmation
        put_line("Vous voulez supprimer le site nuemro ");
        put(ChoixSite, 1);
        put(" - ");
        afficherTexte(regSite(ChoixSite).ville);
        new_line;

        put_line("Vous confirmez ?");
        SaisieBoolean(ChoixBool);
        if ChoixBool then
          regSite(ChoixSite).ville := (others=>' ');
          regSite(ChoixSite).RetD := false;
          regSite(ChoixSite).prod := false;
          regSite(ChoixSite).libre := true;
          ChoixQuitter:= true;
        else
          put_line("Suppression annulee");
          ChoixQuitter := desirQuitter;
        end if;
      end if;

      IF ChoixQuitter THEN
         EXIT;
      END IF;


   END LOOP; --boucle de confirmation
END FermetureSite;


end Gestion_Sites;
