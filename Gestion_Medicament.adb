with ada.text_io, ada.integer_text_io, ada.float_text_io, Outils, Gestion_Dates, Gestion_Sites, Gestion_Personnel, nt_console;
USE Ada.Text_Io, Ada.Integer_Text_Io, Ada.Float_Text_Io, Outils, Gestion_Dates, Gestion_Sites, Gestion_Personnel, nt_console;

pragma elaborate_body; -- permet de forcer la compilation du body, je pense que l'on pourra le retirer quandon aura des procedure

package body Gestion_Medicament is

function nbSiteProductionMedicament(nuMed : in integer; regMedicament : in T_registreMedicament) return integer is
  -- return le nombre de site ou ce medicament est produit
  nombre : integer := 0;

begin -- nbSiteProductionMedicament
  for i in regMedicament(nuMed).chefProd'range loop
    if regMedicament(nuMed).chefProd(i).libre = false then
      nombre := nombre +1;
    end if;
  end loop;
  return(nombre);
end nbSiteProductionMedicament;

----------------------------------------------------------------------------------------------------


function nbMedicament(regMedicaments : in T_registreMedicament) return integer is -- permet de compter le nombre de medicament dans le registre
  nombre : integer :=0;

begin -- nbMedicament
  for i in regMedicaments'range loop
    if regMedicaments(i).libre = false then
      nombre:= nombre+1;
    end if;
  end loop;
  return(nombre);
end nbMedicament;
----------------------------------------------------------------------------------------------------

procedure VisualtisationMedicament(regMedicaments : in T_registreMedicament; regPersonnel : in T_registrePersonnel; regSite : in T_registreSite) is
  car : character; --permet de savoir si on veut quitter la lecture du registre

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
      if regMedicaments(i).respRecherche = -1 then
        put("Responsable de recherche : PERSONNEL SUPPRIME");
      ELSE
        put("Responsable de recherche : "); afficherTexte(regPersonnel(regMedicaments(i).respRecherche).nom); put(" "); afficherTexte(regPersonnel(regMedicaments(i).respRecherche).prenom); new_line;
        put("Present sur le site : "); put(regPersonnel(regMedicaments(i).respRecherche).site, 1); put(" - "); afficherTexte(regSite(regPersonnel(regMedicaments(i).respRecherche).site).ville); new_line;

      end if;

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
      put("Appuyer sur entrer pour medicament suivant pour sur 'Q' pour Quitter");
      get_immediate(car);
      if car = 'q' or car = 'Q' then
        exit;
      end if;

    end if;
  end loop;



end VisualtisationMedicament;

-----------------------------------------------------------------------------------

procedure receptionAMM(regMedicament : in out T_registreMedicament; regPersonnel : in out T_registrePersonnel; regSite : in T_registreSite) is
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
      regPersonnel(regMedicament(nuMedicament).respRecherche).nbProduit := regPersonnel(regMedicament(nuMedicament).respRecherche).nbProduit -1;
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
      if regMedicament(i).libre = false and then regPersonnel(regMedicament(i).respRecherche).site = choixNuSite and regMedicament(i).AMM = false then
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

  if  regPersonnel(choixNuEmpolye).libre = false and then regPersonnel(choixNuEmpolye).RetD then
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

-----------------------------------------------------------------------------------

procedure miseEnProduction(regMedicament : in out T_registreMedicament; regPersonnel : in out T_registrePersonnel; regSite : in T_registreSite) is
  choixBool : boolean;
  choixMedicament, choixPersonnel : integer;
  dejaChef, choixQuitter : boolean:=false;



