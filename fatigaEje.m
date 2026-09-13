


% Llamar esta función como:
%   result = fatigue_axis_analysis(params)
function result = fatigaEje(params)


arguments
    params struct
end

% Revisar que los parámetros más importantes hayan sido especificados
req = {'d','Mt','Mm','Tt','Tm','sigma_uts','sigma_y','surface_finish','loading_type'};
for k=1:numel(req)
    if ~isfield(params,req{k})
        error('Missing required field params.%s',req{k});
    end
end

% Defaults
if ~isfield(params,'temperature'), params.temperature=25; end
if ~isfield(params,'reliability'), params.reliability=0.99; end

d = params.d;
Mt = params.Mt;
Mm = params.Mm;
Tt = params.Tt;
Tm = params.Tm;
surface = lower(params.surface_finish);

notes = {};
% 1)  factor de Marin k_a(Superficie)
if isfield(params,'surface_factor')
    k_a = params.surface_factor;
    notes{end+1} = 'Surface factor provided by user.';
else
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
    k_a = a * (UTS/1e6)^b;
    notes{end+1} = sprintf('Computed surface factor k_a = %.3f', k_a);
end

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
notes{end+1} = sprintf('Computed size factor k_b = %.3f', k_b);

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
notes{end+1} = sprintf('Computed reliability factor k_c = %.3f for reliability=%.3f', k_c, params.reliability);

% Límite de fatiga Se'
Se_prime = sePrime(params.params.sigma_ut);

% Fracción de fuerz de fatiga
f = params.fatigue_strength_coefficient*power(2*params.Ne,params.fatigue_strength_exponent);

constant_a = ((fs*params.sigma_uts)^2)/Se_prime
constant_b = -(log(f*params.sigma_uts/Se_prime))



return

% 1) Nominal alternating stresses at outer fiber for circular shaft
% bending stress amplitude: sigma_b = M*c/I, c = d/2, I = pi*d^4/64 -> sigma = 32*M/(pi*d^3)
sigma_b_alt = 32*Mt/(pi*d^3); % alternating bending amplitude
sigma_b_mean = 32*Mm/(pi*d^3);

% torsional shear stress amplitude: tau = 16*T/(pi*d^3)
tau_alt = 16*Tt/(pi*d^3);
tau_mean = 16*Tm/(pi*d^3);

% 2) Von Mises equivalent stresses (amplitude and mean)
% alternating equivalent (amplitude): sqrt(sigma_b_alt^2 + 3*tau_alt^2)
vonmises_alt = sqrt(sigma_b_alt.^2 + 3*tau_alt.^2);
vonmises_mean = sqrt(sigma_b_mean.^2 + 3*tau_mean.^2);


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