with ada.text_io, ada.integer_text_io, ada.float_text_io, Gestion_Dates, Gestion_Sites, Gestion_Medicament, Gestion_Personnel;
USE Ada.Text_Io, Ada.Integer_Text_Io, Ada.Float_Text_Io, Gestion_Dates, Gestion_Sites, Gestion_Medicament, Gestion_Personnel;

pragma elaborate_body -- permet de forcer la compilation du body, je pense que l'on pourra le retirer quandon aura des procedure

package body Outils is

  procedure saisieInteger(bornInf, bornSupp : in integer; nombre : out integer) is -- permet la saisie d'un entier entre deux bornes

  begin -- saisieInteger

    loop
      begin
          put("=> ");
          get(nombre);
          exit when nombre in bornInf..bornSupp;
          put("Votre saisie n'est pas entre "); put(bornInf); put(" et "); put(bornSupp); new_line;
            exception
              when others => put("Votre saisie n'est pas un nombre"); skip_line; new_line;
      end;
    end loop;

  end saisieInteger;


-------------------------------------------------------------------------------------


  procedure saisieFloat(bornInf, bornSupp : in float; nombre : out float) is -- permet la saisie d'un float entre deux bornes

  begin -- saisieFloat
    loop
      begin
        put("=> ");
        get(nombre);
        exit when nombre in bornInf..bornSupp;
        put("Votre saisie n'est pas entre "); put(bornInf); put(" et "); put(bornSupp); new_line;
          exception
            when others => put("Votre saisie n'est pas un nombre a virugle"); skip_line; new_line;
      end;
    end loop;
  end saisieFloat;


  -------------------------------------------------------------------------------------

  procedure saisieString(texte : out T_mot) is -- permet la saisie d'un string de 50 caracteres
    k : integer:=0;

  begin -- saisieString
    loop
      put("=> ");
      get_line(texte, k); new_line;
      exit when k<=50;
      put("Votre mot est supperieur a 50 caracteres, veuillez ecrire un mot plus court"); new_line;
    end loop;

  end saisieString;


  -------------------------------------------------------------------------------------


  procedure saisieBoolean(bool : out boolean) is -- permet la saisie d'un boolean via un petit menu
    car : character;

  begin -- saisieBoolean
    loop
      put("Oui / Non (O/N)=> ");
      get(car); skip_line; new_line;
      case car is
        when 'O'|'o' => bool:=TRUE; exit;
        when 'N'|'n' => bool:=FALSE; exit;
        when others => put_line("Le caractere n'est pas O ou N");
      end case;
    end loop;
  end saisieBoolean;


end Outils;
