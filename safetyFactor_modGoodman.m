function [n] = safetyFactor_modGoodman(sigma_alt, sigma_mid, Se, Sut)
%UNTITLED13 Summary of this function goes here
%   Detailed explanation goes here
arguments (Input)
    sigma_alt
    sigma_mid
    Se
    Sut
end

arguments (Output)
    n
end


%matlab simbolico
syms FS;

equation = (sigma_alt/Se)+ (sigma_mid/Sut)== 1/FS;

all_solutions = solve(equation);

%extraer la solución positiva
n = double(max(all_solutions));

end