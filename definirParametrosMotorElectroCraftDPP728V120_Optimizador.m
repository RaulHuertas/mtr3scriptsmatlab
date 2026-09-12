
clc
clear
close all
A = [0 1; 0 0];
B = [0 ; 1];
C = [ 1 0 ; 0 1];
D = [0 ; 0];
syms s k1 k2
K = [k1  k2];
retrasoDeseado = 1.0;
tiempoTransicion = 0.5;
p1 = -4/(retrasoDeseado);
p2 = p1*10;
polosDeseados = [p1 p2];
%Por el método FSF
ecuDeseada = (s-p1)*(s-p2);
ecuDeseada = expand(ecuDeseada);
coefsEcuDeseada = sym2poly(ecuDeseada);
ecuPolos = det(s*eye(2,2)-(A-B*K));
K1 = coefsEcuDeseada(3)
K2 = coefsEcuDeseada(2)
display("Sistema observable: "+esObservableQ(A,C) );
display("Sistema controlable: "+esControlableQ(A,B) );

%Por el método ackerman
Kacker = acker(A, B, polosDeseados)
Ak = A-B*Kacker;
Bk = zeros(size(B));
Ck = C;
Dk = D;
sistemaControlado = ss(Ak, Bk, Ck, Dk);

damp(sistemaControlado);
stepinfo(sistemaControlado);

%%VALORES PARA LA SIMULACION
%RUIDOs
ruido_tiempoRef = 0:0.01:10;
nRuido = length(ruido_tiempoRef);
ruido_valores1 = wgn(1,nRuido,0);
%ruido1
maxRuido1 = max(ruido_valores1);
minRuido1 = min(ruido_valores1);
rangoRuido1 = maxRuido1-minRuido1;
intermedioRuido1 = (maxRuido1+minRuido1)/2;
ruido_valores1 = ruido_valores1-intermedioRuido1*ones(1,nRuido);
ruido_valores1 = ruido_valores1*2/(maxRuido1-minRuido1);
%ruido2
ruido_valores2 = wgn(1,nRuido,0);
maxRuido2 = max(ruido_valores2);
minRuido2 = min(ruido_valores2);
rangoRuido2 = maxRuido2-minRuido2;
intermedioRuido2 = (maxRuido2+minRuido2)/2;
ruido_valores2 = ruido_valores2-intermedioRuido2*ones(1,nRuido);
ruido_valores2 = ruido_valores2*2/(maxRuido2-minRuido2);

%Desplazamiento angular deseado
tiempoSim = 10*tiempoTransicion;
inclinacionMax = deg2rad(15);
secuencia_tiempoRef = linspace(0,tiempoSim, 11);%0:tiempoTransicion:10;
secuencia_valoresRef = [0 0 inclinacionMax inclinacionMax 0 0 0 -inclinacionMax -inclinacionMax 0 0];
secuencia_tiempo = 0:tiempoTransicion/2:tiempoSim;
secuencia_valores = interp1(secuencia_tiempoRef, secuencia_valoresRef, secuencia_tiempo );
secuenciaSuave_valores = secuencia_valores;
secuenciaSuave_valores(2:end) = inclinacionMax;
secuenciaSuave_valores(end) = 0;

%% Valores numéricos
%Valores de la carga
g   = 9.8;
dm  = 0.550061;
dmc = 1.06911;
Mm  = 18.911;
Mc  = 144.6;
Im = 6.69606;
Ic = 168.015;
fm = 0.002;

%valores de simulacion
tsSimulacion = 0.0001;
%Valores del motor
relacionEngranajes = 100.0/1.0; % dientes salida/dientes entrada
Rm = 1.55;% resistencia de armadura
Lm = 4.3/1000;% inductancia armadura
Jm = gramsCM2ToKgMeters2(12358.5);%inercia rotacional motor
Kt = newtonCMToNewtonM(62); %constante torque
Kb = VoltagePerKRPMToVoltagePerRadS(64.9);% back emf constant
electricalTimeConstant = Lm/Rm;
mechanicalTimeConstant = 5.0/1000.0;
te = electricalTimeConstant;
tm = mechanicalTimeConstant;
Bm = Jm/tm;% coeficiente de fricción viscosa

gm2Tokgm(2.737E+09)

%% EJECUTAR SIMULACIÓN
%simOut = sim('ControlPIDConCargaMotorElectroCraft_Ajustable', 10);
%[tiempoCambioDeAngulo, maxCurrent] = obtenerTiempoCambioDeAngulo(simOut)
%P = 5.54550556338481
%I = 3.95343022800033
%D = 1.398220196335061
menorTiempoCambioDeAngulo = 100000;
menorMaxCurrent = 100000;
KPoptimo = 5.54550556338481;
KIoptimo = 3.95343022800033;
KDoptimo = 1.398220196335061;
for KP = 0.1:1:30
    for KI = 0.1:1:30
        for KD = 0.1:1:30
            simOut = sim('ControlPIDConCargaMotorElectroCraft_Ajustable', 10);
            [tiempoCambioDeAngulo, maxCurrent] = obtenerTiempoCambioDeAngulo(simOut);
            if (tiempoCambioDeAngulo>1.2) %valor no aceptable
                continue;
            end
            if (maxCurrent<10) %valor no realizable
                continue;
            end
            if(maxCurrent<=menorMaxCurrent)
                KPoptimo = KP;
                KIoptimo = KI;
                KDoptimo = KD;
                disp(['KPoptimo encontrado: ', KPoptimo]);
                disp(['KIoptimo encontrado: ', KIoptimo]);
                disp(['KDoptimo encontrado: ', KDoptimo]);
            end
            
        end
    end
end

disp(['tiempoCambioDeAngulo: ', tiempoCambioDeAngulo]);
disp(['KPoptimo: ', KPoptimo]);
disp(['KIoptimo: ', KIoptimo]);
disp(['KDoptimo: ', KDoptimo]);
disp('Fin');

%% Funciones auxiliares
function observableQ = esObservableQ(A,C)
    observableQ = (rank(obsv(A,C))==length(A));
end

function controlableQ = esControlableQ(A,B)
    controlableQ = (rank(ctrb(A,B))==length(A));
end

function nm = newtonCMToNewtonM(units)
    nm = units*0.01;
end

function kgm2 = gramsCM2ToKgMeters2(units)
    kgm2 = units*(1/1000.0)*(1/10000.0);
end

function VH = VoltagePerKRPMToVoltagePerRadS(units)
    VH = units*60/(2*pi*1000);
end

function r = gm2Tokgm(units)
    r = units/1000;
    r = (r/1000/1000);
end

function [tiempoCambioDeAngulo, maxCurrent]  = obtenerTiempoCambioDeAngulo(simOut)
    nMuestrasSimulacion = size(simOut.corrienteMax.signals.values);
    maxCurrent = simOut.corrienteMax.signals.values();
    maxCurrent = maxCurrent(1,1);
    posiciones = simOut.pos.signals.values;
    posicionesDeseadas = simOut.posDeseada.signals.values;
    %% obtener tiempo alcanca de inclinaciǿn final
    tiempoPosFinal = 1.6;
    for tiempo = 20000:nMuestrasSimulacion
       if( abs(posiciones(tiempo)-posicionesDeseadas(floor(tiempo/10)))<deg2rad(1)/50 ) 
           tiempoPosFinal = simOut.pos.time(tiempo,1);
           break;
       end
    end
    tiempoCambioDeAngulo = tiempoPosFinal-1.6;
end
