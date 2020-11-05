package Outils is

  subtype T_mot is string(1..50);

  procedure saisieInteger(bornInf, bornSupp : in integer; nombre : out integer);
  procedure saisieFloat(bornInf, bornSupp : in float; nombre : out float);
  procedure saisieString(texte : out T_mot);
  procedure saisieBoolean(bool : out boolean);

end Outils;
