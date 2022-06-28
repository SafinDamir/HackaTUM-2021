function [y] = impl_Euler(y_0, dt, t_end, f, df)

tol = 1e-8;
t = 0:dt:t_end;
N = numel(t);
szVec = numel(f(y_0));
y = zeros(szVec, N);
y(:, 1) = y_0;

for i = 2:N
    if (det(eye(szVec) - df(y(:, i-1)) * dt) < tol)
        break;
    end
    y(:, i) = method_Newton(y(:, i-1), @(x) x - y(:, i-1) - f(x) * dt, @(x) (eye(szVec) - df(x) * dt));
end

end

