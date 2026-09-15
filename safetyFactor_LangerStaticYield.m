function [n] = safetyFactor_LangerStaticYield(sigma_alt, sigma_mid, Se, Sy)
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

equation = sigma_alt+ sigma_mid== Sy/FS;

all_solutions = solve(equation);
%fprintf("solve")
%disp(n)
%fprintf("solve end")

n = max(all_solutions);
%extraer la solución positiva

end