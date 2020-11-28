with ada.text_io, ada.integer_text_io, ada.float_text_io,Outils, Gestion_Dates, Gestion_Sites, Gestion_Medicament, Gestion_Personnel, nt_console;
USE Ada.Text_Io, Ada.Integer_Text_Io, Ada.Float_Text_Io,Outils, Gestion_Dates, Gestion_Sites, Gestion_Medicament, Gestion_Personnel, nt_console;

PROCEDURE Programme_Principale IS


  -- Initialisation des varialbe pour gestion fichier registrePersonnel
  package Fichier_T_registrePersonnel is new sequential_io(T_registrePersonnel);
  use Fichier_T_registrePersonnel;
  fichier_registrePersonnel : Fichier_T_registrePersonnel.file_type;

  -- Initialisation des varialbe pour gestion fichier registreMedicament
  package Fichier_T_registreMedicament is new sequential_io(T_registreMedicament);
  use Fichier_T_registreMedicament;
  fichier_registreMedicament : Fichier_T_registreMedicament.file_type;

  -- Initialisation des varialbe pour gestion fichier registreSite
  package Fichier_T_registreSite is new sequential_io(T_registreSite);
  use Fichier_T_registreSite;
  fichier_registreSite : Fichier_T_registreSite.file_type;


  -------------------------------------------------------------------------------------
  -- Gesiton des fichier

  procedure sauvegarde(regMedicament : in T_registreMedicament; regPersonnel : in T_registrePersonnel; regSite : in T_registreSite) is

  begin -- sauvegarde
    begin -- registre medcaments
      create(varFichier_T_registreMedicament, name=>"RegistreMedicament");
      write(varFichier_T_registreMedicament, regMedicament);
      close(varFichier_T_registreMedicament);
      exception
        when others => put_line("Erreur enregistrement registre medicaments");

    end;

    begin -- registre personnel
      create(varFichier_T_registrePersonnel, name=>"RegistrePersonnel");
      write(varFichier_T_registrePersonnel, regPersonnel);
      close(varFichier_T_registrePersonnel);
      exception
        when others => put_line("Erreur enregistrement registre personnels");

    end;

    begin -- registre site
      create(varFichier_T_registreSite, name=>"RegistreSite");
      write(varFichier_T_registreSite, regSite);
      close(varFichier_T_registreSite);
      exception
        when others => put_line("Erreur enregistrement registre sites");

    end;


  end sauvegarde;

  -------------------------------------------------------------------------------------

  procedure restauration(regMedicament : in out T_registreMedicament; regPersonnel : in out T_registrePersonnel; regSite : in out T_registreSite) is

  begin -- restauration
    begin -- registre medcaments
      open(varFichier_T_registreMedicament, in_file, "RegistreMedicament");
      read(varFichier_T_registreMedicament, regMedicament);
      close(varFichier_T_registreMedicament);
      exception
        when others => put_line("Erreur restauration registre medicaments");

    end;

    begin -- registre personnel
      open(varFichier_T_registrePersonnel, in_file, name=>"RegistrePersonnel");
      read(varFichier_T_registrePersonnel, regPersonnel);
      close(varFichier_T_registrePersonnel);
      exception
        when others => put_line("Erreur restauration registre personnels");

    end;

    begin -- registre site
      open(varFichier_T_registreSite, in_file, name=>"RegistreSite");
      read(varFichier_T_registreSite, regSite);
      close(varFichier_T_registreSite);
      exception
        when others => put_line("Erreur restauration registre sites");

    end;


  end restauration;

  -------------------------------------------------------------------------------------


BEGIN

 Put(" ");


End Programme_principale;
