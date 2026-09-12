function result = fatigaEje(params)
% Llamar esta función como:
%   result = fatigue_axis_analysis(params)
% Entradas (fields of params struct):
%   params.d                - shaft diameter (m)
%   params.L                - shaft length (m) (used for moment calc if needed)
%   params.Mt               - alternating bending moment magnitude (N*m)
%   params.Mm               - mean bending moment magnitude (N*m)
%   params.Tt               - alternating torsional moment magnitude (N*m)
%   params.Tm               - mean torsional moment magnitude (N*m)
%   params.sigma_y         - yield strength (Pa)
%   params.sigma_uts       - ultimate tensile strength (Pa)
%   params.surface_finish  - one of {'ground','machined','hot-rolled','as-forged'}
%   params.loading_type    - 'bending','torsion','combined' (affects von Mises)
%   params.temperature     - temperature in Celsius (optional, default 20)
%   params.reliability     - reliability fraction (e.g., 0.99) (optional, default 0.99)
%   params.surface_factor  - optional user-defined surface factor Kf (overrides computed)
%   params.size_factor     - optional user-defined size factor Ks (overrides computed)
%   params.rr_factor       - optional user-defined reliability factor Kr (overrides computed)
%   params.factor_for_safety - desired safety factor for static/yield check (optional)
%
% Outputs (result struct):
%   result.se_nominal      - nominal alternating stress (Pa)
%   result.se_equiv        - equivalent fully reversed endurance limit Se (Pa)
%   result.k_surface       - computed surface finish factor
%   result.k_size          - computed size factor
%   result.k_reliability   - computed reliability factor
%   result.k_other         - product of other modifiers (set to 1 if none)
%   result.endurance_limit - corrected endurance limit Se_corrected (Pa)
%   result.vonmises_alt    - von Mises alternating stress amplitude (Pa)
%   result.vonmises_mean   - von Mises mean stress (Pa)
%   result.in_endurance    - boolean: true if in endurance region for infinite life
%   result.safety_factor   - fatigue safety factor (S >1 safe)
%   result.notes           - cell array with short computation notes
%
% Notes:
%   - Uses modified Goodman for mean stress correction.
%   - Uses typical empirical factors for steel endurance limit:
%       Se' = 0.5 * UTS for steels with UTS < ~1400 MPa (commonly used)
%   - Surface finish factor k_a per Peterson/ASN approximations.
%   - Size factor k_b depends on diameter.
%   - Reliability factor k_c based on normal distribution approximate factors.
%   - von Mises used to combine bending and torsion: sqrt(sigma^2 + 3*tau^2)
%
% Example params minimal required fields:
%   params.d = 0.02; params.Mt = 100; params.Mm = 0; params.Tt = 0; params.Tm = 0;
%   params.sigma_uts = 600e6; params.sigma_y = 350e6; params.surface_finish='machined';
%
% Author: Generated MATLAB function
%
arguments
    params struct
end

% Required fields check
req = {'d','Mt','Mm','Tt','Tm','sigma_uts','sigma_y','surface_finish','loading_type'};
for k=1:numel(req)
    if ~isfield(params,req{k})
        error('Missing required field params.%s',req{k});
    end
end

% Defaults
if ~isfield(params,'temperature'), params.temperature=20; end
if ~isfield(params,'reliability'), params.reliability=0.99; end
if ~isfield(params,'k_other'), params.k_other=1; end

d = params.d;
Mt = params.Mt;
Mm = params.Mm;
Tt = params.Tt;
Tm = params.Tm;
UTS = params.sigma_uts;
SY = params.sigma_y;
surface = lower(params.surface_finish);
loading_type = lower(params.loading_type);

notes = {};

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

% 3) Determine rotating-bending style endurance limit Se'
% For steels commonly: Se_prime = 0.5*UTS for UTS <= 1400 MPa, else other rules
Se_prime = 0.5 * UTS;
notes{end+1} = sprintf('Se'' (uncorrected) = 0.5*UTS = %.3g Pa', Se_prime);

% 4) Surface finish factor k_a (Peterson approximate)
if isfield(params,'surface_factor')
    k_a = params.surface_factor;
    notes{end+1} = 'Surface factor provided by user.';
else
    switch surface
        case 'ground'
            a = 1.58e-1; b = -0.085;
        case 'machined'
            a = 4.51e-2; b = -0.265;
        case 'hot-rolled'
            a = 3.07e-3; b = -0.718;
        case 'as-forged'
            a = 7.19e-3; b = -0.718;
        otherwise
            a = 4.51e-2; b = -0.265; % default machined
    end
    % k_a = a*(UTS in MPa)^b, so convert UTS to MPa
    k_a = a * (UTS/1e6)^b;
    notes{end+1} = sprintf('Computed surface factor k_a = %.3f', k_a);
end

% 5) Size factor k_b
if isfield(params,'size_factor')
    k_b = params.size_factor;
    notes{end+1} = 'Size factor provided by user.';
else
    % For rotating bending, use diameter d in mm
    d_mm = d*1000;
    if d_mm <= 8
        k_b = 1.0;
    elseif d_mm <= 250
        k_b = 0.879*d_mm^(-0.107); % typical empirical relation
    else
        k_b = 0.6; % lower bound
    end
    notes{end+1} = sprintf('Computed size factor k_b = %.3f', k_b);
end

% 6) Reliability factor k_c (approximate)
if isfield(params,'rr_factor')
    k_c = params.rr_factor;
    notes{end+1} = 'Reliability factor provided by user.';
else
    R = params.reliability;
    % approximate: for 50% ->1, for 90%->0.897, 95%->0.868, 99%->0.814 (empirical)
    if R >= 0.999
        k_c = 0.753;
    elseif R >= 0.99
        k_c = 0.814;
    elseif R >= 0.95
        k_c = 0.868;
    elseif R >= 0.90
        k_c = 0.897;
    else
        k_c = 1.0;
    end
    notes{end+1} = sprintf('Computed reliability factor k_c = %.3f for R=%.3f', k_c, R);
end

k_other = params.k_other;

% 7) Combined endurance limit
Se_corrected = Se_prime * k_a * k_b * k_c * k_other;
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