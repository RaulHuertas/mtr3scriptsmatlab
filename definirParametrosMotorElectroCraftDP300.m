
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
dm  = 0.3;
dmc = 0.5;
Mm  = 100;
Mc  = 200;
Im = 1.4222;
Ic = 2.03;
fm = 0.05;

%Valores del motor
Ra = 2;% resistencia de armadura
La = 6e-3;% inductancia armadura
J = gramsCM2ToKgMeters(494.3);%inercia rotacional motor
Kt = newtonCMToNewtonM(11.722); %constante torque
Kb = VoltagePerKRPMToVoltagePerHertz(12.3);% back emf constant
Bm = 0.008;% coeficiente de fricción viscosa
relacionEngranajes = 1.0/1;

%% Funciones auxiliares
function observableQ = esObservableQ(A,C)
    observableQ = (rank(obsv(A,C))==length(A));
end

function controlableQ = esControlableQ(A,B)
    controlableQ = (rank(ctrb(A,B))==length(A));
end

function NcmToNm = newtonCMToNewtonM(units)
    NcmToNm = units*0.01;
end

function kgm2 = gramsCM2ToKgMeters(units)
    kgm2 = units*(1/1000.0)*1e-4;
end

function VH = VoltagePerKRPMToVoltagePerHertz(units)
    VH = units/((1/60));
    VH = VH/1000;
end
