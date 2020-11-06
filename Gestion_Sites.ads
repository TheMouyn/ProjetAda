WITH Outils;
USE Outils;



package Gestion_Sites is
  MaxSitesProd : constant integer := 3; -- nombre maximale de sites de production pour un medicament
  MaxS : constant integer := 5; -- nombre maximale de sites


  type T_site is record
    --TODO:peut etre numero d'unite
    ville : T_mot := (others => ' '); --nom de la ville
    prod, RetD : boolean := false; --boolean qui permet de savoir quel type travail
    libre : boolean := true; -- permet la gestion des cases libres/pleines
  end record;


  type T_registreSite is array (1..MaxS) of T_site; --tableau registre des record precedent
   PROCEDURE Visualisation (T : IN T_registreSite);
   PROCEDURE Ajout (T : IN OUT T_registreSite);
   PROCEDURE Fermeture (T: IN OUT T_registreSite);


end Gestion_Sites;
