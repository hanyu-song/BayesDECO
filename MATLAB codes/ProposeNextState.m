function next = ProposeNextState(current)
%UNTITLED7 Summary of this function goes here
%   Detailed explanation goes here

next = current;
q = length(current);  %number of strong signals
is.sgl = (rand <= 0.5);
if is.sgl
    col_idx = randsample(q,1);
    next(col_idx) = 1 - current(col_idx);
else 
    if sum(current) > 0 && sum(current) < q
        signal_idx = randsample(find(current == 1), 1);
        next(signal_idx) = 1 - current(signal_idx);
        noise_idx = randsample(find(current == 0), 1);
        next(noise_idx) = 1 - current(noise_idx);
    end
end
        
end