begin -- miseEnProduction
  loop -- boucle generale qui permet la confirmation et de recommencer
    loop -- saisie controlee d'un numero de medciament dans le registre avec demande de visualtion du registre medicament
      if choixQuitter then
        exit;
      end if;

      put_line("Quel est le numero du medicament a mettre en production ?");
      put_line("Vous vous voir le registre des medicaments ?");
      saisieBoolean(choixBool);
      if choixBool then
        VisualtisationMedicament(regMedicament, regPersonnel, regSite);
        new_line;
        put_line("Quel est le numero du medicament a mettre en production ?");
      end if;
      saisieInteger(1, maxMed, choixMedicament);

      if regMedicament(choixMedicament).libre = false then
        if nbSiteProductionMedicament(choixMedicament, regMedicament) < MaxSitesProd then
          if regMedicament(choixMedicament).AMM then
            exit;
          else
            put_line("Le medicament n'a pas recu d'AMM, il ne peux pas etre mis en production");
            choixQuitter:=true; -- on impose la sortie de la procedure
          end if;

        else
          put_line("Le nombre maximal de site de production pour ce medicament est atteint");
          choixQuitter:=desirQuitter; -- demande si l'utilisateur veut quitter la procedure acctuelle
        end if;
      else
        put_line("Le numero saisi ne corespond pas a un medicament du registre");
        choixQuitter:=desirQuitter; -- demande si l'utilisateur veut quitter la procedure acctuelle
      end if;
    end loop;

    if choixQuitter then
      exit;
    end if;

    loop -- saisie controlee du chef de prod avec visualisation deu regPersonnel si besoin
      if choixQuitter then
        exit;
      end if;
      put_line("Quel est le numero du chef de production pour ce medicament ?");
      put_line("Voulez-vous voir le registre des personnels ? ");
      saisieBoolean(choixBool);
      if choixBool then
        VisualisationPersonnel(regPersonnel, regSite); --TODO: verifier paramettres
        new_line;
        put_line("Quel sera le numero du chef de production pour ce medicament ?");
      end if;
      saisieInteger(1, MaxS, choixPersonnel);

      if regPersonnel(choixPersonnel).libre = false and then regPersonnel(choixPersonnel).prod then
        if regPersonnel(choixPersonnel).nbProduit < MaxProdCh then
          --verification si le chef de prod souhaite n'est pas deja chef de prod sur ce medicament
          for i in regMedicament(choixMedicament).chefProd'range loop
            if regMedicament(choixMedicament).chefProd(i).libre = false and then regMedicament(choixMedicament).chefProd(i).nuEmpolye = choixPersonnel then
              dejaChef:=true;
              exit;
            end if;
          end loop;

          if dejaChef = false then
            exit;
          else
            put_line("Ce personnel est deja chef de production pour ce produit");
            choixQuitter:=true; -- on impose la sortie de la procedure
          end if;
        else
          put_line("Ce personnel a deja trop de produit a charge");
          choixQuitter:=desirQuitter; -- demande si l'utilisateur veut quitter la procedure acctuelle
        end if;
      else
        put_line("Le numero saisi ne correspond pas a un personnel de production dans le registre");
        choixQuitter:=desirQuitter; -- demande si l'utilisateur veut quitter la procedure acctuelle
      end if;

    end loop;

    if choixQuitter then
      exit;
    end if;

    -- Confirmation
    put("Vous voulez mettre en production le medicament "); put(choixMedicament, 1); put(" : "); afficherTexte(regMedicament(choixMedicament).nom); new_line;
    put("Avec comme chef de production l'employe numero "); put(choixPersonnel, 1); put(" : "); afficherTexte(regPersonnel(choixPersonnel).nom); put(" "); put(regPersonnel(choixPersonnel).prenom); new_line;
    put("Sur le site "); put(regPersonnel(choixPersonnel).site, 1); put(" - "); afficherTexte(regSite(regPersonnel(choixPersonnel).site).ville); new_line;
    new_line;
    put_line("Vous confirmer ?");
    saisieBoolean(choixBool);

    if choixBool then
      -- toutes les condition sont validees -> association des varaibles
      regMedicament(choixMedicament).EnProd:=true;
      for i in regMedicament(choixMedicament).chefProd'range loop
        if regMedicament(choixMedicament).chefProd(i).libre = true then
          regMedicament(choixMedicament).chefProd(i).libre := false;
          regMedicament(choixMedicament).chefProd(i).nuEmpolye := choixPersonnel;
          regPersonnel(choixPersonnel).nbProduit:=regPersonnel(choixPersonnel).nbProduit+1;
          choixQuitter:=TRUE;
          exit;
        end if;
      end loop;
    else
      put_line("Mise en production annulee");
      put_line("Voulez-vous recommencer ?");
      saisieBoolean(choixBool);
      if choixBool = false then
        exit;
      end if;
    end if;

    if choixQuitter then
      exit;
    end if;
  end loop;

end miseEnProduction;


-----------------------------------------------------------------------------------

