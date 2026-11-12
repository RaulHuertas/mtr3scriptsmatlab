x = [0, 218.76, 1396.87] / 1000;  % m
F = [(1021.413+625.575),1021.413, 625.575];            % N
theta = deg2rad(9);
r = 1;                              % m, load application radius




figure;

grid on;
xlabel('Distancia al motor (m)');
ylabel('Internal torsional moment (N·m)');
title('Torsional Moment Diagram');
xlim([0, x(end)]);
yline(0, 'k-');

