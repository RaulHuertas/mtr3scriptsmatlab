function [n] = safetyFactor_Soderberg(sigma_alt, sigma_mid, Se, Sy)
%UNTITLED13 Summary of this function goes here
%   Detailed explanation goes here
arguments (Input)
    sigma_alt
    sigma_mid
    Se
    Sy
end

arguments (Output)
    n
end


%matlab simbolico
syms FS;

equation = (sigma_alt/Se)+ (sigma_mid/Sy)== 1/FS;

all_solutions = solve(equation);

%extraer la solución positiva
n = max(all_solutions);

end