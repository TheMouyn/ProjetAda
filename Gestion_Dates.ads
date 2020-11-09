package Gestion_Dates is

  subtype T_mois is integer range 1..12;
  subtype T_jour is integer range 1..31;

  type T_date is record
    a : integer; -- annee
    m : T_mois; -- mois
    j : T_jour; -- jour
  end record;

  function dateEstAvant(date1, date2 : in T_date) return boolean;
  procedure saisieDate(date : out T_date);
  procedure affichageDate(date : in T_date);

end Gestion_Dates;
