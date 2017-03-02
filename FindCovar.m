function Sigma = FindCovar(p, is_indep)
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
Sigma = eye(p);
if ~logical(is_indep)
    correlation = repmat(0.5, p,p);
    Sigma = 0.5 * Sigma + correlation;
end
end

