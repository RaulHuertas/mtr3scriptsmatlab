function SF = calculate_weld_safety_factor(F, theta_deg, L, z, d_eje, d_soporte, f_u,beta_w, gamma_M2)
    d = sqrt((d_eje*d_eje+d_soporte*d_soporte)/2);
    % --- SECTION PROPERTIES CALCULATIONS ---
    a   = z / sqrt(2);           % Throat thickness (mm)
    A_w = pi * d * a;            % Area of the weld ring (mm^2)
    W_w = (pi * d^2 * a) / 4;    % Section modulus of the weld ring (mm^3)
    J_w = (pi * d^3 * a) / 4;    % Momento polar de inercia (mm^3)

    % --- FORCE RESOLUTION ---
    N = F * cosd(theta_deg);     % Axial compressive force (N)
    V = F * sind(theta_deg);     % Transverse shear force (N)
    M = V * L;                   % Bending moment at the joint (N*mm)

    % --- STRESS CALCULATIONS (Simplified Method) ---
    tau_N  = N / A_w;            % Stress due to axial load (MPa)
    tau_M  = M / W_w;            % Maximum stress due to bending (MPa)
    tau_Ed = tau_N + tau_M;      % Total maximum design stress (MPa)

    % --- DESIGN RESISTANCE ---
    f_vw_d = (f_u / sqrt(3)) / (beta_w * gamma_M2); %%%%% Design shear strength (MPa)

    % --- SAFETY FACTOR ---
    SF = f_vw_d / tau_Ed;

    % Console Output (Optional, can be commented out for silent execution)
    fprintf('Max Applied Stress (tau_Ed): %.2f MPa\n', tau_Ed);
    fprintf('Design Resistance (f_vw_d):  %.2f MPa\n', f_vw_d);
    
    if SF >= 1.0
        fprintf('STATUS: PASS (Safety Factor: %.2f)\n\n', SF);
    else
        fprintf('STATUS: FAIL (Safety Factor: %.2f)\n\n', SF);
    end
end