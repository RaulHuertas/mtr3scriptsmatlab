% Ejemplo de invocación de la función 'fatigaEje' usando parámetros del acero AISI 1045
% Suposiciones comunes para AISI 1045 (valores típicos; ajustar según fuente):
Sut = 725e6;    % Resistencia última a tracción [Pa] (~585 MPa)
Sy  = Sut*0.5;    % Límite elástico [Pa] (~310 MPa)
E   = 200e9;    % Módulo de Young [Pa]
%rho = 7850;     % Densidad [kg/m^3] (si la función lo requiere)

% Parámetros de carga/geométricos de ejemplo (ajustar según la firma de fatigaEje):
% Aquí se asumen nombres de parámetros típicos: M_a (momento alternante), M_m (momento medio),
% d (diámetro del eje), kf (factor de concentración de la forma), ka/kb/... (factores de modificación).
M_a = 93.4973;      % Momento alternante [N·m]
M_m = 0;       % Momento medio [N·m]
T_m = 260.576 ; % Momento medio [N·m]
d   = 50*0.001;     % Diámetro del eje [m]
kf  = 1.0;      % Factor de concentración de la forma (ejemplo)
ka  = 1.0; kb = 1.0; kc = 1.0; kd = 1.0; ke = 1.0; kf_mod = 1.0; % factores de Marin/others

% Construir estructura o lista de parámetros según la interfaz de fatigaEje
params.sigma_uts = Sut;
params.sigma_y = Sy;
params.surface_finish = 'machined';
params.loading_type = 'combined';
params.E   = E;
params.rho = rho;
params.d   = d;
params.kf  = kf;
params.ka = ka; params.kb = kb; params.kc = kc; params.kd = kd; params.ke = ke; params.kf_mod = kf_mod;
params.Mt = M_a;
params.Mm = M_m;
params.Tt = M_m;
params.Tm = T_m;
% Llamada a la función (ajustar según la firma real de fatigaEje)
% Suponiendo que fatigaEje devuelve un struct 'result' con campos como 'Nf' (vida en ciclos) y 'SF' (factor de seguridad)
result = fatigaEje(params);

% Mostrar resultados
disp('Resultados de fatigaEje para AISI 1045:');
disp(result);