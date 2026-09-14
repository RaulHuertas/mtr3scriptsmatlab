


% Llamar esta función como:
%   result = fatigue_axis_analysis(params)
function result = fatigaEje(params)


arguments
    params struct
end

% Revisar que los parámetros más importantes hayan sido especificados
req = {'d','Malt','Mm','Talt','Tm','sigma_uts','sigma_y','surface_finish','loading_type'};
for k=1:numel(req)
    if ~isfield(params,req{k})
        error('Missing required field params.%s',req{k});
    end
end

% Defaults
if ~isfield(params,'temperature'), params.temperature=25; end
if ~isfield(params,'reliability'), params.reliability=0.99; end

d = params.d;
surface = lower(params.surface_finish);

% 1)  factor de Marin k_a(Superficie)

%valores Shigles pág 296, tabla 6-2
switch surface
    case 'ground'
        a = 1.58; b = -0.085;
    case 'machined'
        a = 4.51; b = -0.265;
    case 'hot-rolled'
        a = 57.7; b = -0.718;
    case 'as-forged'
        a = 272; b = -0.995;
    otherwise
        a = 4.51; b = -0.265; % por defecto se asume que es maquinado
end    
k_a = a * (params.sigma_uts/1e6)^b;


% 2) Factor de Marin k_b(Tamaño)

d_mm = d*1000;
%valores Shigley pág 296, fórmula 6-20
if d_mm <= 254
    k_b = 1.51*power(d_mm,-0.157);
elseif d_mm <= 51
    k_b = 1.24*power(d_mm,-0.107);
else
    k_b = 0.6; % lower bound
end

% 3) Factor de Marin k_c(Carga)
k_c_bending = factor_kc('bending')
k_c_axial = factor_kc('axial')
k_c_torsion = factor_kc('torsion')

% 4) Factor de Marin k_d(temperatura) shigley página 322
k_d = temp_st_ratio(params.temperature);

% 5) Factor de Marin k_e (carga), Shigley's página 324
k_e = 1.0;
if  params.reliability >= 0.999
    k_e = 0.620;
elseif params.reliability >= 0.99
    k_e = 0.814;
elseif params.reliability >= 0.95
    k_e = 0.868;
elseif params.reliability >= 0.90
    k_e = 0.897;
end

% Límite de fatiga Se', para una pieza de laboratorio
Se_prime = sePrime(params.sigma_uts);

% 'Se' ajustado para una pieza real(varial el k_c de cada uno)
Se_bending =    Se_prime*k_a*k_b*k_c_bending*k_d*k_e*params.kf*params.kmisc;
Se_axial =      Se_prime*k_a*k_b*k_c_axial*k_d*k_e*params.kf*params.kmisc;
Se_torsion =    Se_prime*k_a*k_b*k_c_torsion*k_d*k_e*params.kf*params.kmisc;

% Fracción de fuerz de fatiga
%f = params.fatigue_strength_coefficient*power(2*params.Ne,params.fatigue_strength_exponent)/params.sigma_uts;

%constant_a = ((f*params.sigma_uts/1e+06)^2)/Se_prime;
%constant_b = -(log(f*params.sigma_uts/Se_prime))/3;

% De Shigley pag 314:The slope of the load line shown is defined as Sa/Sm

ShaftCrossArea = pi*(d/2)^2;
PMI =  pi*(d^4)/32;%%Polar moment of inertia

%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%Esfuerzos de torsion%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%
torque_stress_alt = params.Talt*(d/2)/PMI;
torque_stress_mid = params.Tm*(d/2)/PMI;

%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%Esfuerzos de flexion%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%
bending_stress_alt = params.Malt*(d/2)/PMI;
bending_stress_mid = params.Mm*(d/2)/PMI;

%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%Esfuerzos axial%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%
%Axial stress, asuming the user puts 3 times its weight 
%on the plataform
g = 9.8;
axial_stress_max = params.user_weight*g*params.jump_factor;
axial_stress_alt = (axial_stress_max-0)/2;
axial_stress_mid = (axial_stress_max+0)/2;

%%Hallar coeficientes de von misses, Shingley tabla A-15
r_over_d = params.shoulder_r/params.d;
D_over_d = params.D/params.d;

%Shigley, Formula 6-34
Kf_tension = Kf(params.q_bending, params.kt_tension);
Kf_torsion = Kf(params.q_torsion, params.kt_torsion);
Kf_bending = Kf(params.q_bending, params.kt_bending);

%Equivalentes segun von mises
vonmises_alt = vonMosesAlt(Kf_bending,Kf_tension,Kf_torsion,bending_stress_alt,axial_stress_alt,torque_stress_alt);
vonmises_mean = vonMosesMean(Kf_bending,Kf_tension,Kf_torsion,bending_stress_mid,axial_stress_mid,torque_stress_mid);

%Shigley pág 326
firstCycle_max_stress = vonmises_alt+vonmises_mean

