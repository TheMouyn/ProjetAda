with ada.text_io, ada.integer_text_io, declaration;
USE Ada.Text_Io, Ada.Integer_Text_Io;


package body Gestion_Dates is

  function dateEstAvant(date1, date2 : in T_date) return boolean is
    -- permet de de savoir si la date 1 est avant la date 2
    -- le boolean estAvant est TRUE si oui et FALSE si non
    -- si les deux date sont les meme alors ressort FALSE
    estAvant : boolean;

  begin -- dateEstAvant
    if date1.a > date2.a then
      estAvant := false;
    elsif date1.a < date2.a then
      estAvant := true;
    elsif date1.a = date2.a then
      if date1.m > date2.m then
        estAvant := false;
      elsif date1.m < date2.m then
        estAvant := true;
      elsif date1.m = date2.m then
        if date1.j > date2.j then
          estAvant := false;
        elsif date1.j < date2.j then
          estAvant := true;
        else
          estAvant := false;
        end if;
      end if;
    end if;

    return(estAvant);
  end dateEstAvant;

  -----------------------------------------------------------------------------------

  procedure saisieDate(date : out T_date) is
    nuJour, nuMois, nuAnnee : integer;

  begin -- saisieDate

    loop
      begin
        put("Saisir un jour => ");
        get(nuJour);
        exit when nuJour in 1..31;
        put_line("Votre saisie n'est pas entre 1 et 31");
        exception
          when others => put("La saisie n'est pas un nombre"); skip_line; new_line;
      end;
    end loop;

    loop
      begin
        put("Saisir un mois => ");
        get(nuMois);
        exit when nuMois in 1..12;
        put_line("Votre saisie n'est pas entre 1 et 12");
        exception
          when others => put("La saisie n'est pas un nombre"); skip_line; new_line;
      end;
    end loop;

    loop
      begin
        put("Saisir une annee => ");
        get(nuAnnee);
        exit;
        exception
          when others => put("La saisie n'est pas un nombre"); skip_line; new_line;
      end;
    end loop;

    date.a := nuAnnee;
    date.m := nuMois;
    date.j := nuJour;




  end saisieDate;

  -----------------------------------------------------------------------------------

  procedure affichageDate(date : in T_date) is

  begin -- affichageDate
    if date.j< 10 then
      put("0"); put(date.j,1);
    else
      put(date.j,1);
    end if;

   put("/");

    if date.m<10 then
      put("0"); put(date.m,1);
    else
      put(date.m,1);

    end if;
   put("/");

    put(date.a,1);


  end affichageDate;


end Gestion_Dates;
