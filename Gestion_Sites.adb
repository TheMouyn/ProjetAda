with ada.text_io, ada.integer_text_io, ada.float_text_io, Outils, Gestion_Dates, Gestion_Sites, Gestion_Medicament, Gestion_Personnel;
USE Ada.Text_Io, Ada.Integer_Text_Io, Ada.Float_Text_Io, Outils, Gestion_Dates, Gestion_Sites, Gestion_Medicament, Gestion_Personnel;

PACKAGE BODY Gestion_Sites IS


   PROCEDURE Visualisation (T : IN T_registreSite) IS --Procedure pour visualiser le registre des sites

   BEGIN
      FOR I IN T'RANGE LOOP
         IF T(I).Libre = False THEN
            Put(i);put(" ");Put(T(I).Ville);Put(" ");Put(T(I).RetD);Put(" ");Put(T(I).Prod);New_Line; --i est le numero d'index
         END IF;
      END LOOP;
   END Visualisation;



   PROCEDURE Ajout (T : IN OUT T_RegistreSite, Laville IN T_Mot; LeRetD,LaProd IN Boolean, Ok OUT Boolean) IS
      --variable ok pour verifier que l'ajout a bien ete realise
      --procedure ajout d'un nouveau site

   BEGIN
      ok :=false;
         FOR I IN T'RANGE LOOP
         IF T(I).libre = true THEN
            T(I).Ville := Laville;
            T(I).RetD := LeRetD;
            T(I).Prod := LaProd;
            Ok := True;
            exit;
         END IF;
      END LOOP;
   End Ajout;


   PROCEDURE Fermeture (T: IN OUT T_RegistreSite; Ok : OUT Boolean) IS
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
   END Fermeture;


end Gestion_Sites;
