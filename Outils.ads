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
  procedure initalisation(regMedicament : in out T_registreMedicament; regPersonnel : in out T_registrePersonnel; regSite : in out T_registreSite);




end Outils;