%safety factor for first cycle(static)
SF_firstCycle = Se_prime/firstCycle_max_stress



% Mostrar valores calculados hasta este punto
notes = {};
fprintf('Sut = %.6g m\n', params.sigma_uts);
fprintf('Sy = %.6g m\n', params.sigma_y);
fprintf('Diameter d = %.6g m\n', d);
fprintf('Surface finish = %s\n', surface);
fprintf('k_a (surfac) = %.6g\n', k_a);
fprintf('k_b (size) = %.6g\n', k_b);
fprintf('k_c bending = %.6g\n', k_c_bending);
fprintf('k_c axial = %.6g\n', k_c_axial);
fprintf('k_c torsion = %.6g\n', k_c_torsion);
fprintf('k_d (temperature) = %.6g\n', k_d);
fprintf('k_e (reliability) = %.6g\n', k_e);
fprintf('Se'' (lab) = %.6g Pa\n', Se_prime);
fprintf('Se bending = %.6g Pa\n', Se_bending);
fprintf('Se axial = %.6g Pa\n', Se_axial);
fprintf('Se torsion = %.6g Pa\n', Se_torsion);
fprintf('Shaft cross-sectional area = %.6g m^2\n', ShaftCrossArea);
fprintf('Polar moment of inertia = %.6g m^4\n', PMI);
fprintf('Torque stress (alt) = %.6g Pa\n', torque_stress_alt);
fprintf('Torque stress (mid) = %.6g Pa\n', torque_stress_mid);
fprintf('Bending stress (alt) = %.6g Pa\n', bending_stress_alt);
fprintf('Bending stress (mid) = %.6g Pa\n', bending_stress_mid);
fprintf('Axial stress (alt) = %.6g Pa\n', axial_stress_alt);
fprintf('Axial stress (mid) = %.6g Pa\n', axial_stress_mid);
fprintf('Shoulder radius ratio r/d = %.6g\n', r_over_d);
fprintf('Shoulder radius ratio D/d = %.6g\n', D_over_d);
fprintf('Kf_tension = %.6g\n', Kf_tension);
fprintf('Kf_torsion = %.6g\n', Kf_torsion);
fprintf('Kf_bending = %.6g\n', Kf_bending);
fprintf('vonmises_alt = %.6g\n', vonmises_alt);
fprintf('vonmises_mean = %.6g\n', vonmises_mean);
fprintf('firstCycle_max_stress = %.6g\n', firstCycle_max_stress);
fprintf('SF_firstCycle = %.6g\n', SF_firstCycle);

return

% 2) Von Mises equivalent stresses (amplitude and mean)
% alternating equivalent (amplitude): sqrt(sigma_b_alt^2 + 3*tau_alt^2)



% 7) Combined endurance limit
Se_corrected = Se_prime * k_a * k_b * k_c * params.kf ;
notes{end+1} = sprintf('Corrected endurance limit Se = %.3g Pa', Se_corrected);

% 8) Mean stress correction using modified Goodman:
% allowable alternating stress Sa such that Sa/Se + Smean/Sut <= 1
Smean = vonmises_mean; % mean von Mises
% Solve for allowable alternating amplitude Sa_all = (1 - Smean/UTS)*Se
Sa_allow = (1 - Smean./UTS) * Se_corrected;
% If Smean > UTS then zero or negative
Sa_allow(Smean >= UTS) = 0;

% Safety factor (fatigue) = Sa_allow / vonmises_alt
% If vonmises_alt ==0 and Sa_allow>0, set safety factor = Inf
sf = zeros(size(vonmises_alt));
sf(vonmises_alt>0) = Sa_allow(vonmises_alt>0) ./ vonmises_alt(vonmises_alt>0);
sf(vonmises_alt==0 & Sa_allow>0) = Inf;
sf(Sa_allow<=0) = 0;

% Endurance region test: vonmises_alt <= Sa_allow
in_endurance = vonmises_alt <= Sa_allow;

% 9) Static safety check (optional)
if isfield(params,'factor_for_safety')
    fac = params.factor_for_safety;
    % compare vonmises_max = vonmises_mean + vonmises_alt to yield/SY
    vonmises_max = vonmises_mean + vonmises_alt;
    if max(vonmises_max) > SY/fac
        notes{end+1} = sprintf('Warning: static safety factor %.2f not met.',fac);
    else
        notes{end+1} = sprintf('Static check passed for factor %.2f.',fac);
    end
end

% Populate result
result.se_nominal = vonmises_alt;
result.se_equiv = Se_prime;
result.k_surface = k_a;
result.k_size = k_b;
result.k_reliability = k_c;
result.k_other = k_other;
result.endurance_limit = Se_corrected;
result.vonmises_alt = vonmises_alt;
result.vonmises_mean = vonmises_mean;
result.in_endurance = in_endurance;
result.safety_factor = sf;
result.notes = notes;

end