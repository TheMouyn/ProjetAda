with ada.text_io, ada.integer_text_io, ada.float_text_io, Outils, Gestion_Dates, Gestion_Medicament, Gestion_Personnel, nt_console;
USE Ada.Text_Io, Ada.Integer_Text_Io, Ada.Float_Text_Io, Outils, Gestion_Dates, Gestion_Medicament, Gestion_Personnel, nt_console;

pragma elaborate_body -- permet de forcer la compilation du body, je pense que l'on pourra le retirer quandon aura des procedure

PACKAGE BODY Gestion_Sites IS


   PROCEDURE VisualisationSite (T : IN T_registreSite) IS --Procedure pour visualiser le registre des sites

   BEGIN
      FOR I IN T'RANGE LOOP
         IF T(I).Libre = False THEN
            Put("Numero du site : ");Put(I);Put(" ");Put("Ville : ");Put(T(I).Ville);Put(" "); --i est le numero d'index
            IF T(I).RetD = True THEN
               Put("Activitee abritee : Recherche et developpement");New_Line;
            ELSE T(I).Prod = True; Put("Activitee Abritee : Production");New_Line;
            END IF;
         END IF;
      END LOOP;
   END VisualisationSite;

-----------------------------------------------------------------------------------------------------------------------------

   PROCEDURE AjoutSite (T : IN OUT T_RegistreSite, Laville IN T_Mot; LeRetD,LaProd IN Boolean, Ok OUT Boolean) IS
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
            SaisieString(T(I).Ville);


            put("Quelle est l'activitee abritee ? (A- R&D et B- Prod)");new_line;
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

         Affichagetexte(T(I).Ville);Put(' ');
         IF T(I).RetD := true THEN
               put("Activitee abritee : Recherche et developpement");
            ELSE T(I).Prod := true;Put ("Activitee abritee : Production");
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
