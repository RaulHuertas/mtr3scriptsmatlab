close all;
format SHORTG;
%Se define la función de transferencia del motor SIN su lazo de control
s = tf('s');
partA = 1/(Lm*s+Rm);
partB = 1/(Jm*s+Bm);
motor = feedback(partA*partB,Kb)/relacionEngranajes;

%% Primer bucle, estimaciones iniciales de Ki
%Se define el intervalo de los valores de Ki
rango = 0.1:1000:20000;
sRango = size(rango);
%Se crea una tabla donde alamcenar resultados
soluciones = zeros(sRango(2), 5);
indice = 1;
%Se realiza la simulación por cada valor de Ki
for Ki = rango
    %Se define la función de transferencia del motor CONs su lazo de control
    
    motorConPIDVelocidad = feedback(Ki*(1/s)*motor,1);
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
rango = 12000:10:13000;
sRango2 = size(rango);
%Se crea una tabla donde alamcenar resultados
soluciones2 = zeros(sRango2(2), 5);
indice = 1;
%Se realiza la simulación por cada valor de Ki
for Ki = rango
    %Se define la función de transferencia del motor CONs su lazo de control
    motorConPIDVelocidad = feedback(Ki*(1/s)*motor,1);
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


csvwrite('PIDVelocidadSim1.csv',soluciones);
csvwrite('PIDVelocidadSim2.csv',soluciones2);



%% Control de posición, bucle 1
KiWElegido = 12220;
motorConPIDVelocidad = feedback(KiWElegido*(1/s)*motor,1);
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
disp(solucionesPos1)
csvwrite('PIDPosiciónSim1.csv',solucionesPos1);



%% Control de posición, bucle 2
rango = 40:0.5:50;
sRangoPos2 = size(rango);
indice = 1;
solucionesPos2 = zeros(sRangoPos2(2), 5);
for KposCr = rango
    %Se define la función de transferencia de la planta CONs su lazo de 
    %control
    motorConPIDPosicion = feedback(KposCr*motorConPIDVelocidad*(1/s), 1);
    resultado = stepinfo(motorConPIDPosicion);
    %Se almacenan los resultados en las tablas
    solucionesPos2(indice,:) = [    KposCr, ...
                                resultado.RiseTime, ...
                                resultado.SettlingTime, ...
                                resultado.Overshoot, ...
                                resultado.Peak ];
    indice = indice+1;
end
disp(solucionesPos2)
csvwrite('PIDPosiciónSim2.csv',solucionesPos2);

%% Simulacion PID posición
KCriticaPosicion = 41.5;
motorConPIDPosicionFinal = feedback(KCriticaPosicion*motorConPIDVelocidad*(1/s), 1);
step(motorConPIDPosicionFinal, 10)

%Calculos coeficientes del PID
pVelocidad = znHallarKPOfPController(KiWElegido);
pPosicion = znHallarKPOfPController(KCriticaPosicion);
disp("Coeficiente P del PID de velocidad: ")
disp(pVelocidad)
disp("Coeficiente P del PID de posición: ")
disp(pPosicion)



%
function y = znHallarKPOfPController(KCr)
    y = 0.5*KCr;
end
function [P,I] = znHallarKPIOfPIController(KCr, Tcr)
    P = 0.45*KCr;
    I = 0.45*Tcr;
end

