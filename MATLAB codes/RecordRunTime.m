function [minTime,trimmedAverTime, tElapsed] = RecordRunTime (n, p, num_true, type_idx, ...
R2,alg_idx, PartCounts, REPS)
%%% grp_Size not put here!!! default: 250.
if nargin < 6 || isempty(alg_idx)
   alg_idx = 2;
end
if nargin < 7 || isempty(PartCounts)
    if alg_idx == 1
        PartCounts = 1;
    elseif alg_idx ==2 | alg_idx == 3
        PartCounts =4;
    else disp('error')
    end
end
if nargin < 8 || isempty(REPS)
    REPS = 10;
end
%REPS = 10;   
minTime = Inf;   
%tic;  % TIC, pair 1
tElapsed = double.empty(REPS,0);
for i=1:REPS
   tStart = tic;  % TIC, pair 2  
   %total = 0;
   [res] = RunExpr_ROC(n, p, num_true, type_idx, R2,alg_idx, PartCounts);
   tElapsed(i) = toc(tStart);
   %%%delete(gcp('nocreate'));
end
%tElapsed = toc(tStart);
   %minTime = min(tElapsed, minTime);
minTime = min(tElapsed);
%sortedTime = sort(tElapsed);
%AverCount = floor(REPS/2); 
trimmedAverTime = trimmean(tElapsed,50);  % TOC, pair 1 
end