procedure arretDeProduction(regMedicament : in out T_registreMedicament; regPersonnel : in out T_registrePersonnel; regSite : in T_registreSite) is
-- un arret de production d'un medciament donne sur un site donee
choixBool : boolean;
choixMedicament, choixSite, chefProdSiteEnCours : integer;
choixQuitter : boolean:=false;
verifChefProf : boolean := false; -- vrai si il y a bien un chef de prod associe au site saisi
toujoursEnProd : boolean := false; -- verifie si un medicament est toujours en prod somewhere


begin -- arretDeProduction
  loop -- boucle generale qui permet la confirmation et de recommencer
    loop -- saisie controlee d'un numero de medciament dans le registre avec demande de visualtion du registre medicament
      if choixQuitter then
        exit;
      end if;

      put_line("Quel est le numero du medicament a arreter en production ?");
      put_line("Vous vous voir le registre des medicaments ?");
      saisieBoolean(choixBool);
      if choixBool then
        VisualtisationMedicament(regMedicament, regPersonnel, regSite);
        new_line;
        put_line("Quel est le numero du medicament a arreter en production ?");
      end if;
      saisieInteger(1, maxMed, choixMedicament);

      if regMedicament(choixMedicament).libre = false then
        if regMedicament(choixMedicament).EnProd = true then
          exit;
        else
          put_line("Ce medicament n'est pas en production");
          choixQuitter := true; -- on impose la sortie de la procedure
        end if;
      else
        put_line("Le numero saisi ne corespond pas a un medicament du registre");
        choixQuitter:=desirQuitter; -- demande si l'utilisateur veut quitter la procedure acctuelle
      end if;
    end loop;

    if choixQuitter then
      exit;
    end if;

    loop -- selection du site ou il faut arreter la production
      if choixQuitter then
        exit;
      end if;

      put_line("Quel est le numero du site ou vous voulez arreter la production du medicament");
      put_line("Voulez vous voir le registre des sites ?");
      saisieBoolean(choixBool);
      if choixBool then
        VisualisationSite(regSite);
        new_line;
        put_line("Quel est le numero du site ou vous voulez arreter la production du medicament");
      end if;
      saisieInteger(1, MaxS, choixSite);

      if regSite(choixSite).libre = false then
        if regSite(choixSite).prod = true then
            -- verification que le medicament est bien en prod sur ce site
            for i in regMedicament(choixMedicament).chefProd'range loop
              if regMedicament(choixMedicament).chefProd(i).libre = false and then regPersonnel(regMedicament(choixMedicament).chefProd(i).nuEmpolye).site = choixSite then
              -- car il ne peut avoir qu'un seul chef de prod par site pour un medicament
                chefProdSiteEnCours := regMedicament(choixMedicament).chefProd(i).nuEmpolye;
                verifChefProf := true;
                exit;
              end if;
            end loop;

            if verifChefProf then
              exit;
            else
              put_line("Il n'y a pas de chef de production associe pour ce site dans le registe medicament");
              choixQuitter:=desirQuitter; -- demande si l'utilisateur veut quitter la procedure acctuelle
            end if;

        else
          put_line("Le site n'est pas un site de production");
          choixQuitter:=desirQuitter; -- demande si l'utilisateur veut quitter la procedure acctuelle
        end if;
      else
        put_line("Le site saisi n'est pas dans le registre");
        choixQuitter:=desirQuitter; -- demande si l'utilisateur veut quitter la procedure acctuelle
      end if;
    end loop;

    if choixQuitter then
      exit;
    end if;

    -- Confirmation
    put("Vous voulez stopper la production du medicament "); put(choixMedicament, 1); put(" : "); afficherTexte(regMedicament(choixMedicament).nom); new_line;
    put("Sur le site "); put(choixSite, 1); put(" : "); afficherTexte(regSite(choixSite).ville); new_line;
    put("Avec comme responsable l'employe "); put(chefProdSiteEnCours, 1); put(" : "); afficherTexte(regPersonnel(chefProdSiteEnCours).nom); put(" "); afficherTexte(regPersonnel(chefProdSiteEnCours).prenom); new_line;
    new_line;
    put_line("Vous confirmer ?");
    saisieBoolean(choixBool);

    if choixBool then
      -- toutes les condition sont validees -> association des varaibles
      regPersonnel(chefProdSiteEnCours).nbProduit := regPersonnel(chefProdSiteEnCours).nbProduit-1;
      for i in regMedicament(choixMedicament).chefProd'range loop
        if regMedicament(choixMedicament).chefProd(i).libre = false and then regMedicament(choixMedicament).chefProd(i).nuEmpolye = chefProdSiteEnCours then
          regMedicament(choixMedicament).chefProd(i).libre := true;
        end if;
      end loop;


      --verification si il n'y a plus de chef de prod -> le medicament n'est plus en production
      for i in regMedicament(choixMedicament).chefProd'range loop
        if regMedicament(choixMedicament).chefProd(i).libre = false then
          toujoursEnProd := true;
          exit;
        end if;
      end loop;

      if toujoursEnProd = false then
        regMedicament(choixMedicament).EnProd := false;
      end if;

      choixQuitter:=TRUE;

    else
      put_line("Arret de  production annulee");
      put_line("Voulez-vous recommencer ?");
      saisieBoolean(choixBool);
      if choixBool = false then
        exit;
      end if;
    end if;

    if choixQuitter then
      exit;
    end if;

  end loop;

