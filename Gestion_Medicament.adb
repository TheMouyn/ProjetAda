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

-----------------------------------------------------------------------------------

procedure receptionAMM(regMedicament : T_registreMedicament; regPersonnel : in T_registrePersonnel; regSite : in T_registreSite) is
  nuMedicament : integer;
  choixBool : boolean;

begin -- receptionAMM
  put("Quel est le numero du medicament qui recoit une AMM ?"); new_line;

  put("Voulez vous voir le registre des medicaments ? ");
  saisieBoolean(choixBool);
  if choixBool then
    VisualtisationMedicament(regMedicament, regPersonnel, regSite);
    new_line;
    put("Quel est le numero du medicament qui recoit une AMM ?"); new_line;
  end if;
  saisieInteger(1, maxMed, nuMedicament);

  if regMedicament(nuMedicament).libre = false then
    if regMedicament(nuMedicament).AMM = false then
      regMedicament(nuMedicament).AMM:=true;
      put("A quelle date l'AMM a ete recu ? "); new_line;
      saisieDate(regMedicament(nuMedicament).dateAMM);
    else
      put("Ce medicament a deja recu une AMM"); new_line;
    end if;
  else
    put("Numero medicament inccorect, recommencer SVP"); new_line;
  end if;

end receptionAMM;

-----------------------------------------------------------------------------------

procedure affichageProduitEnProdSurSite(regMedicament : T_registreMedicament; regPersonnel : in T_registrePersonnel; regSite : in T_registreSite) is
  --Affiche les produits en production sur un site donnee
  choixNuSite : integer;
  choixBool : boolean;

begin -- affichageProduitEnProdSurSite
  put("Quel est le numero du site desire ?"); new_line;
  put("Voulez vous voir le registre des sites ? ");
  saisieBoolean(choixBool); new_line;
  if choixBool then
    VisualisationSite(regSite); --TODO: A ajuster en fonction du nombe de la fonction dans le package
    new_line;
    put("Quel est le numero du site desire ?"); new_line;
  end if;

  saisieInteger(1, MaxS ,choixNuSite);
  new_line;
  if regSite(choixNuSite).prod = true and regSite(choixNuSite).libre = false then
    put("Les medicaments en productions pour ce site sont :"); new_line;

    for i in regMedicament'range loop
      for j in regMedicament(i).chefProd'range loop
        if regMedicament(i).chefProd(j).libre = false and then regPersonnel(regMedicament(i).chefProd(j).nuEmpolye).site = choixNuSite and regMedicament(i).EnProd then
          put("- "); afficherTexte(regMedicament(i).nom); new_line;
        end if;
      end loop;
    end loop;
  else
    put("Le site n'est pas un site de production"); new_line;
  end if;

end affichageProduitEnProdSurSite;


-----------------------------------------------------------------------------------

procedure affichageProduitEnRetDSurSite(regMedicament : T_registreMedicament; regPersonnel : in T_registrePersonnel; regSite : in T_registreSite) is
  --Affiche les produits en R&D sur un site donnee
  choixNuSite : integer;
  choixBool : boolean;

begin -- affichageProduitEnRetDSurSite
  put("Quel est le numero du site desire ?"); new_line;
  put("Voulez vous voir le registre des sites ? ");
  saisieBoolean(choixBool); new_line;
  if choixBool then
    VisualisationSite(regSite); --TODO: A ajuster en fonction du nombe de la fonction dans le package
    new_line;
    put("Quel est le numero du site desire ?"); new_line;
  end if;

  saisieInteger(1, MaxS ,choixNuSite);
  new_line;
  if regSite(choixNuSite).RetD = true and regSite(choixNuSite).libre = false then
    put("Les medicaments en R&D pour ce site sont :"); new_line;

    for i in regMedicament'range loop
      if regMedicament(i).libre = false and then regPersonnel(regMedicament(i).respRecherche).site = choixNuSite and regMedicament(i).EnProd = false then
        put("- "); afficherTexte(regMedicament(i).nom); new_line;
      end if;
    end loop;
  else
    put("Le site n'est pas un site de R&D"); new_line;
  end if;

end affichageProduitEnRetDSurSite;

-----------------------------------------------------------------------------------

procedure affichageProduitGereParResponable(regMedicament : in T_registreMedicament; regPersonnel : in T_registrePersonnel; regSite : in T_registreSite) is
  -- affiche les produit gere pas un responsable de recherche
  choixNuEmpolye : integer;
  choixBool : boolean;

