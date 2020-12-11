with ada.text_io, declaration,Outils , Gestion_Sites, Gestion_Medicament, Gestion_Personnel, nt_console, sequential_io;
USE Ada.Text_Io, declaration,Outils , Gestion_Sites, Gestion_Medicament, Gestion_Personnel, nt_console;

PROCEDURE Programme_Principale IS

  procedure suivant is

  begin -- suivant
    New_Line; New_Line;
    put("Appuyez sur entrer pour continuer");
    Skip_Line;
    clear_screen(black);

  end suivant;

  procedure titre is

  begin -- titre
    put_line("          ******************************************          ");
    put_line("                     GESTION PHARMACEUTIQUE                    ");
    put_line("          ******************************************          ");
    New_Line; New_Line;
  end titre;

  -- Initialisation des variables pour gestion fichier registrePersonnel
  package Fichier_T_registrePersonnel is new sequential_io(T_registrePersonnel);
  use Fichier_T_registrePersonnel;
  varFichier_T_registrePersonnel : Fichier_T_registrePersonnel.file_type;

  -- Initialisation des variables pour gestion fichier registreMedicament
  package Fichier_T_registreMedicament is new sequential_io(T_registreMedicament);
  use Fichier_T_registreMedicament;
  varFichier_T_registreMedicament : Fichier_T_registreMedicament.file_type;

  -- Initialisation des variables pour gestion fichier registreSite
  package Fichier_T_registreSite is new sequential_io(T_registreSite);
  use Fichier_T_registreSite;
  varFichier_T_registreSite : Fichier_T_registreSite.file_type;


  -------------------------------------------------------------------------------------
  -- Gestion des fichiers

  procedure sauvegarde(regMedicament : in T_registreMedicament; regPersonnel : in T_registrePersonnel; regSite : in T_registreSite) is

  begin -- sauvegarde
    begin -- registre medicament
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
    begin -- registre medicament
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
 Choix, choix1, choix2, choix3, choix3A, choix3B, choix4 : Character;
 RegSite : T_RegistreSite;
 RegMedicament : T_RegistreMedicament;
 RegPersonnel : T_RegistrePersonnel;
 ok : Boolean;


