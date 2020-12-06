with Outils, Gestion_Dates, Gestion_Sites, Gestion_Personnel;
USE Outils, Gestion_Dates, Gestion_Sites, Gestion_Personnel;


package Gestion_Medicament is


  maxMed : constant integer :=14; -- nombre maximal de médicament


  type T_categorie is (antimigraineux, anticancereux, antifongiques, antihistaminiques, anticoagulants, vitamines);
  type T_typePatient is (ttPublic, adulte, pediatrique);

  type T_chefProd is record
    nuEmpolye : integer; -- numero employe du registre registrePersonnel du chef
    libre : boolean:=true; -- permet la gestion des cases libres/pleines
  end record;

  type T_tabChefProd is array (1..MaxEmp) of T_chefProd;


  type T_medicament is record
    nom : T_mot := (others => ' '); -- nom du medicament
    categorie : T_categorie; -- categorie du medicament
    typePatient : T_typePatient; -- forme du medicament
    AMM : boolean; -- si le medicament a recu ou non une AMM
    dateAMM : T_date; -- l'eventuelle date d'AMM du medicament
    EnProd : boolean; -- si le medicament est en production
    respRecherche : integer; -- numero index registrePersonnel du responsable, si -1 alors le personnel est supprime
    chefProd : T_tabChefProd; -- stock la liste des numero d'employer chef de prod
    libre : boolean:= true; -- permet la gestion des cases libres/pleines

  end record;

  type T_registreMedicament is array (1..maxMed) of T_medicament;



  function nbSiteProductionMedicament(nuMed : in integer; regMedicament : in T_registreMedicament) return integer;
  function nbMedicament(regMedicaments : in T_registreMedicament) return integer;
  procedure VisualtisationMedicament(regMedicaments : in T_registreMedicament; regPersonnel : in T_registrePersonnel; regSite : in T_registreSite);
  procedure receptionAMM(regMedicament : T_registreMedicament; regPersonnel : in T_registrePersonnel; regSite : in T_registreSite);
  procedure affichageProduitEnProdSurSite(regMedicament : T_registreMedicament; regPersonnel : in T_registrePersonnel; regSite : in T_registreSite);
  procedure affichageProduitEnRetDSurSite(regMedicament : T_registreMedicament; regPersonnel : in T_registrePersonnel; regSite : in T_registreSite);
  procedure affichageProduitGereParResponable(regMedicament : in T_registreMedicament; regPersonnel : in T_registrePersonnel; regSite : in T_registreSite);
  procedure AffichageProduitEnProdSurVille(regMedicament : in T_registreMedicament; regPersonnel : in T_registrePersonnel; regSite : in T_registreSite);
  procedure AffichageProduitEnRetDSurVille(regMedicament : in T_registreMedicament; regPersonnel : in T_registrePersonnel; regSite : in T_registreSite);
  procedure affichageMedicamentCategorie(regMedicament : in T_registreMedicament; regPersonnel : in T_registrePersonnel; regSite : in T_registreSite);
  procedure miseEnProduction(regMedicament : in out T_registreMedicament; regPersonnel : in out T_registrePersonnel; regSite : in T_registreSite);
  procedure arretDeProduction(regMedicament : in out T_registreMedicament; regPersonnel : in out T_registrePersonnel; regSite : in T_registreSite);
  procedure nouveauMedicament(regMedicament : in out T_registreMedicament; regPersonnel : in out T_registrePersonnel; regSite : in T_registreSite);
  procedure supressionMedicament(regMedicament : in out T_registreMedicament; regPersonnel : in out T_registrePersonnel; regSite : in T_registreSite);


end Gestion_Medicament;
