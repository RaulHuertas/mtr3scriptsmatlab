function [result] = vonMosesAlt(Kfbend,Kfaxial,Kftorsion,sigmaBend, sigmaAxial, sigmaTorsion)
%shigley formula 6-55, pág 326
sb = Kfbend * sigmaBend;
sa = Kfaxial * sigmaAxial;
st = Kftorsion * sigmaTorsion;

%terminos de flexion y axiales se suman antes de elevarse al cuadrado
s_n = sb + (sa/0.85);

%Combinacion final
result = sqrt(s_n^2 + 3*(st^2));


end