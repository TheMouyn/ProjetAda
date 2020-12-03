with Outils;
USE Outils;



package Gestion_Personnel is
  MaxEmp : constant integer := 8; -- nombre maximale d'employes
  MaxProdCh : constant integer := 4; -- nombre maximale de produits a charge pour une personne


  type T_personnel is record
    nom, prenom : T_mot := (others => ' '); -- nom et prenom
    site : integer; -- numero l'index du tableau T_registreSite
    nbProduit : integer :=0; -- nombre de produits qui gere acctuement
    prod, RetD : boolean := false; -- type d'activites
    libre : boolean := true; -- permet la gestion des cases libres/pleines

  end record;


  type T_registrePersonnel is array (1..MaxEmp) of T_personnel;
   PROCEDURE VisualisationPersonnel (T : IN T_registrePersonnel; regSite : T_registreSite);
   PROCEDURE AjoutPersonnel (T : IN OUT T_RegistrePersonnel; S : IN OUT T_RegistreSite);
   PROCEDURE DepartProd (T: IN OUT T_RegistrePersonnel);
   PROCEDURE DepartRetD (T: IN OUT T_registrePersonnel);


end Gestion_Personnel;
