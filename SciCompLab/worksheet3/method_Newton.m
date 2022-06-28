function [y] = method_Newton(x_0, G, dG)

tol = 1e-8;
y = x_0;
error = @(x) (sum(x.^2))^(1/2);
for i=1:100
    %y = y - G(y)/dG(y);
    y = dG(y)\(dG(y) * y - G(y));
    if (error(G(y)) < tol)
        break;
    end
end
end

