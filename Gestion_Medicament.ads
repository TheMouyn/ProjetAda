with  declaration, Outils, Gestion_Dates, Gestion_Sites, Gestion_Personnel;
USE  declaration, Outils, Gestion_Dates, Gestion_Sites, Gestion_Personnel;


package Gestion_Medicament is





  function nbSiteProductionMedicament(nuMed : in integer; regMedicament : in T_registreMedicament) return integer;
  -- function nbMedicament(regMedicaments : in T_registreMedicament) return integer;
  procedure VisualtisationMedicament(regMedicaments : in T_registreMedicament; regPersonnel : in T_registrePersonnel; regSite : in T_registreSite);
  procedure receptionAMM(regMedicament : in out T_registreMedicament; regPersonnel : in out T_registrePersonnel; regSite : in T_registreSite);
  procedure affichageProduitEnProdSurSite(regMedicament : T_registreMedicament; regPersonnel : in T_registrePersonnel; regSite : in T_registreSite);
  procedure affichageProduitEnRetDSurSite(regMedicament : T_registreMedicament; regPersonnel : in T_registrePersonnel; regSite : in T_registreSite);
  procedure affichageProduitGereParResponable(regMedicament : in T_registreMedicament; regPersonnel : in T_registrePersonnel; regSite : in T_registreSite);
  procedure affichageMedicamentAMMAvantDate(regMedicament : in T_registreMedicament);
  procedure AffichageProduitEnProdSurVille(regMedicament : in T_registreMedicament; regPersonnel : in T_registrePersonnel; regSite : in T_registreSite);
  procedure AffichageProduitEnRetDSurVille(regMedicament : in T_registreMedicament; regPersonnel : in T_registrePersonnel; regSite : in T_registreSite);
  procedure affichageMedicamentCategorie(regMedicament : in T_registreMedicament; regPersonnel : in T_registrePersonnel; regSite : in T_registreSite);
  procedure miseEnProduction(regMedicament : in out T_registreMedicament; regPersonnel : in out T_registrePersonnel; regSite : in T_registreSite);
  procedure arretDeProduction(regMedicament : in out T_registreMedicament; regPersonnel : in out T_registrePersonnel; regSite : in T_registreSite);
  procedure nouveauMedicament(regMedicament : in out T_registreMedicament; regPersonnel : in out T_registrePersonnel; regSite : in T_registreSite);
  procedure supressionMedicament(regMedicament : in out T_registreMedicament; regPersonnel : in out T_registrePersonnel; regSite : in T_registreSite);


end Gestion_Medicament;
