with ada.text_io, ada.integer_text_io, ada.float_text_io, Gestion_Dates, Gestion_Sites, Gestion_Medicament, Gestion_Personnel;
USE Ada.Text_Io, Ada.Integer_Text_Io, Ada.Float_Text_Io, Gestion_Dates, Gestion_Sites, Gestion_Medicament, Gestion_Personnel;

pragma elaborate_body -- permet de forcer la compilation du body, je pense que l'on pourra le retirer quandon aura des procedure

package body Outils is

  procedure saisieInteger(bornInf, bornSupp : in integer; nombre : out integer) is

  begin -- saisieInteger

    begin
      loop
        put("Saisie un nombre => ");
        get(nombre); skip_line; new_line;
        exit when n in bornInf..bornSupp;
        put("Votre saisie n'est pas entre "); put(bornInf); put(" et "); put(bornSupp); new_line;
          exception
            when others => put("Votre saisie n'est pas un nombre"); new_line;
      end loop
    end;

  end saisieInteger;


end Outils;
