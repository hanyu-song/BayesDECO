function [Rsquare] = FindRsquare(state,y,x)
%UNTITLED5 Summary of this function goes here
%   Detailed explanation goes here
num_pred = sum(state);
n = size(x, 1);
if num_pred > 0
    temp = y' * x(:, state == 1);
        if num_pred > n
            %xx_inv = IMqrginv(x(:, state ==1)'* x(:,state == 1));
            xx_inv = pinv(x(:, state ==1)'* x(:,state == 1));
            %test = [num_pred,n]
            disp(test)
        else
            xx_inv = inv(x(:,state == 1)' * x(:, state == 1));
            %disp('normalinverse')
        end
        Rsquare_num = temp * xx_inv * temp';
       Rsquare_dem = sum(y.^2);
       Rsquare = Rsquare_num / Rsquare_dem;
else
        Rsquare = 0;
    end

end





