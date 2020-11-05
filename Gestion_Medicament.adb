with ada.text_io, ada.integer_text_io, ada.float_text_io, Outils, Gestion_Dates, Gestion_Sites, Gestion_Personnel, nt_console;
USE Ada.Text_Io, Ada.Integer_Text_Io, Ada.Float_Text_Io, Outils, Gestion_Dates, Gestion_Sites, Gestion_Personnel, nt_console;

pragma elaborate_body -- permet de forcer la compilation du body, je pense que l'on pourra le retirer quandon aura des procedure

package body Gestion_Medicament is



procedure VisualtisationMedicament(tableau : in T_registreMedicament; regPersonnel : in T_registrePersonnel; regSite : in T_registreSite) is

begin -- VisualtisationMedicament
  for i in tableau'range loop
    if tableau(i).libre = false then
      Clear_Screen(black);
      put("Nom : "); put(tableau(i).nom); new_line;
      put("Categorie : "); put(T_categorie'image(tableau(i).categorie)); new_line;
      put("Type de patient : "); put(T_typePatient'image(tableau(i).typePatient)); new_line;
      put("A recu une AMM : ");
      if tableau(i).AMM then
        put("OUI le "); affichageDate(tableau(i).dateAMM); new_line;
      else
        put("NON"); new_line;
      end if;
      put("Le medicament est il en production : ");
      if tableau(i).EnProd then
        put("OUI"); new_line;
      else
        put("NON"); new_line;
      end if;

      -- Affichage responsable recherche
      put("Responsable de recherche : "); put(regPersonnel(tableau(i).respRecherche).nom); put(" "); put(regPersonnel(tableau(i).respRecherche).prenom); new_line;
      put("Present sur le site : "); put(regPersonnel(tableau(i).respRecherche).site, 1); put(" - "); put(regSite(regPersonnel(tableau(i).respRecherche).site).ville); new_line;

      new_line;

      --Affichage des chefs de production
      put_line("Liste de(s) chef(s) de production et de leur(s) site(s) :");

      if tableau(i).EnProd then
        for j in tableau(i).chefProd'range loop
          if tableau(i).chefProd(j).libre then
            put("Nom : "); put(regPersonnel(tableau(i).chefProd(j).nuEmpolye).nom); new_line;
            put("Prenom : "); put(regPersonnel(tableau(i).chefProd(j).nuEmpolye).prenom); new_line;
            put("Site : "); put(regPersonnel(tableau(i).chefProd(j).nuEmpolye).site); put(" - "); put(regSite(regPersonnel(tableau(i).chefProd(j).nuEmpolye).site).ville); new_line;
          end if;
        end loop;

      end if;
      put("Appuyer sur entrer pour medicament suivant"); skip_line;

    end if;
  end loop;



end VisualtisationMedicament;






end Gestion_Medicament;
