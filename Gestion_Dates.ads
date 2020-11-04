package Gestion_Dates is

  subtype T_mois is integer range 1..12;
  subtype T_jour is integer range 1..31;

  type T_date is record
    a : integer;
    m : T_mois;
    j : T_jour;
  end record;

end Gestion_Dates;
