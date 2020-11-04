with ada.text_io, ada.integer_text_io, ada.float_text_io, sequential_io ,Outils, Gestion_Dates, Gestion_Sites, Gestion_Medicament, Gestion_Personnel;
USE Ada.Text_Io, Ada.Integer_Text_Io, Ada.Float_Text_Io,Outils, Gestion_Dates, Gestion_Sites, Gestion_Medicament, Gestion_Personnel;

PROCEDURE Programme_Principale IS


  -- Initialisation des varialbe pour gestion fichier registrePersonnel
  package Fichier_T_registrePersonnel is new sequential_io(T_registrePersonnel);
  use Fichier_T_registrePersonnel;
  fichier_registrePersonnel : Fichier_T_registrePersonnel.file_type;

  -- Initialisation des varialbe pour gestion fichier registreMedicament
  package Fichier_T_registreMedicament is new sequential_io(T_registreMedicament);
  use Fichier_T_registreMedicament;
  fichier_registreMedicament : Fichier_T_registreMedicament.file_type;

  -- Initialisation des varialbe pour gestion fichier registreSite
  package Fichier_T_registreSite is new sequential_io(T_registreSite);
  use Fichier_T_registreSite;
  fichier_registreSite : Fichier_T_registreSite.file_type;



BEGIN

 Put(" ");


End Programme_principale;
