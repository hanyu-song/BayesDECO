function [] = CompareIncluProb(n, p, num_true, rbegin, rend,rlength, R2,PartCounts,...
    g,num_iter, s0, kappa)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
if nargin < 12 || isempty(kappa)
    kappa = 1;
end
if nargin < 11 || isempty(s0)
    s0 = 100;
end
if nargin < 10 || isempty(num_iter)
    num_iter = 20 * p;
end
if nargin < 9 || isempty(g)
    g = n;
end
if nargin < 8 || isempty(PartCounts)
    PartCounts = 4;
end
if nargin < 7 || isempty(R2)
    R2 = 0.9;
end
if nargin < 6 || isempty(rlength)
    rlength = 10;
end
if nargin < 5 || isempty(rend)
    rend = 0.9;
end
if nargin < 4 || isempty(rbegin)
    rbegin = 0;
end
if nargin < 3 || isempty(num_true)
    num_true = 5;
end
rvec = linspace(rbegin, rend, rlength);
parfor k = 1:rlength
    [inclu_prob] = RunExpr_IncluProb(n, p, num_true, 2, R2,PartCounts,...
    g,num_iter, s0, kappa,rvec(k),k);
end
end


