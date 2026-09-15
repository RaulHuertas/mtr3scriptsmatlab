function [n] = safetyFactor_ASMEElliptic(sigma_alt, sigma_mid, Se, Sy)
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

equation = power(FS*sigma_alt/Se,2)+power(FS*sigma_mid/Sy,2) == 1;

all_solutions = solve(equation);
%fprintf("solve")
%disp(n)
%fprintf("solve end")

n = max(all_solutions);
%extraer la solución positiva

end