BEGIN
   LOOP
      titre;
      Put_Line("1 : Acces a la gestion des sites");
      Put_Line("2 : Acces a la gestion du personnel");
      Put_Line("3 : Acces a la gestion des medicaments");
      Put_Line("4 : Sauvegarde/Restauration des donnees");
      Put_Line("5 : Initialisation des donnees de tests");
      Put_Line("Q : Quitter le programme");
      Put("Que souhaitez vous faire ? (1,2,3,4,5,Q)");New_Line;
      Get(Choix); Skip_Line;

      CASE Choix IS
         WHEN 'Q' | 'q' => EXIT;
         WHEN '1' => clear_screen(black);
            LOOP
               Put_Line("Vous avez accede a la gestion des sites");
               Put_Line("1 : Visualisation du registre des sites");
               Put_Line("2 : Ajout d'un nouveau site");
               Put_Line("3 : Fermeture d'un site");
               Put_Line("Q : Revenir au menu precedent");
               Put("Que souhaitez vous faire ? (1,2,3,Q)");New_Line;
               Get(Choix1); Skip_Line;

               CASE Choix1 IS
                  WHEN 'Q' | 'q' => clear_screen(black); EXIT;
                  WHEN '1' => clear_screen(black); put_line("Voici le registre des sites :"); VisualisationSite(regSite); suivant; exit;
                  WHEN '2' => clear_screen(black); AjoutSite(regSite, Ok); suivant; exit;
                  WHEN '3' => clear_screen(black); FermetureSite(regMedicament, regPersonnel, regSite); suivant; exit;
                  WHEN others => put_line("Le choix n'est pas propose");put_line("Veuillez-recommencer"); New_Line;
               END CASE;
            END LOOP;

         WHEN '2' => clear_screen(black);
            LOOP
               Put_Line("Vous avez accede a la gestion du personnel");
               Put_Line("1 : Visualisation du registre du personnel");
               Put_Line("2 : Ajout d'un nouveau responsable sur un site");
               Put_Line("3 : Depart d'un chef de produit");
               Put_Line("4 : Depart d'un responsable de recherche");
               Put_Line("Q : Revenir au menu precedent");
               Put("Que souhaitez vous faire ? (1,2,3,4,Q)");New_Line;
               Get(Choix2); Skip_Line;

               CASE Choix2 IS
                  WHEN 'Q' | 'q' => clear_screen(black); EXIT;
                  WHEN '1' => clear_screen(black); put_line("Voici le registre du personnel :"); VisualisationPersonnel(regPersonnel,regSite); suivant; exit;
                  WHEN '2' => clear_screen(black); AjoutPersonnel(regPersonnel,regSite); suivant; exit;
                  WHEN '3' => clear_screen(black); DepartProd(regMedicament, regPersonnel, regSite); suivant; exit;
                  WHEN '4' => clear_screen(black); DepartRetD(regPersonnel, regMedicament, regSite); suivant; exit;
                  WHEN others => put_line("Le choix n'est pas propose");put_line("Veuillez-recommencer"); New_Line;
               END CASE;
            END LOOP;

         WHEN '3' => clear_screen(black);
            LOOP
               Put_Line("Vous avez accede a la gestion des medicaments");
               Put_Line("1 : Visualisation du registre des medcaments");
               Put_Line("2 : Mise a jour d'un produit");
               Put_Line("3 : Ajout d'un nouveau medcament sur un site donne");
               Put_Line("4 : Affichages cibles");
               Put_Line("5 : Supression d'un medicament");
               Put_Line("Q : Revenir au menu precedent");
               Put("Que souhaitez vous faire ? (1,2,3,4,5,Q)");New_Line;
               Get(Choix3); Skip_Line;

               CASE Choix3 IS
                  WHEN 'Q' | 'q' => clear_screen(black); EXIT;
                  WHEN '1' => clear_screen(black); put_line("Voici le registre des medicaments :"); VisualtisationMedicament(regMedicament,regPersonnel,regSite); suivant; exit;
                  WHEN '2' => clear_screen(black);
                     LOOP
                        Put_Line("Vous avez accede a la fonctionnalite : mise a jour d'un produit");
                        Put_Line("1 : Reception d'une AMM");
                        Put_Line("2 : Mise en production sur un site donne");
                        Put_Line("3 : Arret de production sur site");
                        Put_Line("Q : Revenir au menu precedent");
                        Put("Que souhaitez vous faire ? (1,2,3,Q)");New_Line;
                        Get(choix3A); Skip_Line;

                        CASE choix3A IS
                           WHEN 'Q' | 'q' => clear_screen(black); EXIT;
                           WHEN '1' => clear_screen(black); receptionAMM(regMedicament,regPersonnel,regSite); suivant; exit;
                           WHEN '2' => clear_screen(black); miseEnProduction(regMedicament,regPersonnel,regSite); suivant; exit;
                           When '3' => clear_screen(black); arretDeProduction(regMedicament,regPersonnel,regSite); suivant; exit;
                           WHEN others => put_line("Le choix n'est pas propose");put_line("Veuillez-recommencer"); New_Line;
                        END CASE;
                     END LOOP;

                  WHEN '3' => clear_screen(black); nouveauMedicament(regMedicament,regPersonnel,regSite); suivant; exit;
                  WHEN '4' => clear_screen(black);
                     LOOP
                        Put_Line("Vous avez accede a la fonctionnalite : affichages cibles");
                        Put_Line("1 : Affichage des produits en production sur un site donne");
                        put_line("2 : Affichage des produits en R&D sur un site donne");
                        Put_Line("3 : Affichage des produits en production dans une ville donnee");
                        put_line("4 : Affichage des produits en R&D dans une ville donnee");
                        Put_Line("5 : Affichage des produits geres par un responsable donne");
                        Put_Line("6 : Affichage des medicaments d'une categorie donnee");
                        Put_Line("7 : Affichage des medicaments ayant recu leur AMM avant une date donnee");
                        Put_Line("Q : Revenir au menu precedent");
                        Put("Que souhaitez vous faire ? (1,2,3,4,5,6,7,Q)");New_Line;
                        Get(choix3B); Skip_Line;

                        CASE choix3B IS
                           WHEN 'Q' | 'q' => clear_screen(black); EXIT;
                           WHEN '1' => clear_screen(black); affichageProduitEnProdSurSite(regMedicament,regPersonnel,regSite); suivant; exit;
                           WHEN '2' => clear_screen(black); affichageProduitEnRetDSurSite(regMedicament,regPersonnel,regSite); suivant; exit;
                           WHEN '3' => clear_screen(black); AffichageProduitEnProdSurVille(regMedicament,regPersonnel,regSite); suivant; exit;
                           WHEN '4' => clear_screen(black); AffichageProduitEnRetDSurVille(regMedicament,regPersonnel,regSite); suivant; exit;
                           WHEN '5' => clear_screen(black); affichageProduitGereParResponable(regMedicament,regPersonnel,regSite); suivant; exit;
                           WHEN '6' => clear_screen(black); affichageMedicamentCategorie(regMedicament,regPersonnel,regSite); suivant; exit;
                           WHEN '7' => clear_screen(black); affichageMedicamentAMMAvantDate(regMedicament); suivant; exit;
                           WHEN others => put_line("Le choix n'est pas propose");put_line("Veuillez-recommencer"); New_Line;
                        END CASE;
                     END LOOP;

                  WHEN '5' => clear_screen(black); supressionMedicament(regMedicament,regPersonnel,regSite); suivant; exit;
                  WHEN others => put_line("Le choix n'est pas propose");put_line("Veuillez-recommencer"); New_Line;

               END CASE;
            END LOOP;

         WHEN '4' => clear_screen(black);
            LOOP
               Put_Line("Vous avez accede a la fonctionnalite : Sauvegarde/Restauration des donnees");
               Put_Line("1 : Sauvegarde");
               Put_Line("2 : Restauration");
               Put_Line("Q : Revenir au menu precedent");
               Put("Que souhaitez vous faire ? (1,2,Q)");New_Line;
               Get(Choix4); Skip_Line;

               CASE Choix4 IS
                  WHEN 'Q' | 'q' => clear_screen(black); EXIT;
                  WHEN '1' => clear_screen(black); sauvegarde(regMedicament,regPersonnel,regSite); suivant; exit;
                  WHEN '2' => clear_screen(black); restauration(regMedicament,regPersonnel,regSite); suivant; exit;
                  WHEN others => put_line("Le choix n'est pas propose");put_line("Veuillez-recommencer"); New_Line;
               END CASE;
            END LOOP;

          when '5' => New_Line; initalisation(regMedicament, regPersonnel, regSite); New_Line; put_line("Initialisation terminee"); suivant;
         WHEN OTHERS => Put_Line("Le choix n'est pas propose"); put_line("Veuillez-recommencer"); New_Line; suivant;

      END CASE;
    END LOOP;


End Programme_principale;
