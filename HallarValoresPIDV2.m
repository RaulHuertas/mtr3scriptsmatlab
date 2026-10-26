close all;
clc;
format SHORTG;
%Se define la función de transferencia del motor SIN su lazo de control
function y = pidController(p,i,d,s)
y = (p+(i/s)+(d*s));
end

s = tf('s');


factorReductorDeEsfuerzo = 0.5;

partA = 1/(Lm*s+Rm);
partB = 1/(Jeq*s+Bm);
motor = feedback(partA*partB,Kb)/relacionEngranajes;
disp('Funcion de transferencia del motor:')
disp(motor)
%% Primer bucle, estimaciones iniciales de Ki
%Se define el intervalo de los valores de Ki
rango = 0.00:10:100;
sRango = size(rango);
%Se crea una tabla donde alamcenar resultados
soluciones = zeros(sRango(2), 5);
indice = 1;
%Se realiza la simulación por cada valor de Ki
for Ki = rango
    %Se define la función de transferencia del motor CONs su lazo de control
    
    motorConPIDVelocidad = feedback(Ki*(1)*motor,1);
    resultado = stepinfo(motorConPIDVelocidad);
    %Se almacenan los resultados en las tablas
    soluciones(indice,:) = [    Ki, ...
                                resultado.RiseTime, ...
                                resultado.SettlingTime, ...
                                resultado.Overshoot, ...
                                resultado.Peak ];
    indice = indice+1;

end
disp("Soluciones iniciales(Control Velocidad, bucle 1): ")
disp(soluciones)


%% Soluciones más refinadas 
rango = 11200:100:11600;
sRango2 = size(rango);
%Se crea una tabla donde alamcenar resultados
soluciones2 = zeros(sRango2(2), 5);
indice = 1;
%Se realiza la simulación por cada valor de Ki
for Ki = rango
    %Se define la función de transferencia del motor CONs su lazo de control
    motorConPIDVelocidad = feedback(Ki*(1)*motor,1);
    resultado = stepinfo(motorConPIDVelocidad);
    %Se almacenan los resultados en las tablas
    soluciones2(indice,:) = [    Ki, ...
        resultado.RiseTime, ...
        resultado.SettlingTime, ...
        resultado.Overshoot, ...
        resultado.Peak ];
    indice = indice+1;
end

%Se muestra la tabla de resultados
disp("Soluciones iniciales(Control Velocidad, bucle 2): ")
disp(soluciones2)
csvwrite('PIDVelocidadSim2.csv',soluciones2);
%Se muestra la tabla de resultados
%KiWElegido = 11600;
K_ZG_W_Elegido = 80.0;
T_ZG_W_Elegido = (0.0182-0.00621);
P_W =  0.6*K_ZG_W_Elegido*factorReductorDeEsfuerzo;
I_W =  0.5*T_ZG_W_Elegido*0;
D_W = 0.12*T_ZG_W_Elegido*0;
figure(1)
step(feedback(K_ZG_W_Elegido*(1)*motor,1),10)

motorConPIDVelocidad = feedback(pidController(P_W,I_W,D_W,s)*motor,1);
figure(2)
step(motorConPIDVelocidad, 10)




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%CONTROL DE POSICION
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Control de posición, bucle 1
%KiWElegido = 12220;

rango = 0.1:10:100;
sRangoPos1 = size(rango);
indice = 1;
solucionesPos1 = zeros(sRangoPos1(2), 5);
for KposCr = rango
    %Se define la función de transferencia de la planta CONs su lazo de 
    %control
    motorConPIDPosicion = feedback(KposCr*motorConPIDVelocidad*(1/s), 1);
    resultado = stepinfo(motorConPIDPosicion);
    %Se almacenan los resultados en las tablas
    solucionesPos1(indice,:) = [    KposCr, ...
                                resultado.RiseTime, ...
                                resultado.SettlingTime, ...
                                resultado.Overshoot, ...
                                resultado.Peak ];
    indice = indice+1;
end
disp("Soluciones iniciales(Control Posicion, bucle 1): ")
disp(solucionesPos1);
csvwrite('PIDPosiciónSim1.csv',solucionesPos1);


%% Control de posición, bucle 2
%rango = 40:0.5:50;
rango = 16:0.25:19;
sRangoPos2 = size(rango);
indice = 1;
solucionesPos2 = zeros(sRangoPos2(2), 5);
for KposCr = rango
    %Se define la función de transferencia de la planta CONs su lazo de 
    %control
    motorConPIDPosicion = feedback(KposCr*motorConPIDVelocidad*(1/s), 1);
    resultado = stepinfo(motorConPIDPosicion);
    %Se almacenan los resultados ean las tablas
    solucionesPos2(indice,:) = [    KposCr, ...
                                resultado.RiseTime, ...
                                resultado.SettlingTime, ...
                                resultado.Overshoot, ...
                                resultado.Peak ];
    indice = indice+1;
end
disp("Soluciones iniciales(Control Posicion, bucle 2): ")
disp(solucionesPos2)
csvwrite('PIDPosiciónSim2.csv',solucionesPos2);

%% Simulacion PID posición
%KCriticaPosicion = 17.5;
KCriticaPosicion = 327.5;

%KiWElegido = 11600;
K_ZG_Pos_Elegido = 500.5;
T_ZG_Pos_Elegido = (0.0255-0.0115);
P_Pos =  0.6*K_ZG_Pos_Elegido*factorReductorDeEsfuerzo;
I_Pos =  0.5*T_ZG_Pos_Elegido*0;
D_Pos = 0.12*T_ZG_Pos_Elegido*0;
motorConPIDPosicionFinal = feedback(pidController(P_Pos,I_Pos,D_Pos,s)*motorConPIDVelocidad*(1/s), 1);
figure(3);
step(feedback(K_ZG_Pos_Elegido*motorConPIDVelocidad*(1/s), 1), 3)
figure(4);
step(motorConPIDPosicionFinal, 3)
resultadoFinal = stepinfo(motorConPIDPosicionFinal);



%Calculos coeficientes del PID
disp("Valores criticos control de velocidad: ")
disp(K_ZG_W_Elegido)
disp(T_ZG_W_Elegido)
disp("Coeficientes PID de velocidad: ")
disp(P_W)
disp(I_W)
disp(D_W)
disp("Valores criticos control de posición: ")
disp(K_ZG_Pos_Elegido)
disp(T_ZG_Pos_Elegido)
disp("Coeficientes del PID de posición: ")
disp(P_Pos)
disp(I_Pos)
disp(D_Pos)
disp("Tiempo de subida final: ")
disp(resultadoFinal.RiseTime)
disp("Planta final: ")
disp(motorConPIDPosicionFinal)

polosFinales = pole(motorConPIDPosicionFinal);
disp(polosFinales)
if isstable(motorConPIDPosicionFinal)
    disp('The system is stable');
else
    disp('The system is unstable');
end

%% Funciones Ziegher Nichols
function y = znHallarKPOfPController(KCr)
    y = 0.5*KCr;
end


function [P,I] = znHallarKPIOfPIController(KCr, Tcr)
    P = 0.45*KCr;
    I = 0.45*Tcr;
end

