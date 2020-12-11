package declaration is

  subtype T_mot is string(1..50);

  MaxSitesProd : constant integer := 3; -- nombre maximal de sites de production pour un medicament
  MaxS : constant integer := 5; -- nombre maximal de sites

  subtype T_mois is integer range 1..12;
  subtype T_jour is integer range 1..31;

  type T_date is record
    a : integer; -- annee
    m : T_mois; -- mois
    j : T_jour; -- jour
  end record;


  type T_site is record
    --TODO:peut etre numero d'unite
    ville : T_mot := (others => ' '); --nom de la ville
    prod, RetD : boolean := false; --boolean qui permet de savoir quel type travail
    libre : boolean := true; -- permet la gestion des cases libres/pleines
  end record;


  type T_registreSite is array (1..MaxS) of T_site; --tableau registre des records precedents

  MaxEmp : constant integer := 8; -- nombre maximal d'employes
  MaxProdCh : constant integer := 4; -- nombre maximal de produits a charge pour une personne


  type T_personnel is record
    nom, prenom : T_mot := (others => ' '); -- nom et prenom
    site : integer; -- numero l'index du tableau T_registreSite
    nbProduit : integer :=0; -- nombre de produits qui gere actuellement
    prod, RetD : boolean := false; -- type d'activites
    libre : boolean := true; -- permet la gestion des cases libres/pleines

  end record;


type T_registrePersonnel is array (1..MaxEmp) of T_personnel;

maxMed : constant integer :=14; -- nombre maximal de medicament


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
  chefProd : T_tabChefProd; -- stock la liste des numeros d'employes chef de prod
  libre : boolean:= true; -- permet la gestion des cases libres/pleines

end record;

type T_registreMedicament is array (1..maxMed) of T_medicament;



end declaration;
