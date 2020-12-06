with ada.text_io, ada.integer_text_io, ada.float_text_io, sequential_io, Gestion_Dates, Gestion_Sites, Gestion_Medicament, Gestion_Personnel, nt_console;
USE Ada.Text_Io, Ada.Integer_Text_Io, Ada.Float_Text_Io, Gestion_Dates, Gestion_Sites, Gestion_Medicament, Gestion_Personnel, nt_console;

pragma elaborate_body -- permet de forcer la compilation du body, je pense que l'on pourra le retirer quandon aura des procedure

package body Outils is

  function desirQuitter return boolean is
    quitter : boolean;

  begin -- desirQuitter
    put("Voulez-vous quitter la procedure acctuelle ?"); new_line;
    saisieBoolean(quitter);
    return(quitter);
  end desirQuitter;

  -------------------------------------------------------------------------------------

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

  -------------------------------------------------------------------------------------

  procedure afficherTexte(texte : in T_mot) is

  begin -- afficherTexte
    for i in texte'range loop
      if texte(i)=' ' and texte(i+1)=' ' then
        exit;
      else
        put(texte(i));
      end if;
    end loop;
  end afficherTexte;

  -------------------------------------------------------------------------------------

  procedure saisieCategorie(choixCategorie : out T_categorie) is
    texte : string(1..18);
    k : integer;

  begin -- saisieCategorie
    put("Saisir une categorie : "); new_line;
    for i in T_categorie loop
      put(T_categorie'image(i)); put(" - ");
    end loop;
    new_line;
    loop
      begin
        put("=> ");
        get_line(texte, k);
        choixCategorie := T_categorie'value(texte(1..k));
        exit;
          exception
            when others => put("Votre saisie n'est pas une categorie valide"); new_line;
      end;
    end loop;
  end saisieCategorie;

  -------------------------------------------------------------------------------------

  procedure initalisation(regMedicament : in out T_registreMedicament; regPersonnel : in out T_registrePersonnel; regSite : in out T_registreSite) is

  begin
    -- initialisation des sites
    regSite(1).ville(1..5) := "Paris";
    regSite(1).prod := false;
    regSite(1).RetD := true;
    regSite(1).libre := false;

    regSite(2).ville(1..4) := "Lyon";
    regSite(2).prod := true;
    regSite(2).RetD := false;
    regSite(2).libre := false;

    regSite(3).ville(1..5) := "Paris";
    regSite(3).prod := true;
    regSite(3).RetD := true;
    regSite(3).libre := false;

    regSite(4).ville(1..9) := "Marseille";
    regSite(4).prod := true;
    regSite(4).RetD := false;
    regSite(4).libre := false;

    --initialisation personnels
    regPersonnel(1).nom(1..9) := "Merveille";
    regPersonnel(1).prenom(1..5) := "Alice";
    regPersonnel(1).site := 1;
    regPersonnel(1).nbProduit := 4;
    regPersonnel(1).prod := false;
    regPersonnel(1).RetD := true;
    regPersonnel(1).libre := false;

    regPersonnel(2).nom(1..6) := "Morane";
    regPersonnel(2).prenom(1..3) := "Bob";
    regPersonnel(2).site := 2;
    regPersonnel(2).nbProduit := 2;
    regPersonnel(2).prod := true;
    regPersonnel(2).RetD := false;
    regPersonnel(2).libre := false;

    regPersonnel(3).nom(1..5) := "Colat";
    regPersonnel(3).prenom(1..7) := "Charlie";
    regPersonnel(3).site := 2;
    regPersonnel(3).nbProduit := 1;
    regPersonnel(3).prod := true;
    regPersonnel(3).RetD := false;
    regPersonnel(3).libre := false;

    regPersonnel(4).nom(1..7) := "Vincent";
    regPersonnel(4).prenom(1..5) := "David";
    regPersonnel(4).site := 1;
    regPersonnel(4).nbProduit := 1;
    regPersonnel(4).prod := false;
    regPersonnel(4).RetD := true;
    regPersonnel(4).libre := false;

    regPersonnel(5).nom(1..7) := "Ficelle";
    regPersonnel(5).prenom(1..7) := "Estelle";
    regPersonnel(5).site := 4;
    regPersonnel(5).nbProduit := 4;
    regPersonnel(5).prod := true;
    regPersonnel(5).RetD := false;
    regPersonnel(5).libre := false;

    regPersonnel(6).nom(1..6) := "Martel";
    regPersonnel(6).prenom(1..8) := "Florence";
    regPersonnel(6).site := 3;
    regPersonnel(6).nbProduit := 2;
    regPersonnel(6).prod := false;
    regPersonnel(6).RetD := true;
    regPersonnel(6).libre := false;

    regPersonnel(7).nom(1..7) := "Lambert";
    regPersonnel(7).prenom(1..6) := "Gerard";
    regPersonnel(7).site := 3;
    regPersonnel(7).nbProduit := 2;
    regPersonnel(7).prod := true;
    regPersonnel(7).RetD := false;
    regPersonnel(7).libre := false;

    -- initalisation des medicaments
    regMedicament(1).nom(1..8) := "AirFrais";
    regMedicament(1).categorie := antihistaminiques;
    regMedicament(1).typePatient := ttPublic;
    regMedicament(1).AMM := false;
    regMedicament(1).EnProd := false;
    regMedicament(1).respRecherche := 1;
    regMedicament(1).libre := false;

    regMedicament(2).nom(1..6) := "Matete";
    regMedicament(2).categorie := antimigraineux;
    regMedicament(2).typePatient := adulte;
    regMedicament(2).AMM := true;
    regMedicament(2).dateAMM := (2017,7,2);
    regMedicament(2).EnProd := true;
    regMedicament(2).respRecherche := 1;
      regMedicament(2).chefProd(1).nuEmpolye := 2;
      regMedicament(2).chefProd(1).libre := false;
      regMedicament(2).chefProd(2).nuEmpolye := 7;
      regMedicament(2).chefProd(2).libre := false;
      regMedicament(2).chefProd(3).nuEmpolye := 5;
      regMedicament(2).chefProd(3).libre := false;
    regMedicament(2).libre := false;

    regMedicament(3).nom(1..5) := "Boost";
    regMedicament(3).categorie := vitamines;
    regMedicament(3).typePatient := adulte;
    regMedicament(3).AMM := true;
    regMedicament(3).dateAMM := (2016,8,4);
    regMedicament(3).EnProd := false;
    regMedicament(3).respRecherche := 6;
    regMedicament(3).libre := false;

    regMedicament(4).nom(1..7) := "SunLike";
    regMedicament(4).categorie := vitamines;
    regMedicament(4).typePatient := ttPublic;
    regMedicament(4).AMM := false;
    regMedicament(4).EnProd := false;
    regMedicament(4).respRecherche := 1;
    regMedicament(4).libre := false;

    regMedicament(5).nom(1..7) := "Respire";
    regMedicament(5).categorie := antihistaminiques;
    regMedicament(5).typePatient := adulte;
    regMedicament(5).AMM := false;
    regMedicament(5).EnProd := false;
    regMedicament(5).respRecherche := 1;
    regMedicament(5).libre := false;

    regMedicament(6).nom(1..7) := "Circule";
    regMedicament(6).categorie := anticoagulants;
    regMedicament(6).typePatient := adulte;
    regMedicament(6).AMM := true;
    regMedicament(6).dateAMM := (2014,5,12);
    regMedicament(6).EnProd := true;
    regMedicament(6).respRecherche := 6;
      regMedicament(6).chefProd(1).nuEmpolye := 2;
      regMedicament(6).chefProd(1).libre := false;
      regMedicament(6).chefProd(2).nuEmpolye := 5;
      regMedicament(6).chefProd(2).libre := false;
    regMedicament(6).libre := false;

    regMedicament(7).nom(1..12) := "Broncholibre";
    regMedicament(7).categorie := antihistaminiques;
    regMedicament(7).typePatient := pediatrique;
    regMedicament(7).AMM := false;
    regMedicament(7).EnProd := false;
    regMedicament(7).respRecherche := 1;
    regMedicament(7).libre := false;

    regMedicament(8).nom(1..5) := "Quiet";
    regMedicament(8).categorie := anticoagulants;
    regMedicament(8).typePatient := ttPublic;
    regMedicament(8).AMM := true;
    regMedicament(8).dateAMM := (2019,8,14);
    regMedicament(8).EnProd := true;
    regMedicament(8).respRecherche := 6;
      regMedicament(8).chefProd(1).nuEmpolye := 5;
      regMedicament(8).chefProd(1).libre := false;
      regMedicament(8).chefProd(2).nuEmpolye := 7;
      regMedicament(8).chefProd(2).libre := false;
    regMedicament(8).libre := false;

    regMedicament(9).nom(1..8) := "Mycofree";
    regMedicament(9).categorie := antifongiques;
    regMedicament(9).typePatient := adulte;
    regMedicament(9).AMM := false;
    regMedicament(9).EnProd := false;
    regMedicament(9).respRecherche := 4;
    regMedicament(9).libre := false;

    regMedicament(10).nom(1..10) := "Tetelegere";
    regMedicament(10).categorie := antimigraineux;
    regMedicament(10).typePatient := adulte;
    regMedicament(10).AMM := true;
    regMedicament(10).dateAMM := (2017,9,21);
    regMedicament(10).EnProd := true;
    regMedicament(10).respRecherche := 4;
      regMedicament(10).chefProd(1).nuEmpolye := 3;
      regMedicament(10).chefProd(1).libre := false;
      regMedicament(10).chefProd(2).nuEmpolye := 5;
      regMedicament(10).chefProd(2).libre := false;
    regMedicament(10).libre := false;

    regMedicament(11).nom(1..5) := "Boost";
    regMedicament(11).categorie := vitamines;
    regMedicament(11).typePatient := pediatrique;
    regMedicament(11).AMM := false;
    regMedicament(11).EnProd := false;
    regMedicament(11).respRecherche := 6;
    regMedicament(11).libre := false;



  end initalisation;



end Outils;
