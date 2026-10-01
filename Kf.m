function [result] = Kf(q, Kt)
%UNTITLED9 Summary of this function goes here
%   Detailed explanation goes here
arguments (Input)
    q
    Kt
end

arguments (Output)
    result
end
%Shigley, fórmula 6-32
result = 1+q*(Kt-1);

end