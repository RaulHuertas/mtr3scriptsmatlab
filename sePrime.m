% recibe argumentos  en Pascal
% shigley pag 290
function [result] = sePrime(Sut)
arguments (Input)
    Sut
end

arguments (Output)
    result
end

mpa = Sut/1e+6


if mpa<1400
    result = 0.5*Sut;
else
    result = 700e+06;
end