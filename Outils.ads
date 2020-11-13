with sequential_io;

package Outils is

  subtype T_mot is string(1..50);

  function desirQuitter return boolean;
  procedure saisieInteger(bornInf, bornSupp : in integer; nombre : out integer);
  procedure saisieFloat(bornInf, bornSupp : in float; nombre : out float);
  procedure saisieString(texte : out T_mot);
  procedure saisieBoolean(bool : out boolean);
  procedure afficherTexte(texte : in T_mot);
  procedure saisieCategorie(choixCategorie : out T_categorie);


  -------------------------------------------------------------------------------------
  -- Gesiton des fichier

  package Fichier_T_registreMedicament is new sequential_io(T_registreMedicament);
  use Fichier_T_registreMedicament;
  varFichier_T_registreMedicament : Fichier_T_registreMedicament.File_type;

  package Fichier_T_registrePersonnel is new sequential_io(T_registrePersonnel);
  use Fichier_T_registrePersonnel;
  varFichier_T_registrePersonnel : Fichier_T_registrePersonnel.File_type;

  package Fichier_T_registreSite is new sequential_io(T_registreSite);
  use Fichier_T_registreSite;
  varFichier_T_registreSite : Fichier_T_registreSite.File_type;


end Outils;
