clc
clear
close all

% Ejemplo de invocación de la función 'fatigaEje' usando parámetros del acero AISI 1045
% Suposiciones comunes para AISI 1045 (valores típicos; ajustar según fuente):
Sut = 630e+06;    % Resistencia última a tracción [Pa]  ( obtenido de shingley, tabla A-20)
Sy  = 530e+06;   % Límite elástico [Pa] ( obtenido de shingley, tabla A-20)
E   = 200e9;    % Módulo de Young [Pa]

% Parámetros de carga/geométricos de ejemplo (ajustar según la firma de fatigaEje):
% Aquí se asumen nombres de parámetros típicos: M_a (momento alternante), M_m (momento medio),
% d (diámetro del eje), kf (factor de concentración de la forma), ka/kb/... (factores de modificación).
M_a = 243.551;      % Momento flector alternante [N·m]
M_m = 0;       % Momento medio [N·m]
T_a = 712.63 ; % Torque alternante [N·m]
T_m = 0 ; % Torque 0[N·m]
d   = 60*0.001;     % Diámetro del eje [m]
D = 65*0.001;
kf  = 1.0;      % Factor miscelaneo(otros factores)
reliabilidad = 0.99;
% Construir estructura o lista de parámetros según la interfaz de fatigaEje
params.sigma_uts = Sut;
params.sigma_y = Sy;
params.fatigue_strength_coefficient=1225e+06;% shigley tabla A-23 σ'F
params.fatigue_strength_exponent=-0.095;% shigley tabla A-23 'b'
params.surface_finish = 'machined';
params.loading_type = 'combined';
params.E   = E;
params.d   = d;
params.D   = D;
params.kf = kf; 
params.Malt = M_a;
params.Mm = M_m;
params.Talt = T_a;
params.Tm = T_m;
params.Ne = 1e+06; %Queremos operar en la región que no hay fatiga(endurancej)
params.temperature = 25;
params.user_weight = 150;
params.jump_factor = 0;%Al saltar, un atleta pone hasta 3 veces su peso sobre la superficie en la que salta
params.shoulder_r = 5/1000; %Fillet en los hombros de los extremos del eje, para cálculo de kt y ks
params.reliability = reliabilidad;
params.kt_tension = 1.5;%Shingley tabla A-15
params.kt_torsion = 1.35;%Shingley tabla A-15
params.kt_bending = 1.65;%Shingley tabla A-15

params.q_torsion = 0.9;%Shingley figura 6-21
params.q_bending = 0.9;%Shingley figura 6-20. Puede usarse también para tracción/cargas axiales

% Llamada a la función (ajustar según la firma real de fatigaEje)
% Suponiendo que fatigaEje devuelve un struct 'result' con campos como 'Nf' (vida en ciclos) y 'SF' (factor de seguridad)
result = fatigaEje(params);

%%% SOLDADURA
% 1. Define the applied load and joint geometry
F         = 168*9.8;    % Applied downward load in Newtons (1500 N ~ 150 kg)
theta_deg = 9;      % Angle of the tube relative to vertical in degrees
L         = 1007;     % Lever arm distance from pivot to the load application point in mm
z         = 4.5;     % Weld leg size in mm
d_eje         = 44.45;   % Tube outer diameter in mm
d_soporte     = d*1000;   % Tube outer diameter in mm
f_u       = Sut/(1e6);     % Ultimate tensile strength of AISI 1045 base metal in MPa
% Eurocode Constants
beta_w    = 1.0;     % Correlation factor for high-strength steel
gamma_M2  = 1.25;    % Partial safety factor for welds
% 2. Call the function and assign the output to a variable
SFWeld = calculate_weld_safety_factor_directional(F, theta_deg, L, z, d_eje,d_soporte,  f_u,beta_w, gamma_M2);


% Mostrar resultados
disp('Resultados de fatigaEje para AISI 1045, ASME Elliptic:');
disp(result);

disp('Factores de seguridad de soldadura: ')
disp(SFWeld)
if SFWeld >= 1.5
    disp('Weld Result: The weld is exceptionally safe for this load.');
elseif SF >= 1.0
    disp('Weld Result: The weld meets Eurocode 3 static strength requirements, but margin is low.');
else
    disp('Weld Result: WARNING - The weld is expected to fail. Redesign required.');
end
