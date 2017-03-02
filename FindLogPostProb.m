function[log_post_prob] = FindLogPostProb(gamma, y,x, totnum_pred,g, ...
    s0, kappa)
%gamma is a row vector
if nargin < 7 || isempty(kappa)
   kappa = 1;
end
if nargin < 6 || isempty(s0)
    s0 = 100;
end
if nargin < 5 || isempty(g)
    g = size(x,1);
end
n = size(x,1);
num_pred = sum(gamma);

if num_pred <= s0  %%%
    if num_pred > 0
        temp = y' * x(:, gamma == 1);
        if num_pred > n
            %xx_inv = IMqrginv(x(:, gamma ==1)'* x(:,gamma == 1));
            xx_inv = pinv(x(:, state ==1)'* x(:,state == 1));
        else %% may need a change 
            %L = inv(chol(x(:, gamma == 1)' * x(:, gamma == 1))); 
            %xx_inv = L * L';
            xx_inv = inv(x(:,gamma == 1)' * x(:, gamma == 1));
        end
        rsquare_num = temp * xx_inv * temp';
       rsquare_dem = sum(y.^2);
       rsquare = rsquare_num / rsquare_dem;
     %disp('<s0,>0')
    else
        rsquare = 0;
     %disp('<s0,=0')
    end
    log_post_prob = -kappa * num_pred *log(totnum_pred) - num_pred / 2 * ...
        log(1 + g) - n / 2 * log(1 + g * (1 - rsquare));
else %%%%
    log_post_prob = -Inf;
    %disp('-inf')
end
%disp(log_post_prob)
end