begin -- affichageProduitGereParResponable
  put("Quel est le numero employe ? "); new_line;
  put("Voulez vous voir le registre du personnel ? ");
  saisieBoolean(choixBool); new_line;

  if choixBool then
    VisualisationPersonnel(regPersonnel, regSite);
    new_line;
    put("Quel est le numero employe ? "); new_line;
  end if;

  saisieInteger(1, MaxEmp, choixNuEmpolye); new_line;

  if regPersonnel(choixNuEmpolye).RetD and regPersonnel(choixNuEmpolye).libre = false then
    put("Liste des medicaments gere par ce responsable : "); new_line;

    for i in regMedicament'range loop
      if regMedicament(i).libre = false and then regMedicament(i).respRecherche = choixNuEmpolye then
        put("- "); afficherTexte(regMedicament(i).nom); new_line;
      end if;
    end loop;
  else
    put("Cet employe n'est pas un responsable de R&D"); new_line;
  end if;

end affichageProduitGereParResponable;

-----------------------------------------------------------------------------------

procedure affichageMedicamentAMMAvantDate(regMedicament : in T_registreMedicament) is
  choixDate : T_date;

begin -- affichageMedicamentAMMAvantDate
  put_line("Saisir une date : ");
  saisieDate(choixDate);
  put("Liste des medicaments qui ont recu une AMM avant le "); affichageDate(choixDate); new_line;
  for i in regMedicament'range loop
    if regMedicament(i).libre = false and regMedicament(i).AMM then
      if dateEstAvant(choixDate, regMedicament(i).dateAMM) then
        put("- "); afficherTexte(regMedicament(i).nom); new_line;
      end if;
    end if;
  end loop;
end affichageMedicamentAMMAvantDate;


-----------------------------------------------------------------------------------

procedure AffichageProduitEnProdSurVille(regMedicament : in T_registreMedicament; regPersonnel : in T_registrePersonnel; regSite : in T_registreSite) is
  -- Affichage cible de la liste des produits en production  dans une ville donnée
  choixVille : T_mot := (others => ' ');

begin -- AffichageProduitEnProdSurVille
  put("Saisir le nom de la ville : "); new_line;
  saisieString(choixVille); new_line;
  put("Liste des medicaments qui sont en production dans cette ville : "); new_line;

    for i in regMedicament'range loop
      if regMedicament(i).libre = false then
        for j in regMedicament(i).chefProd'range loop
          if regMedicament(i).chefProd(j).libre = false and then regSite(regPersonnel(regMedicament(i).chefProd(j).nuEmpolye).site).ville = choixVille and regMedicament(i).EnProd then
            put("- "); afficherTexte(regMedicament(i).nom); new_line;
          end if;
        end loop;
      end if;
    end loop;

end AffichageProduitEnProdSurVille;

-----------------------------------------------------------------------------------

procedure AffichageProduitEnRetDSurVille(regMedicament : in T_registreMedicament; regPersonnel : in T_registrePersonnel; regSite : in T_registreSite) is
  -- Affichage cible de la liste des produits en production  dans une ville donnée
  choixVille : T_mot := (others => ' ');

begin -- AffichageProduitEnRetDSurVille
  put("Saisir le nom de la ville : "); new_line;
  saisieString(choixVille); new_line;
  put("Liste des medicaments qui sont en R&D dans cette ville : "); new_line;

    for i in regMedicament'range loop
      if regMedicament(i).libre = false and then regSite(regPersonnel(regMedicament(i).respRecherche).site).ville = choixVille and regMedicament(i).EnProd = false then
        -- Si seulement si en recherche et donc pas en prod
        put("- "); afficherTexte(regMedicament(i).nom); new_line;
      end if;
    end loop;

end AffichageProduitEnRetDSurVille;

-----------------------------------------------------------------------------------

procedure affichageMedicamentCategorie(regMedicament : in T_registreMedicament; regPersonnel : in T_registrePersonnel; regSite : in T_registreSite) is
  -- Affichage cible de la liste des medicaments d'une categorie donnée (avec les informations sur les sites de production)
  choixCategorie : T_categorie;

begin -- affichageMedicamentCategorie
  saisieCategorie(choixCategorie);
  new_line;
  put_line("Liste des medcaments qui appartiennent a cette categorie : ");

  for i in regMedicament'range loop
    if regMedicament(i).libre = false and then regMedicament(i).categorie = choixCategorie then
      put("- "); afficherTexte(regMedicament(i).nom);
      if regMedicament(i).EnProd then
        put(" en production sur les sites : ");
        for j in regMedicament(i).chefProd'range loop
          if regMedicament(i).chefProd(j).libre = false then
            put(regPersonnel(regMedicament(i).chefProd(j).nuEmpolye).site, 1);
            put(" - ");
            afficherTexte(regSite(regPersonnel(regMedicament(i).chefProd(j).nuEmpolye).site).ville);
            put(" ");
          end if;
        end loop;
      end if;
      new_line;
    end if;
  end loop;

end affichageMedicamentCategorie;



end Gestion_Medicament;
