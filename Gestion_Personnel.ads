with  declaration;
USE  declaration;



package Gestion_Personnel is
PROCEDURE VisualisationPersonnel (T : IN T_registrePersonnel; regSite : T_registreSite);
PROCEDURE AjoutPersonnel (T : IN OUT T_RegistrePersonnel; S : IN OUT T_RegistreSite);
PROCEDURE DepartProd (regMedicament : IN OUT T_registreMedicament; regPersonnel : IN OUT T_RegistrePersonnel; regSite : IN OUT T_registreSite);
PROCEDURE DepartRetD (T: IN OUT T_RegistrePersonnel; M : IN OUT T_RegistreMedicament; S : IN OUT T_RegistreSite);


end Gestion_Personnel;
