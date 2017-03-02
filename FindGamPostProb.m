function [inclus_prob] = FindGamPostProb(y,x,state, totnum_pred, g,... 
s0, kappa)
%UNTITLED4 Summary of this function goes here
%   Detailed explanation goes here
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
num_pred = sum(state);  % should be less than s0
pred_idx = find(state);  
inclus_prob = state;  %1s and 0s
RSquare = FindRsquare(state, y,x);
Rsquare_no_j = state;
state_no_j = state;
temp = state;
temp2 = state; 
for j = 1:num_pred
    idx = pred_idx(j);
   state_no_j(idx) = 0;
   Rsquare_no_j(idx) = FindRsquare(state_no_j, y, x);
   temp(idx) = log(1 + g*(1 - Rsquare_no_j(idx)));
   temp2(idx) = n / 2 * log(1 + g*(1 - RSquare)) -...
    n / 2 * temp(idx) + (log(1 + g)) / 2 + kappa * log(totnum_pred);
inclus_prob(idx) = 1 / (exp(temp2(idx)) + 1);
end
end

