% 1. Define the applied load and joint geometry
F         = 168*9.8;    % Applied downward load in Newtons (1500 N ~ 150 kg)
theta_deg = 9;      % Angle of the tube relative to vertical in degrees
L         = 971.536;     % Lever arm distance from pivot to the load application point in mm
z         = 4.5;     % Weld leg size in mm
d_eje         = 44.45;   % Tube outer diameter in mm
d_soporte     = 50.00;   % Tube outer diameter in mm
f_u       = 630;     % Ultimate tensile strength of AISI 1045 base metal in MPa
 % Eurocode Constants
beta_w    = 1.0;     % Correlation factor for high-strength steel
gamma_M2  = 1.25;    % Partial safety factor for welds
% 2. Call the function and assign the output to a variable
SF = calculate_weld_safety_factor_directional(F, theta_deg, L, z, d_eje,d_soporte,  f_u,beta_w, gamma_M2);

% 3. Evaluate the returned Safety Factor for further program logic
if SF >= 1.5
    disp('Result: The weld is exceptionally safe for this load.');
elseif SF >= 1.0
    disp('Result: The weld meets Eurocode 3 static strength requirements, but margin is low.');
else
    disp('Result: WARNING - The weld is expected to fail. Redesign required.');
end