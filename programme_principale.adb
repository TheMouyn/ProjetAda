with ada.text_io, ada.integer_text_io, ada.float_text_io,Outils, Gestion_Dates, Gestion_Sites, Gestion_Medicament, Gestion_Personnel, nt_console;
USE Ada.Text_Io, Ada.Integer_Text_Io, Ada.Float_Text_Io,Outils, Gestion_Dates, Gestion_Sites, Gestion_Medicament, Gestion_Personnel, nt_console;

PROCEDURE Programme_Principale IS


  -- Initialisation des variables pour gestion fichier registrePersonnel
  package Fichier_T_registrePersonnel is new sequential_io(T_registrePersonnel);
  use Fichier_T_registrePersonnel;
  fichier_registrePersonnel : Fichier_T_registrePersonnel.file_type;

  -- Initialisation des variables pour gestion fichier registreMedicament
  package Fichier_T_registreMedicament is new sequential_io(T_registreMedicament);
  use Fichier_T_registreMedicament;
  fichier_registreMedicament : Fichier_T_registreMedicament.file_type;

  -- Initialisation des variables pour gestion fichier registreSite
  package Fichier_T_registreSite is new sequential_io(T_registreSite);
  use Fichier_T_registreSite;
  fichier_registreSite : Fichier_T_registreSite.file_type;


  -------------------------------------------------------------------------------------
  -- Gesiton des fichiers

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
 Choix, choix1, choix2, choix3, choix3.2, choix3.4, choix4 : Character;
 ChoixBool : Boolean := False;
 RegSite : T_RegistreSite
 RegMedicament : T_RegistreMedicament
 RegPersonnel : T_RegistrePersonnel


