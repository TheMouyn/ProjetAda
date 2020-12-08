WITH  declaration, Outils;
USE  declaration, Outils;



package Gestion_Sites is
   function nbSiteActif(regSite : in T_registreSite) return integer;
   PROCEDURE VisualisationSite (T : IN T_registreSite);
   PROCEDURE AjoutSite (T : IN OUT T_RegistreSite; Ok : OUT Boolean);
   PROCEDURE FermetureSite (regMedicament : IN T_registreMedicament; regPersonnel : IN T_RegistrePersonnel; regSite : IN OUT T_registreSite);

end Gestion_Sites;
