clc
clear
close all

% Ejemplo de invocación de la función 'fatigaEje' usando parámetros del acero AISI 1045
% Suposiciones comunes para AISI 1045 (valores típicos; ajustar según fuente):
Sut = 630e+06;    % Resistencia última a tracción [Pa] 
Sy  = 530e+06;   % Límite elástico [Pa] (0.5 obtenido de shingley)
E   = 200e9;    % Módulo de Young [Pa]

% Parámetros de carga/geométricos de ejemplo (ajustar según la firma de fatigaEje):
% Aquí se asumen nombres de parámetros típicos: M_a (momento alternante), M_m (momento medio),
% d (diámetro del eje), kf (factor de concentración de la forma), ka/kb/... (factores de modificación).
M_a = 89.3775;      % Momento flector alternante [N·m]
M_m = 0;       % Momento medio [N·m]
T_a = 260.576 ; % Torque alternante [N·m]
T_m = 0 ; % Torque 0[N·m]
d   = 50*0.001;     % Diámetro del eje [m]
D = 60*0.001;
kf  = 1.0;      % Factor de concentración de la forma (ejemplo)
kmisc  = 1.0;      % Factor de concentración de la forma (ejemplo)
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
params.D   = D;
params.kf  = kf;
%params.ka = ka; 
%params.kb = kb; 
%params.kc = kc; 
%params.kd = kd; 
%params.ke = ke; 
params.kf = kf; 
params.kmisc = kmisc; 
params.Malt = M_a;
params.Mm = M_m;
params.Talt = T_a;
params.Tm = T_m;
params.Ne = 1e+06; %Queremos operar en la región que no hay fatiga(endurancej)
params.temperature = 25;
params.user_weight = 150;
params.jump_factor = 3;%Al saltar, un atleta pone hasta 3 veces su peso sobre la superficie en la que salta
params.shoulder_r = 5/1000; %Fillet en los hombros de los extremos del eje, para cálculo de kt y ks
params.reliability = reliabilidad;
params.kt_tension = 1.5;%Shingley tabla A-15
params.kt_torsion = 1.35;%Shingley tabla A-15
params.kt_bending = 1.65;%Shingley tabla A-15

params.q_bending = 0.9;%Shingley tabla A-20. Puede usarse también para tracción/cargas axiales
params.q_torsion = 0.9;%Shingley tabla A-21

% Llamada a la función (ajustar según la firma real de fatigaEje)
% Suponiendo que fatigaEje devuelve un struct 'result' con campos como 'Nf' (vida en ciclos) y 'SF' (factor de seguridad)
result = fatigaEje(params);

% Mostrar resultados
disp('Resultados de fatigaEje para AISI 1045, ASME Elliptic:');
disp(result);