BEGIN
   LOOP
      Put_Line("Bienvenue dans le site de gestion pharmaceutique !");
      Put_Line("1 : Acces a la gestion des sites");
      Put_Line("2 : Acces a la gestion du personnel");
      Put_Line("3 : Acces a la gestion des medicaments");
      Put_Line("4 : Sauvegarde/Restauration des donnees");
      Put_Line("Q : Quitter");
      Put("Que souhaitez vous faire ? (1,2,3,4,Q)");New_Line;
      Get(Choix); Skip_Line;
      Put("Vous avez selectionne : ");Put(Choix); New_Line;
      Put(" Etes vous sur ? O/N");
      SaisieBoolean(ChoixBool);
          IF ChoixBool = false THEN
             exit;
             New_Line;
          END IF;

      CASE Choix IS
         WHEN Q => EXIT;
         WHEN 1 =>
            LOOP
               Put("Vous avez accede a la gestion des sites");
               Put_Line("1 : Visualisation du registre");
               Put_Line("2 : Ajout d'un nouveau site");
               Put_Line("3 : Fermeture d'un site");
               Put_Line("Q : Quitter");
               Put("Que souhaitez vous faire ? (1,2,3,Q)");New_Line;
               Get(Choix1); Skip_Line;
               Put("Vous avez selectionne : ");Put(Choix1); New_Line;
               Put(" Etes vous sur ? O/N");
               SaisieBoolean(ChoixBool);
               IF ChoixBool = False THEN
                  EXIT;
                  New_Line;
               END IF;

               CASE Choix1 IS
                  WHEN Q => EXIT;
                  WHEN 1 => put_line("Voici le registre des sites :"); VisualisationSite(regSite);
                  WHEN 2 => AjoutSite(regSite, Ok);
                  WHEN 3 => FermetureSite(regSite,regMedicament,regPersonnel);
                  WHEN others => put_line("Le choix n'est pas propose");put_line("Veuilez-recommencer");
               END CASE;
            END LOOP;

         WHEN 2 =>
            LOOP
               Put("Vous avez accede a la gestion du personnel");
               Put_Line("1 : Visualisation du registre");
               Put_Line("2 : Ajout d'un nouveau responsable sur un site");
               Put_Line("3 : Depart d'un chef de produit");
               Put_Line("4 : Depart d'un responsable de recherche");
               Put_Line("Q : Quitter");
               Put("Que souhaitez vous faire ? (1,2,3,4,Q)");New_Line;
               Get(Choix2); Skip_Line;
               Put("Vous avez selectionne : ");Put(Choix2); New_Line;
               Put(" Etes vous sur ? O/N");
               SaisieBoolean(ChoixBool);
               IF ChoixBool = False THEN
                  EXIT;
                  New_Line;
               END IF;

               CASE Choix2 IS
                  WHEN Q => EXIT;
                  WHEN 1 => put_line("Voici le registre du personnel :"); VisualisationPersonnel(regPersonnel,regSite);
                  WHEN 2 => AjoutPersonnel(regPersonnel,regSite);
                  WHEN 3 => DepartProd(regPersonnel,regSite,regMedicament);
                  WHEN 4 => DepartRetD(regPersonnel,regMedicament,regSite);
                  WHEN others => put_line("Le choix n'est pas propose");put_line("Veuilez-recommencer");
               END CASE;
            END LOOP;

         WHEN 3 =>
            LOOP
               Put("Vous avez accede a la gestion des medicaments");
               Put_Line("1 : Visualisation du registre");
               Put_Line("2 : Mise a jour d'un produit");
               Put_Line("3 : Ajout d'un nouveau produit sur un site donne");
               Put_Line("4 : Affichages cibles");
               Put_Line("5 : Supression d'un medicament");
               Put_Line("Q : Quitter");
               Put("Que souhaitez vous faire ? (1,2,3,4,5,Q)");New_Line;
               Get(Choix3); Skip_Line;
               Put("Vous avez selectionne : ");Put(Choix3); New_Line;
               Put(" Etes vous sur ? O/N");
               SaisieBoolean(ChoixBool);
               IF ChoixBool = False THEN
                  EXIT;
                  New_Line;
               END IF;

               CASE Choix3 IS
                  WHEN Q => EXIT;
                  WHEN 1 => put_line("Voici le registre des medicaments :"); VisualisationMedicament(regMedicament,regPersonnel,regSite);
                  WHEN 2 =>
                     LOOP
                        Put("Vous avez accede a la fonctionnalite : mise a jour d'un produit");
                        Put_Line("1 : Reception d'une AMM");
                        Put_Line("2 : Mise en production sur un site donne");
                        Put_Line("3 : Arret de production sur site");
                        Put_Line("Q : Quitter");
                        Put("Que souhaitez vous faire ? (1,2,3,Q)");New_Line;
                        Get(Choix3.2); Skip_Line;

                        Put("Vous avez selectionne : ");Put(Choix3.2); New_Line;
                        Put(" Etes vous sur ? O/N");
                        SaisieBoolean(ChoixBool);
                        IF ChoixBool = False THEN
                           EXIT;
                           New_Line;
                        END IF;

                        CASE Choix3.2 IS
                           WHEN Q => EXIT;
                           WHEN 1 => receptionAMM(regMedicament,regPersonnel,regSite);
                           WHEN 2 => miseEnProduction(regMedicament,regPersonnel,regSite);
                           When 3 => arretDeProduction(regMedicament,regPersonnel,regSite);
                           WHEN others => put_line("Le choix n'est pas propose");put_line("Veuilez-recommencer");
                        END CASE;
                     END LOOP;

                  WHEN 3 => nouveauMedicament(regMedicament,regPersonnel,regSite);
                  WHEN 4 =>
                     LOOP
                        Put("Vous avez accede a la fonctionnalite : affichages cibles");
                        Put_Line("1 : Affichage des produits en production sur un site donne");
                        Put_Line("2 : Affichage des produits en production dans une ville donnee");
                        Put_Line("3 : Affichage des produits geres par un responsable donne");
                        Put_Line("4 : Affichage des medicaments d'une categorie donnee");
                        Put_Line("5 : Affichage des medicaments ayant recu leur AMM avant une date donnee");
                        Put_Line("Q : Quitter");
                        Put("Que souhaitez vous faire ? (1,2,3,4,5,Q)");New_Line;
                        Get(Choix3.4); Skip_Line;

                        Put("Vous avez selectionne : ");Put(Choix3.4); New_Line;
                        Put(" Etes vous sur ? O/N");
                        SaisieBoolean(ChoixBool);
                        IF ChoixBool = False THEN
                           EXIT;
                           New_Line;
                        END IF;

                        CASE Choix3.4 IS
                           WHEN Q => EXIT;
                           WHEN 1 => affichageProduitEnProdSurSite(regMedicament,regPersonnel,regSite);
                           WHEN 2 => AffichageProduitEnProdSurVille(regMedicament,regPersonnel,regSite);
                           WHEN 3 => affichageProduitGereParResponable(regMedicament,regPersonnel,regSite);
                           WHEN 4 => affichageMedicamentCategorie(regMedicament,regPersonnel,regSite);
                           WHEN 5 => affichageMedicamentAMMAvantDate(regMedicament);
                           WHEN others => put_line("Le choix n'est pas propose");put_line("Veuilez-recommencer");
                        END CASE;
                     END LOOP;

                  WHEN 5 => supressionMedicament(regMedicament,regPersonnel,regSite);
                  WHEN others => put_line("Le choix n'est pas propose");put_line("Veuilez-recommencer");

               END CASE;
            END LOOP;

         WHEN 4 =>
            LOOP
               Put("Vous avez accede a la fonctionnalite : Sauvegarde/Restauration des donnees");
               Put_Line("1 : Sauvegarde");
               Put_Line("2 : Restauration");
               Put_Line("Q : Quitter");
               Put("Que souhaitez vous faire ? (1,2,Q)");New_Line;
               Get(Choix4); Skip_Line;
               Put("Vous avez selectionne : ");Put(Choix4); New_Line;
               Put(" Etes vous sur ? O/N");
               SaisieBoolean(ChoixBool);
               IF ChoixBool = False THEN
                  EXIT;
                  New_Line;
               END IF;

               CASE Choix4 IS
                  WHEN Q => EXIT;
                  WHEN 1 => sauvegarde(regMedicament,regPersonnel,regSite);
                  WHEN 2 => restauration(regMedicament,regPersonnel,regSite);
                  WHEN others => put_line("Le choix n'est pas propose");put_line("Veuilez-recommencer");
               END CASE;
            END LOOP;

         WHEN OTHERS => Put_Line("Le choix n'est pas propose"); put_line("Veuilez-recommencer");


      END CASE;
    END LOOP;


End Programme_principale;
