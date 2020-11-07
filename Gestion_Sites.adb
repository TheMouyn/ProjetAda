with ada.text_io, ada.integer_text_io, ada.float_text_io, Outils, Gestion_Dates, Gestion_Medicament, Gestion_Personnel, nt_console;
USE Ada.Text_Io, Ada.Integer_Text_Io, Ada.Float_Text_Io, Outils, Gestion_Dates, Gestion_Medicament, Gestion_Personnel, nt_console;

pragma elaborate_body -- permet de forcer la compilation du body, je pense que l'on pourra le retirer quandon aura des procedure

PACKAGE BODY Gestion_Sites IS


   PROCEDURE VisualisationSite (T : IN T_registreSite) IS --Procedure pour visualiser le registre des sites

   BEGIN
      FOR I IN T'RANGE LOOP
         IF T(I).Libre = False THEN
            put_line("NUMERO DE SITE - VILLE - ACTIVITE(S)");
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

   PROCEDURE AjoutSite (T : IN OUT T_RegistreSite, Ok OUT Boolean) IS
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

         IF Ok = True THEN
         LOOP
            Put("Saisir votre ville : ");new_line;
            SaisieString(T(Numlibre).Ville);


            put("Quelle est l'activitee abritee ? (A- R&D / B- Prod / C- Les deux)");new_line;
            LOOP
               put("Quel est votre choix ? =>"); get(choix); skip_line; new_line;
               CASE Choix IS
                  WHEN 'A' => T(Numlibre).RetD := true; T(Numlibre).Prod := false; exit;
                  WHEN 'B' => T(Numlibre).RetD := False; T(Numlibre).Prod := True; exit;
                  when 'C' => T(Numlibre).RetD := True; T(Numlibre).Prod := True; exit;
                  WHEN OTHERS => Put("Le choix n'est pas propose");
               END CASE;
            END LOOP;
         ELSE
          Put("Le registre est sature");
         END IF;
         new_line;

         put("Numero site : "); put(Numlibre, 1); put(" - ")
         Affichagetexte(T(Numlibre).Ville);Put(" - ");
         IF T(I).RetD = True and T(i).prod = true THEN
            Put("R&D et Production");New_Line;
          elsif T(I).RetD = true and T(I).prod = false then
            put("R&D Uniquement"); new_line;
          elsif T(I).RetD = false and T(I).prod = true then
            put("Production Uniquement"); new_line;
         END IF;

         Put("Confirmer ?");New_Line;
            SaisieBoolean(confirm);
               IF Confirm = True THEN
               EXIT;
            ELSE
              put("Recommencer la saisie");
         END IF;


      END LOOP;
   End AjoutSite;

--------------------------------------------------------------------------------------------------------------

   PROCEDURE FermetureSite (T: IN OUT T_RegistreSite; Ok : OUT Boolean) IS
      --procedure fermeture d'un site boolean ok
      --variable ok pour verifier que l'ajout a bien ete realise

   BEGIN
      Ok := False;
      IF T(I).RetD := False AND T(I).Prod := False THEN --fermeture s'il n'y a plus de M en prod ou en RetD
      FOR I IN T'RANGE LOOP
         IF T(I).Libre = False THEN
            T(I).Ville :=(OTHERS => ' ');
            T(I).Libre:= True;
            Ok := True;
            exit;
         END IF;
      END LOOP;
      END IF;
   END FermetureSite;


end Gestion_Sites;
