with ada.text_io, ada.integer_text_io, ada.float_text_io, Outils, Gestion_Dates, Gestion_Sites, Gestion_Medicament, Gestion_Personnel;
USE Ada.Text_Io, Ada.Integer_Text_Io, Ada.Float_Text_Io, Outils, Gestion_Dates, Gestion_Sites, Gestion_Medicament, Gestion_Personnel;

PACKAGE BODY Gestion_Personnel IS

   PROCEDURE Visualisation (T : IN T_registrePersonnel) IS --Procedure pour visualiser le registre du personnel

   BEGIN
      FOR I IN T'RANGE LOOP
         IF T(I).Libre = False THEN
            Put(T(I).Nom);Put(" ");Put(T(I).Prenom);Put(" ");Put(T(I).Site);Put(" ");Put(T(I).NbProduit);Put(" ");Put(T(I).RetD);Put(" ");Put(T(I).Prod);New_Line;
            --peut etre long sur une seule ligne
         END IF;
      END LOOP;
   END Visualisation;





end Gestion_Personnel;
