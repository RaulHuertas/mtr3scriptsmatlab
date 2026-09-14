function [kc] = factor_kc(tipo_de_carga)
%Shingley pag  298, formula 6-26

kc = 1;

switch tipo_de_carga    
    case 'bending'
        kc = 1;
    case 'axial'
        kc = 0.85;
    case 'torsion'
        kc = 0.59;
        
end

