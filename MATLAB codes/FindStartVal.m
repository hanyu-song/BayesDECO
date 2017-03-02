function [start] = FindStartVal(p, s0, null_pert, num_truepred)
if nargin < 2 || isempty(s0)
    s0 = 100;
end
if nargin < 3 || isempty(null_pert) 
  null_pert = true;
end
if nargin < 4 || isempty(num_truepred)
    num_truepred = [];
end
flip_prob = 0.05;
if null_pert
    %disp('null_perut')
    start = repmat(0,1,p);
    index2flip = randsample(p, s0);
    start(index2flip) = abs(rand(1,s0) <= flip_prob);
else % random perturbation of true model
    %disp('true')
    start =  horzcat(repmat(1, [1 num_truepred]), zeros(1,p - num_truepred));
    start =  abs((rand(1,p) <= flip_prob) - start);
end

end

