function [y] = method_RungeKutta(y_0, dt, t_end, f)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% method_RungeKutta - makes timestep for ODE dy/dt = f(y, t) by Runge–Kutta scheme:
%					yy_1 = f(t_n, y_n)
%					yy_2 = f(t_{n+1/2}, y_n+dt/2*yy_1)
%					yy_3 = f(t_{n+1/2}, y_n+dt/2*yy_2)
%					yy_4 = f(t_{n+1}, y_n+dt*yy_3)
%					y_{n+1} = y_n + dt/6*(yy_1 + yy_2 + yy_3 + yy_4)
%
%	y = method_RungeKutta(y0, dt, t_end, f)
%
%--------
% Input: 
%--------
%	y0		initial state
%	dt		timestep
%	t_end	simulation total timespan
% 	f		<callable> right hand side
%
%--------
% Output: 
%--------
%	y		<float array> system step-by-step evolution
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

t = 0:dt:t_end;
N = size(t, 2);
y = zeros(1, N);
y(1) = y_0;

for i = 2:N
    yy_1 = f(y(i-1));
    yy_2 = f(y(i-1) + dt/2 * yy_1);
    yy_3 = f(y(i-1) + dt/2 * yy_2);
    yy_4 = f(y(i-1) + dt * yy_3);
    y(i) = y(i-1) + dt * 1/6 * (yy_1 + 2 * yy_2 + 2 * yy_3 + yy_4);
end
