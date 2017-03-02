function[lpmodel_high,mlength,pInclu] = RunMetropolis_sumstats(start, y,x,...
    num_iter, totnum_pred,g, s0,kappa)
if nargin < 8 || isempty(kappa)
   kappa = 1;
end
if nargin < 7 || isempty(s0)
    s0 = 100;
end
if nargin < 6 || isempty(g)
    g = size(x,1);  % n or p^2%
end
n = size(x,1);
p = size(x,2);
current = start;
lpmodel_current = FindLogPostProb(start, y,x,totnum_pred,g, s0, kappa);
mlength = sum(start);
lpmodel_high = lpmodel_current;
pInclu = zeros(1,p);
postburn_start = floor(num_iter / 2);
postburn_count = num_iter - postburn_start + 1;
%res = repmat(0,postburn_count, p);
for iter = 1:num_iter
    %next = ProposeNextState(res(iter,:));
    proposal = ProposeNextState(current);
    lpmodel_proposal = FindLogPostProb(proposal, y, x,totnum_pred, g, s0, kappa);
    %disp(lpmodel_proposal)
    lpmodel_diff = lpmodel_proposal - lpmodel_current;
    if lpmodel_proposal <= -Inf
        next = current;
        %disp('go thru inf pass')
    elseif lpmodel_diff <= 0
        %disp('go thru random draw pass')
        pmodel_ratio = exp(lpmodel_diff);
            if rand >= pmodel_ratio
                next = current;
            else 
            %res(iter + 1, :) = next;
                next = proposal;
                lpmodel_current = lpmodel_proposal;
            end 
        %res(iter + 1, :) = next;
    else
        %disp('go thru direct accept pass')
        next = proposal;
        lpmodel_current = lpmodel_proposal;
        lpmodel_high = lpmodel_current;
    end
    res(iter, :) = next;
    if sum(next) > sum(current)
        mlength = sum(next);
    end
    current = next;   %% assigning the "next" value to "current"
    if iter >= postburn_start   %%% consider postburn-in inclusion probabilites 
        if(sum(current))  % existence of signals
            pinclu_current = FindGamPostProb(y,x,current, totnum_pred, g,... 
s0, kappa);
            pInclu = pInclu + pinclu_current;
            %res(iter, :) = pinclu_current;
        %else res(iter, :) = 0;
        end
    end
end
pInclu = pInclu / postburn_count;
%inclus_prob = inclu_ind / (num_iter - floor(num_iter / 2) + 1);
%fileID = fopen('samples.txt','w');
%fprintf(fileID,'%d', res);
%fclose(fileID);
%csvwrite('samples.dat',res);
%writetable(res,'samples.csv');
%dlmwrite('pinclprob.txt',res)
%res = array2table(res, 'VariableNames', 
%writetable(table(res), 'inclusion_prob');
end