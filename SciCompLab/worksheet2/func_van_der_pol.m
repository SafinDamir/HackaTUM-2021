function [res] = func_van_der_pol(x)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Outputs the right side of first-order form of the Van-der-Pol Oscillator equation.
%	Van-der-Pol Oscillator equation, where mu = 1:
%		d2x/dt2 - (1 - x^2)*dx/dt + x = 0
%		x(0) = 1
%		dx/dt(0) = 1
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

res = [x(2), (1 - x(1)^2) * x(2) - x(1)];
end