end arretDeProduction;

-----------------------------------------------------------------------------------

procedure nouveauMedicament(regMedicament : in out T_registreMedicament; regPersonnel : in out T_registrePersonnel; regSite : in T_registreSite) is
  registreLibre : boolean := false;
  nomMed : T_mot := (others=>' ');
  categorieMed : T_categorie;
  nuTypePatient : integer := 0;
  typePatientMed : T_typePatient;
  choixBool : boolean;
  respRetDMed : integer;
  choixQuitter : boolean := false;
  existeDejaTTpublic, existeDejaAdulte, existeDejaPediatrique: boolean := false;


begin -- nouveauMedicament

  for i in regMedicament'range loop  -- verification de la saturation du registre
    if regMedicament(i).libre then
      registreLibre := true;
      exit;
    end if;
  end loop;

  if registreLibre then
    loop -- boucle de confirmation

      if choixQuitter then
        exit;
      end if;

      -- gesiton du nom mediament, verifie si il n'y a pas un medicament qui a le meme nom et donc vérifier la catégorie

        put_line("Veuillez saisir le nom du nouveau medicament :");
        saisieString(nomMed);

        for i in regMedicament'range loop
          if regMedicament(i).nom = nomMed then
            if regMedicament(i).typePatient = ttPublic then
              existeDejaTTpublic := true;
              exit;
            end if;

            if regMedicament(i).typePatient = adulte then
              existeDejaAdulte := true;
            end if;

            if regMedicament(i).typePatient = pediatrique then
              existeDejaPediatrique := true;
            end if;

          end if;
        end loop;


        if existeDejaTTpublic then
          put_line("Un mediament sous ce nom existe deja pour le tout publique, vous ne pouvez pas ajouter une autre forme");
          choixQuitter := true;
        end if;

        if existeDejaAdulte and existeDejaPediatrique then
          put_line("Ce medicament existe deja sous la forme pediatrique et adulte, il est impossible d'ajouter une autre forme");
          choixQuitter := true;
        end if;

        if existeDejaAdulte and existeDejaPediatrique = false then
          put_line("Ce medicament existe deja sous la forme adulte, vous ne pouvez que l'ajouter sous la forme pediatrique");
          choixQuitter := desirQuitter;
        end if;

        if existeDejaAdulte = false and existeDejaPediatrique then
          put_line("Ce medicament existe deja sous la forme pediatrique, vous ne pouvez que l'ajouter sous la forme adulte");
          choixQuitter := desirQuitter;
        end if;

      if choixQuitter then
        exit;
      end if;


      -- saisie de la categorie si nouveau mediament si non on reprends la categorie de l'autre medicament deja present dans le registre
      -- Saisie du type de patient pour ce medicmant ou automatique si l'autre est deja present

      if existeDejaAdulte or existeDejaPediatrique then
        for i in regMedicament'range loop
          if regMedicament(i).nom = nomMed then
            categorieMed := regMedicament(i).categorie;

            if regMedicament(i).typePatient = adulte then -- copie du type patient sur nouveau mediament
              typePatientMed := pediatrique;
            else
              typePatientMed := adulte;
            end if;

            --vérifier que le resp peut encore etre à la charge d'un produit en plus
            if regPersonnel(regMedicament(i).respRecherche).nbProduit = MaxProdCh then
              put_line("Le responsable de recherche qui gere ce produit a atteint le nombre maximal de produit a charge simultanement");
              choixQuitter:=true;
            else
              respRetDMed := regMedicament(i).respRecherche; -- copie du numero employe du resp recherche de l'autre mediament
            end if;


            exit;
          end if;
        end loop;

      else -- si nouveau mediament non connu dans le registre
        saisieCategorie(categorieMed); new_line;

        -- saisie du type de patient via petit menu
        put_line("Pour quel type de patient est ce medicament (saisir le nombre) :");
        put_line("1 - TOUT PUBLIC");
        put_line("2 - ADULTE UNIQUEMENT");
        put_line("3 - PEDIATRIQUE UNIQUEMENT");
        new_line;
        saisieInteger(1, 3, nuTypePatient);

        case nuTypePatient is
          when 1 => typePatientMed := ttPublic;
          when 2 => typePatientMed := adulte;
          when 3 => typePatientMed := pediatrique;
          when others => null; -- ne peut pas arriver car forcement un int entre 1 et 3
        end case;

        loop -- saisie d'un responsable de recherche
          if choixQuitter then
            exit;
          end if;

          put_line("Quel est le numero du responsable de recherche de ce mediament ?");
          put_line("Voulez-vous voir le registre des personnels ? ");
          saisieBoolean(choixBool);
          if choixBool then
            VisualisationPersonnel(regPersonnel, regSite);
            new_line;
            put_line("Quel sera le numero du chef de production pour ce medicament ?");
          end if;
          saisieInteger(1, MaxEmp, respRetDMed);

          if regPersonnel(respRetDMed).RetD = false then
            put_line("Ce personnel n'est pas un responsable de recherche");
            choixQuitter:=desirQuitter;
          else
            --vérifier que le resp peut encore etre à la charge d'un produit en plus
            if regPersonnel(respRetDMed).nbProduit = MaxProdCh then
              put_line("Ce personnel a atteint le nombre maximal de produit a charge simultanement");
              choixQuitter:=desirQuitter;
            else
              exit;
            end if;
          end if;
        end loop;

      end if;

      if choixQuitter then
        exit;
      end if;

      -- Confirmation
      put("Vous voulez ajouter un mediament "); afficherTexte(nomMed); put(" de categorie "); put(T_categorie'image(categorieMed)); new_line;
      put("Pour le type patient ");
      case typePatientMed is
        when ttPublic => put("TOUT PUBLIC");
        when adulte => put("ADULTE UNIQUEMENT");
        when pediatrique => put("PEDIATRIQUE UNIQUEMENT");
      end case;
      new_line;
      put("Le responsable de recherche est "); afficherTexte(regPersonnel(respRetDMed).nom); put(" "); afficherTexte(regPersonnel(respRetDMed).prenom); new_line;
      put("Sur le site numero "); put(regPersonnel(respRetDMed).site, 1); put(" - "); afficherTexte(regSite(regPersonnel(respRetDMed).site).ville); new_line;
      put_line("Le medicament que vous ajouter est en phase de recherche");

      new_line;
      put_line("Vous confirmer ?");
      saisieBoolean(choixBool);

      if choixBool then
        -- toutes les condition sont validees -> association des varaibles dans le registre
        for i in regMedicament'range loop
          if regMedicament(i).libre then
            regMedicament(i).nom := nomMed;
            regMedicament(i).categorie := categorieMed;
            regMedicament(i).typePatient := typePatientMed;
            regMedicament(i).AMM := false;
            regMedicament(i).EnProd := false;
            regMedicament(i).respRecherche := respRetDMed;
            regPersonnel(respRetDMed).nbProduit := regPersonnel(respRetDMed).nbProduit +1;
            regMedicament(i).libre := false;
            choixQuitter:=true;
            exit;
          end if;
        end loop;

      else
        choixQuitter:=desirQuitter;
      end if;

      if choixQuitter then
        exit;
      end if;

    end loop; -- fin boucle confirmation

  else
    put_line("Registre medcaments sature, ajout impossible");
  end if;

end nouveauMedicament;

-----------------------------------------------------------------------------------

procedure supressionMedicament(regMedicament : in out T_registreMedicament; regPersonnel : in out T_registrePersonnel; regSite : in T_registreSite) is
  choixBool : boolean := false;
  choixQuitter : boolean := false;
  choixMedicament : integer := 0;
  estEnProd : boolean := false;
  choixArretProd : boolean := false;

begin -- supressionMedicament
  -- choix de mediament
    -- vérifier qu'il existe
    -- vérifier si il est en prod (ce med est encore en prod sur les sites : )-> arret prod automatique ?
  loop -- boucle de confirmation
    loop --boucle saisie medciament
      put_line("Quel est le numero du medicament a supprimer ?");
      put_line("Vous vous voir le registre des medicaments ?");
      saisieBoolean(choixBool);
      if choixBool then
        VisualtisationMedicament(regMedicament, regPersonnel, regSite);
        new_line;
        put_line("Quel est le numero du medicament a supprimer ?");
      end if;
      saisieInteger(1, maxMed, choixMedicament);

      if regMedicament(choixMedicament).libre = false then
        estEnProd := regMedicament(choixMedicament).EnProd;
        exit;

      else
        put_line("Ce medicament n'est pas dans le registre");
        choixQuitter := desirQuitter;
      end if;

      if choixQuitter then
        exit;
      end if;

    end loop; --boucle saisie medciament

    if choixQuitter then
      exit;
    end if;

    -- si le mediament est toujours en production
    if estEnProd then
      put_line("Ce mediament est encore en production, voulez vous arreter le(s) chaine(s) de produciton automatiquement?");
      saisieBoolean(choixBool);
      if choixBool then
        choixArretProd := true;

      else
        put_line("Refus d'arret de(s) chaine(s) de production -> suppression impossible ");
        choixQuitter := true;
        exit;
      end if;

      if choixQuitter then
        exit;
      end if;

    end if;

    if choixQuitter then
      exit;
    end if;


    -- Confirmation
    put("Vous voulez supprimer le medicament "); afficherTexte(regMedicament(choixMedicament).nom); put(" de categorie "); put(T_categorie'image(regMedicament(choixMedicament).categorie)); new_line;
    put("Pour le type patient ");
    case regMedicament(choixMedicament).typePatient is
      when ttPublic => put("TOUT PUBLIC");
      when adulte => put("ADULTE UNIQUEMENT");
      when pediatrique => put("PEDIATRIQUE UNIQUEMENT");
    end case;
    new_line;

    if estEnProd and choixArretProd then
      put("Qui est en produciton sur le(s) site(s) : ");
      for i in regMedicament(choixMedicament).chefProd'range loop
        if regMedicament(choixMedicament).chefProd(i).libre = false then
          put(regPersonnel(regMedicament(choixMedicament).chefProd(i).nuEmpolye).site, 1);
          put(" - ");
          afficherTexte(regSite(regPersonnel(regMedicament(choixMedicament).chefProd(i).nuEmpolye).site).ville);
          put(" ");
        end if;
      end loop;
      new_line;
      put_line("Avec un arret de(s) chaine(s) de production automatique");
    end if;

    new_line;
    put_line("Vous confirmer ?");
    saisieBoolean(choixBool);

    if choixBool then
      -- supression
      if estEnProd and choixArretProd then
        for i in regMedicament(choixMedicament).chefProd'range loop
          if regMedicament(choixMedicament).chefProd(i).libre = false then
            regPersonnel(regMedicament(choixMedicament).chefProd(i).nuEmpolye).nbProduit := regPersonnel(regMedicament(choixMedicament).chefProd(i).nuEmpolye).nbProduit -1;
            regMedicament(choixMedicament).chefProd(i).libre := true;
          end if;
        end loop;
      end if;

      regPersonnel(regMedicament(choixMedicament).respRecherche).nbProduit := regPersonnel(regMedicament(choixMedicament).respRecherche).nbProduit -1;

      regMedicament(choixMedicament).nom := (others => ' ');
      regMedicament(choixMedicament).AMM := False;
      regMedicament(choixMedicament).EnProd := false;
      regMedicament(choixMedicament).libre := true;

      choixQuitter := true;
      exit;

    else
      put_line("Suppression annulee");
      choixQuitter := desirQuitter;

    end if;


    if choixQuitter then
      exit;
    end if;



  end loop; -- boucle de confirmation

end supressionMedicament;














end Gestion_Medicament;
