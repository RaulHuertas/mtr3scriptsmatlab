clc
clear
close all

% Ejemplo de invocación de la función 'fatigaEje' usando parámetros del acero AISI 1045
% Suposiciones comunes para AISI 1045 (valores típicos; ajustar según fuente):
Sut = 725e6;    % Resistencia última a tracción [Pa] 
Sy  = Sut*0.5;    % Límite elástico [Pa] (0.5 obtenido de shingley)
E   = 200e9;    % Módulo de Young [Pa]

% Parámetros de carga/geométricos de ejemplo (ajustar según la firma de fatigaEje):
% Aquí se asumen nombres de parámetros típicos: M_a (momento alternante), M_m (momento medio),
% d (diámetro del eje), kf (factor de concentración de la forma), ka/kb/... (factores de modificación).
M_a = 93.4973;      % Momento alternante [N·m]
M_m = 0;       % Momento medio [N·m]
T_a = 260.576 ; % Torque alternante [N·m]
T_m = 0 ; % Torque 0[N·m]
d   = 50*0.001;     % Diámetro del eje [m]
kf  = 1.0;      % Factor de concentración de la forma (ejemplo)
ka  = 1.0; kb = 1.0; kc = 1.0; kd = 1.0; ke = 1.0; % factores de Marin/others
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
params.kf  = kf;
params.ka = ka; 
params.kb = kb; 
params.kc = kc; 
params.kd = kd; 
params.ke = ke; 
params.Mt = M_a;
params.Mm = M_m;
params.Tt = M_m;
params.Tm = T_m;
paramas.Ne = 1e+07; %Queremos operar en la región que no hay fatiga(endurancej)
params.temperature = 25;

params.reliability = reliabilidad;
% Llamada a la función (ajustar según la firma real de fatigaEje)
% Suponiendo que fatigaEje devuelve un struct 'result' con campos como 'Nf' (vida en ciclos) y 'SF' (factor de seguridad)
result = fatigaEje(params);

% Mostrar resultados
disp('Resultados de fatigaEje para AISI 1045, ASME Elliptic:');
disp(result);