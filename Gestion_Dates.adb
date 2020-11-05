with ada.text_io, ada.integer_text_io, ada.float_text_io, Outils, Gestion_Sites, Gestion_Medicament, Gestion_Personnel, nt_console;
USE Ada.Text_Io, Ada.Integer_Text_Io, Ada.Float_Text_Io, Outils, Gestion_Sites, Gestion_Medicament, Gestion_Personnel, nt_console;

pragma elaborate_body -- permet de forcer la compilation du body, je pense que l'on pourra le retirer quandon aura des procedure

package body Gestion_Dates is


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


  procedure affichageDate(date : in T_date) is

  begin -- affichageDate
    if date.j< 10 then
      put("0"); put(date.j);
    else
      put(date.j);
    end if;

   put("/");

    if date.m<10 then
      put("0"); put(date.m);
    else
      put(date.m);

    end if;
   put("/");

    put(date.a);


  end affichageDate;


end Gestion_Dates;
