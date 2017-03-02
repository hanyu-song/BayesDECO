function [deco_y, deco_x] = DecoData(y,x)
p = size(x,2);
[U, D] = eig(x * x');
robustTerm = 1; % consider make it an input
F = sqrt(p) * U * diag(1./sqrt((diag(D) + robustTerm))) * U';
deco_y = F * y;
deco_x = F * x;
end

