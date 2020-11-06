with ada.text_io, ada.integer_text_io, ada.float_text_io, Outils, Gestion_Dates, Gestion_Sites, Gestion_Personnel, nt_console;
USE Ada.Text_Io, Ada.Integer_Text_Io, Ada.Float_Text_Io, Outils, Gestion_Dates, Gestion_Sites, Gestion_Personnel, nt_console;

pragma elaborate_body -- permet de forcer la compilation du body, je pense que l'on pourra le retirer quandon aura des procedure

package body Gestion_Medicament is




function nbMedicament(regMedicaments : in T_registreMedicament) return integer is -- permet de compter le nombre de medicament dans le registre
  nombre : integer :=0;

begin -- nbMedicament
  for i in regMedicaments'range loop
    if regMedicaments(i).libre = false then
      nombre:= numbre+1;
    end if;
  end loop;
  return(nombre);
end nbMedicament;
----------------------------------------------------------------------------------------------------

procedure VisualtisationMedicament(regMedicaments : in T_registreMedicament; regPersonnel : in T_registrePersonnel; regSite : in T_registreSite) is

begin -- VisualtisationMedicament
  for i in regMedicaments'range loop
    if regMedicaments(i).libre = false then
      Clear_Screen(black);
      put("Numero medicament : "); put(i,1); new_line;
      put("Nom : "); afficherTexte(regMedicaments(i).nom); new_line;
      put("Categorie : "); put(T_categorie'image(regMedicaments(i).categorie)); new_line;
      put("Type de patient : ");
      case regMedicaments(i).typePatient is
        when ttPublic => put("TOUT PUBLIC"); new_line;
        when adulte => put("ADULTE UNIQUEMENT"); new_line;
        when pediatrique => put("PEDIATRIQUE UNIQUEMENT"); new_line;
      end case;
      put("A recu une AMM : ");
      if regMedicaments(i).AMM then
        put("OUI le "); affichageDate(regMedicaments(i).dateAMM); new_line;
      else
        put("NON"); new_line;
      end if;
      put("Le medicament est il en production : ");
      if regMedicaments(i).EnProd then
        put("OUI"); new_line;
      else
        put("NON"); new_line;
      end if;

      -- Affichage responsable recherche
      put("Responsable de recherche : "); afficherTexte(regPersonnel(regMedicaments(i).respRecherche).nom); put(" "); afficherTexte(regPersonnel(regMedicaments(i).respRecherche).prenom); new_line;
      put("Present sur le site : "); put(regPersonnel(regMedicaments(i).respRecherche).site, 1); put(" - "); afficherTexte(regSite(regPersonnel(regMedicaments(i).respRecherche).site).ville); new_line;

      new_line;

      --Affichage des chefs de production

      if regMedicaments(i).EnProd then
        put_line("Liste de(s) chef(s) de production et de leur(s) site(s) :");
        for j in regMedicaments(i).chefProd'range loop
          if regMedicaments(i).chefProd(j).libre = false then
            put("Nom : "); afficherTexte(regPersonnel(regMedicaments(i).chefProd(j).nuEmpolye).nom); new_line;
            put("Prenom : "); afficherTexte(regPersonnel(regMedicaments(i).chefProd(j).nuEmpolye).prenom); new_line;
            put("Site : "); put(regPersonnel(regMedicaments(i).chefProd(j).nuEmpolye).site, 1); put(" - "); afficherTexte(regSite(regPersonnel(regMedicaments(i).chefProd(j).nuEmpolye).site).ville); new_line;
            new_line;
          end if;
        end loop;

      end if;
      new_line;
      put("Appuyer sur entrer pour medicament suivant"); skip_line;

    end if;
  end loop;



end VisualtisationMedicament;






end Gestion_Medicament;
