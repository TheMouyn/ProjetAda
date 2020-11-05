with ada.text_io, ada.integer_text_io, ada.float_text_io, Outils, Gestion_Dates, Gestion_Sites, Gestion_Medicament, Gestion_Personnel;
USE Ada.Text_Io, Ada.Integer_Text_Io, Ada.Float_Text_Io, Outils, Gestion_Dates, Gestion_Sites, Gestion_Medicament, Gestion_Personnel;

PACKAGE BODY Gestion_Sites IS


   PROCEDURE Visualisation (T : IN T_registreSite) IS --Procedure pour visualiser le registre des sites

   BEGIN
      FOR I IN T'RANGE LOOP
         IF T(I).Libre = False THEN
            Put(T(I).Ville);Put(" ");Put(T(I).RetD);Put(" ");Put(T(I).Prod);New_Line; --doit-on afficher le numero d'index ?
         END IF;
      END LOOP;
   END Visualisation;



   PROCEDURE Ajout (T : IN OUT T_RegistreSite, Laville IN T_Mot; Lenumero IN Integer; RetD,Prod IN Boolean, Ok OUT Boolean) IS
      --variable ok pour verifier que l'ajout a bien ete realise
      --procedure ajout d'un nouveau site

   BEGIN
      ok :=false
         FOR I IN T'RANGE LOOP
         IF T(I).libre = true THEN
            --T(I).Numero := Lenumero; doit-on ajouter le numero d'index ?
            T(I).Ville := Laville;
            T(I).RetD := True; --pas forcement true ?
            T(I).Prod := True; --pas forcement true ?
            Ok := True;
         END IF;
      END LOOP;
   End Ajout;


PROCEDURE Fermeture (T: IN OUT T_registreSite) IS --procedure fermeture d'un site

   BEGIN
      FOR I IN T'RANGE LOOP
         IF T(I).Libre = False THEN
            T(I).Ville :=(OTHERS => ' ');
            T(I).RetD := false;
            T(I).Prod := false;
            T(I).Libre:= True;
         END IF;
      END LOOP;
   END Fermeture;


end Gestion_Sites;
