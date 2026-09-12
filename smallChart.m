function d = point_to_line_distance(p1, p2, ref)
%POINT_TO_LINE_DISTANCE Distance from point ref to line through p1-p2
%   p1, p2, ref are 1x2 vectors [x y] (or 2x1). Returns scalar distance d.

% Ensure inputs are row vectors
p1 = reshape(p1,1,2);
p2 = reshape(p2,1,2);
ref = reshape(ref,1,2);

% Vector from p1 to p2 and from p1 to ref
v = p2 - p1;
w = ref - p1;

% Handle degenerate case where p1 == p2 (line is a point)
if all(abs(v) < eps)
    d = norm(w);
    return;
end

% Distance = norm(cross in 2D) / norm(v)
% For 2D vectors, cross product magnitude is |v_x*w_y - v_y*w_x|
cross_mag = abs(v(1)*w(2) - v(2)*w(1));
d = cross_mag / norm(v);
end

% MATLAB Script to plot points, trendline, and a rectangle
clear; clc; clf;

%% User Configuration
% Define your 4 points (x, y)
x = [0.9625, 0.625, 0.925, 1.0];
y = [0.89, 0.53, 0.75, 1.0];

% Compute distances from each point (x,y) to the line through (0,0) and (1,1)
p1 = [0, 0];
p2 = [1, 1];
nPoints = numel(x);
distances = zeros(1, nPoints);
for i = 1:nPoints
    distances(i) = point_to_line_distance(p1, p2, [x(i), y(i)]);
end

% Optionally display distances in command window
disp('Distances to line (0,0)-(1,1):');
disp(distances);

% Define Colors (R, G, B format: [0-1, 0-1, 0-1])
colorPoints = [0 0 1];      % Blue
colorTrend  = [1 0 0];      % Red
colorSquare = [0.1 0.1 0.9];    % Green
colorCentralLine = [0.0 0.6 0.0];    % Green

%% Calculation
% Calculate linear trendline (y = mx + b)
p = polyfit(x, y, 1);
x_fit = linspace(min(x), max(x), 100);
y_fit = polyval(p, x_fit);

%% Plotting
hold on; grid on;

% 1. Plot the Square (0,0) to (0.6, 0.6)
% Note: User requested (0,0) to (0, 0.6). Assuming a square of 0.6 width:
%rectangle('Position', [0, 0, 0.6, 0.6], 'EdgeColor', colorSquare, 'LineWidth', 2, 'LineStyle', '--');

% 2. Plot dashed green trendline from (0,0) to (1,1)
plot([0 1], [0 1], '--', 'Color', colorCentralLine, 'LineWidth', 1.5, 'DisplayName', 'Diagonal (0,0)-(1,1)');
% 3. Plot Points
scatter(x, y, 50, colorPoints, 'filled', 'DisplayName', 'Data Points');

% Formatting
xlabel('Valor técnico');
ylabel('Valor económico');
%title('Data Points, Trendline, and Bounding Square');
%legend('show', 'Location', 'northwest');
axis equal;

xlim([0 1])
ylim([0 1])
labels = {'Concepto 1', 'Concepto2', 'Concepto3', 'Solución Ideal'};

% Append distance values to labels
for i = 1:numel(labels)
    labels{i} = sprintf('%s (d=%.3f)', labels{i}, distances(i));
end

dx = 0.02; dy = 0.02; % small offset for labels
for i = 1:numel(x)
    text(x(i)+dx, y(i)+dy, labels{i}, 'FontSize', 10, 'Color', 'k', 'Interpreter', 'none');
end
hold off;
% Ensure axes exist and set labels (in Spanish as used above)
ax = gca;
ax.XLabel.String = 'Eje X (Valor técnico)';
ax.YLabel.String = 'Eje Y (Valor económico)';
ax.XLabel.FontSize = 12;
ax.YLabel.FontSize = 12;

