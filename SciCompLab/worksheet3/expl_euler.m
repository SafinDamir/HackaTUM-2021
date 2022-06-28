function [y] = expl_euler(y_0, dt, t_end, f)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% expl_euler - makes timestep for ODE dy/dt = f(y, t) by explicit Euler scheme:
% 					y_{n+1} = y_n + dt*f(t_n, y_n)
%
%	y = expl_euler(y0, dt, t_end, f)
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
N = numel(t);
sz = numel(y_0);
y = zeros(sz, N);
y(:, 1) = y_0;

for i = 2:N
    y(:, i) = y(:, i-1) + dt * f(y(:, i-1));    
end
