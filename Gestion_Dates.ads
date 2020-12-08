with  declaration;
use  declaration;


package Gestion_Dates is


  function dateEstAvant(date1, date2 : in T_date) return boolean;
  procedure saisieDate(date : out T_date);
  procedure affichageDate(date : in T_date);

end Gestion_Dates;
