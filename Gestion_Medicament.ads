with Outils, Gestion_Dates, Gestion_Sites, Gestion_Personnel;
USE Outils, Gestion_Dates, Gestion_Sites, Gestion_Personnel;


package Gestion_Medicament is


  maxMed : constant integer :=14; -- nombre maximal de médicament


  type T_categorie is (antimigraineux, anticancereux, antifongiques, antihistaminiques, anticoagulants, vitamines);
  type T_typePatient is (ttPublic, adulte, pedicatrique);

  type T_chefProd is record
    nuEmpolye : integer; -- numero employe du registre registrePersonnel du chef
    libre : boolean; -- permet la gestion des cases libres/pleines
  end record;

  type T_tabChefProd is array (1..MaxEmp) of T_chefProd;


  type T_medicament is record
    nom : T_mot := (others => ' '); -- nom du medicament
    categorie : T_categorie; -- categorie du medicament
    typePatient : T_typePatient; -- forme du medicament
    AMM : boolean; -- si le medicament a recu ou non une AMM
    dateAMM : T_date; -- l'eventuelle date d'AMM du medicament
    EnProd : boolean; -- si le medicament est en production
    respRecherche : integer; -- numero index registrePersonnel du responsable
    chefProd : T_tabChefProd; -- stock la liste des numero d'employer chef de prod
    libre : boolean:= true; -- permet la gestion des cases libres/pleines

  end record;

  type T_registreMedicament is array (1..maxMed) of T_medicament;


end Gestion_Medicament;
