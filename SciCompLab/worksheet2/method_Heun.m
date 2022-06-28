function [y] = method_Heun(y_0, dt, t_end, f)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% method_Heun - makes timestep for ODE dy/dt = f(y, t) by Heun scheme:
% 					y_{n+1}* = y_n + dt*f(t_n, y_n)
%					y_{n+1} = y_n + dt/2(f(t_n, y_n) + f(t_{n+1}, y_{n+1}*))
%
%	y = method_Heun(y0, dt, t_end, f)
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
%	y		system step-by-step evolution
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

t = 0:dt:t_end;
N = size(t, 2);
szVec = size(f(y_0), 2);
y = zeros(N, szVec);
y(1, :) = y_0;

for i = 2:N
    y_der = y(i-1, :) + dt * f(y(i-1, :)); % y_der is y_n_plus_one
    y(i, :) = y(i-1, :) + dt * 0.5 * (f(y(i-1,:)) + f(y_der));
end
