%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% worksheet3 investigates two computational approaches by solving general initial value problem:
%	Dahlquist’s test equation, where lambda = -7:
%		dx/dt = -7*x
%		x(0) = 1
%		(solution: x = exp(-7*t))
% with:
%		explicit Euler method
% 		implicit Euler method
%
% by computing error's L^2 norm at [t_start, t_end] and checking order of approximation 
%
% worksheet3 also exploits the implicit Euler scheme on general initial value problem:
%	Van-der-Pol Oscillator equation, where mu = 4:
%		d2x/dt2 - 4 * (1 - x^2)*dx/dt + x = 0
%		x(0) = 1
%		dx/dt(0) = 1
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


close all; %closes all open figures
clc;
clear;

methodName = ...
    {'explicit Euler method', 'implicit Euler method'}; 

y_0 = 1; %initial condition
t_end = 5; %time period (t_0 = 0)
f = @(x) -7 * x; %right side of Dahlquist’s equation
df = @(x) -7; %derivative of f

%analytical solution
t_anal = 0:0.05:t_end;
x = exp(-7 * t_anal);

dt_array = [1/2, 1/4, 1/8, 1/16, 1/32]; %series of time steps used for calculations
dt_cases = numel(dt_array);
E_array = zeros(dt_cases, 2); %create a matrix of Errors in advance

f1 = figure('Name', 'Dahlquist’s equation');
f1.Position(1:4) = [0 300 900 700];
tiledlayout(2, 1);
ax1 = nexttile;

hold on;
plot(ax1, t_anal, x, '--b', 'LineWidth', 2); %plot the analytical solution
for j = 1:dt_cases %we consider all given time steps
    dt = dt_array(j);
    t = 0:dt:t_end;
    y = expl_euler(y_0, dt, t_end, f);
    plot(ax1, t, y, 'o-', 'LineWidth', 1.5, 'Markersize', 4);
        
    x_exact = exp(-7 * t); %exact solution in given points
    sz = numel(t);
        
    E = sqrt(dt/t_end * sum((x_exact(:) - y(:)).^2));
        
    E_array(j, 1) = E; %put all Errors in a matrix (timestep, method)
    
end

label_title = "^{1}/_{" + 1./dt_array + "}";
legend(["analytical solution", "dt=" + label_title]);
title(methodName{1}); %title of the figure
axis([0 5 -1 1]);
xlabel('t');
ylabel('x');
grid on;
hold off;

ax2 = nexttile;

hold on;
plot(ax2, t_anal, x, '--b', 'LineWidth', 2); %plot the analytical solution
for j = 1:dt_cases %we consider all given time steps
    dt = dt_array(j);
    t = 0:dt:t_end;
    y = impl_Euler(y_0, dt, t_end, f, df);
    plot(ax2, t, y, 'o-', 'LineWidth', 1.5, 'Markersize', 4);
        
    x_exact = exp(-7 * t); %exact solution in given points
    sz = numel(t);
        
    E = sqrt(dt/t_end * sum((x_exact(:) - y(:)).^2));
        
    E_array(j, 2) = E; %put all Errors in a matrix (timestep, method)
        
end
label_title = "^{1}/_{" + 1./dt_array + "}";
legend(["analytical solution", "dt=" + label_title]);
title(methodName{2}); %title of the figure
axis([0 5 -1 1]);
xlabel('t');
ylabel('x');
grid on;
hold off;

for i=1:2
    disp(string(methodName(i)));
    E_red = [NaN, exp(-diff(log(E_array(:, i))))']; %check the table in the worksheet
    A = [E_array(:, i)'; E_red];
    Table = array2table(A, 'RowNames',{'Error', 'Error red.'}, 'VariableNames', (char(948) + "t = " + string(dt_array)));
    disp(Table);
end

disp('Stable cases');
stability = ['N', 'N', 'Y', 'Y', 'Y'; 'Y', 'Y', 'Y', 'Y', 'Y'];
disp(array2table(stability, 'RowNames', methodName,...
    'VariableNames', string(dt_array)));
    

y_0 = [1, 1];
dt = 0.1;
t_end = 20;
t = 0:dt:t_end;
f = @(x) [x(2); 4 * (1 - x(1)^2) * x(2) - x(1)];
df = @(x) [0, 1; -8 * x(1) * x(2) - 1, 4 * (1 - x(1)^2)];
y = impl_Euler(y_0, dt, t_end, f, df);

f3 = figure('Name', 'Van der Pol oscillator explicit');
z = expl_euler(y_0, dt, t_end, f);
plot(z(1, :), z(2, :), 'm', y_0(1), y_0(2), '*r', 'MarkerSize', 8);
title('Phase portrait of the system'); 
xlabel('x');
ylabel('y (dx/dt)');
grid on;

f2 = figure('Name', 'Van der Pol oscillator');
f2.Position(1:4) = [1000 300 900 700];
tiledlayout(2, 2);
ax1 = nexttile;


plot(t, y(1, :), 'b');
title('Dependence of the system position coordinate on time');
xlabel('t');
ylabel('x');
grid on;

ax2 = nexttile;


plot(t, y(2, :), 'r');
title('Dependence of the system speed on time');
xlabel('t');
ylabel('y (dx/dt)');
grid on;

ax3 = nexttile;


plot(y(1, :), y(2, :), 'm', y_0(1), y_0(2), '*r', 'MarkerSize', 8);
title('Phase portrait of the system'); 
xlabel('x');
ylabel('y (dx/dt)');
grid on;

[X, Y] = meshgrid(-2.2:0.1:2.2, -6:0.1:6);
szX = size(X);

U = zeros(szX(1), szX(2));
V = zeros(szX(1), szX(2));
 
for i = 1:szX(1)
    for j = 1:szX(2)
        tmp = f([X(i,j), Y(i, j)]);
        U(i, j) = tmp(1);
        V(i, j) = tmp(2);
    end
end


ax4 = nexttile;


hold on;
quiver(X, Y, U, V);
plot(y(1, :), y(2, :), 'm', y_0(1), y_0(2), '*r', 'MarkerSize', 8);
title('Phase space of the system'); 
xlabel('x');
ylabel('y (dx/dt)');
grid on;
hold off;
