function SF = calculate_weld_safety_factor_directional(F, theta_deg, L, z, d_eje, d_soporte, f_u,beta_w, gamma_M2)
    d = sqrt((d_eje*d_eje+d_soporte*d_soporte)/2);


    % --- SECTION PROPERTIES CALCULATIONS ---
    a   = z / sqrt(2);           % Throat thickness (mm)
    A_w = pi * d * a;            % Area of the weld ring (mm^2)
    W_w = (pi * d^2 * a) / 4;    % Section modulus of the weld ring (mm^3)

    % --- FORCE RESOLUTION ---
    N = F * cosd(theta_deg);     % Axial compressive force (N)
    V = F * sind(theta_deg);     % Transverse shear force (N)
    M = V * L;                   % Bending moment at the joint (N*mm)

    % --- NOMINAL STRESS AT EXTREME FIBER ---
    sigma_nom = (N / A_w) + (M / W_w); 

    % --- DIRECTIONAL STRESS RESOLUTION (45-degree fillet) ---
    sigma_perp   = sigma_nom / sqrt(2);
    tau_perp     = sigma_nom / sqrt(2);
    tau_parallel = 0; % Zero at the extreme bending fiber

    % --- VON MISES EQUIVALENT STRESS ---
    sigma_VM = sqrt(sigma_perp^2 + 3*(tau_perp^2 + tau_parallel^2));

    % --- DESIGN LIMITS (EN 1993-1-8 Sec 4.5.3.2) ---
    f_vw_d_VM        = f_u / (beta_w * gamma_M2);  % Primary limit
    sigma_perp_limit = (0.9 * f_u) / gamma_M2;     % Secondary limit

    % --- SAFETY FACTOR ---
    % The safety factor is governed by the most critical of the two checks
    SF_VM   = f_vw_d_VM / sigma_VM;
    SF_perp = sigma_perp_limit / sigma_perp;
    SF      = min(SF_VM, SF_perp);

    % --- CONSOLE OUTPUT ---
    fprintf('Directional Stresses: sigma_perp = %.2f MPa, tau_perp = %.2f MPa\n', sigma_perp, tau_perp);
    fprintf('Von Mises Applied Stress (sigma_VM): %.2f MPa\n', sigma_VM);
    fprintf('Design Limit (f_vw_d_VM):            %.2f MPa\n', f_vw_d_VM);
    
    if SF >= 1.0
        fprintf('STATUS: PASS (Safety Factor: %.2f)\n\n', SF);
    else
        fprintf('STATUS: FAIL (Safety Factor: %.2f)\n\n', SF);
    end
end