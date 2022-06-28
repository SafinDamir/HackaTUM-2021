%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% worksheet2 investigates three computational approaches by solving general initial value problem:
%	Dahlquist’s test equation, where lambda = -1:
%		dx/dt = -x
%		x(0) = 1
%		(solution: x = exp(-t))
% with:
%		explicit Euler method
% 		method of Heun
%		Runge-Kutta method (fourth order)
% by computing error's L^2 norm at [t_start, t_end] and checking order of approximation 
%
% worksheet2 also exploits Heun scheme on general initial value problem:
%	Van-der-Pol Oscillator equation, where mu = 1:
%		d2x/dt2 - (1 - x^2)*dx/dt + x = 0
%		x(0) = 1
%		dx/dt(0) = 1
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

close all; %closes all open figures
clc;
clear;

methodName = ...
    {'explicit Euler method','method of Heun','Runge-Kutta method'}; 
method = {@expl_euler, @method_Heun, @method_RungeKutta};

%analytical solution
t_anal = 0:0.05:5;
x = exp(-1 * t_anal);

y_0 = 1; %initial condition
t_end = 5; %time period (t_0 = 0)

dt_array = [1, 1/2, 1/4, 1/8]; %a series of time steps used for calculations
dt_cases = size(dt_array, 2); %(in our case it's four)
E_array = zeros(dt_cases, 3); %create a matrix of Errors in advance

for methNum = 1:3 %we consider three methods
    
    figure(); %creates a new figure with the given name
    title(methodName{methNum}); %title of the figure
    func_method = method{methNum};
    xlabel('t');
    ylabel('y');
    grid on;
    hold on;
    plot(t_anal, x, '--b', 'LineWidth', 2); %plot the analytical solution
    
    for j = 1:dt_cases %we consider all given time steps
        dt = dt_array(j);
        t = 0:dt:t_end;
        y = func_method(y_0, dt, t_end, @func_solve);
        plot(t, y, 'o-', 'LineWidth', 1.5, 'Markersize', 4);
        
        x_exact = exp(-1 * t); %exact solution in given points
        sz = size(t);
        
        E = sqrt(dt/t_end * sum((x_exact(:) - y(:)).^2));
        
        E_array(j, methNum) = E; %put all Errors in a matrix (timestep, method)
        
    end
    
    hold off; 
    
    disp(string(methodName(methNum)));
    E_red = [NaN, exp(-diff(log(E_array(:, methNum))))']; %check the table in the worksheet
    A = [E_array(:, methNum)'; E_red];
    Table = array2table(A, 'RowNames',{'Error', 'Error red.'}, 'VariableNames', (char(948) + "t = " + string(dt_array)));
    disp(Table);
    
end

y_0 = [1, 1];
dt = 0.1;
t_end = 20;
t = 0:dt:t_end;
y = method_Heun(y_0, dt, t_end, @func_van_der_pol);

figure();
hold on;
grid on;
title('Dependence of the system position coordinate and speed on time'); %title of the figure
xlabel('t');
ylabel('x (blue), y (red)')
plot(t, y(:, 1), 'b', t, y(:, 2), 'r');
hold off;
   
figure();
hold on;
grid on;
title('Phase portrait of the system'); %title of the figure
xlabel('x');
ylabel('y (dx/dt)');
plot(y(:, 1), y(:, 2), 'm', y_0(1), y_0(2), '*r', 'MarkerSize', 8);
hold off;

[X, Y] = meshgrid(-2.2:0.1:2.2, -3:0.1:3);
szX = size(X);

U = zeros(szX(1), szX(2));
V = zeros(szX(1), szX(2));
 
for i = 1:szX(1)
    for j = 1:szX(2)
        tmp = func_van_der_pol([X(i,j), Y(i, j)]);
        U(i, j) = tmp(1);
        V(i, j) = tmp(2);
    end
end

figure();
title('Phase space of the system'); 
hold on;
grid on;
quiver(X, Y, U, V);
plot(y(:, 1), y(:, 2), 'm', y_0(1), y_0(2), '*r', 'MarkerSize', 8);
