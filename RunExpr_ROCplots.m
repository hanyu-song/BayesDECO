function[res4all1] = RunExpr_ROCplots(n, p, num_true, type_idx, R2,PartCounts,...
    g,num_iter, s0, kappa,r)

if nargin < 11 || isempty(r)
    if type_idx == 2 || type_idx == 5
        r = 0.6;  % corr or l1-ball
    elseif type_idx == 3
        r = 3;
    elseif type_idx == 4
        r = 5;
    end
end
if nargin < 10 || isempty(kappa)
    kappa = 1;
end
if nargin < 9 || isempty(s0)
    s0 = 100;
end
if nargin < 8 || isempty(num_iter)
    num_iter = 20 * p;
end
if nargin < 7 || isempty(g)
    g = n;
end
if nargin < 6 || isempty(PartCounts)
    PartCounts = 4;
end
if nargin < 5 || isempty(R2)
    R2 = 0.9;
end
%% Data Preparation (Start Value, Synthesic Dataset)
data_type_all = {'ind', 'corr','group','factor','l1-ball'};
init_val = FindStartVal(p,s0,true);
[Xgen,Ygen,beta] = data_gen(n, p, num_true, data_type_all(type_idx),R2);
x = (Xgen - repmat(mean(Xgen(:,:)),n,1)) ./ repmat(std(Xgen(:,:)), n,1);
y = (Ygen - mean(Ygen)) ./ std(Ygen);

%% Conventional Bayes
 [lpmodel.high, mlength, inclu_prob] = RunMetropolis_sumstats(init_val, ...
            y, x,num_iter, p);
  % label predictors (signals vs. non-signals)
  true_gam = zeros(1,p);
  if strcmp(data_type_all(type_idx), 'group')
      true_gam(1:(num_true * r)) = 1;
      disp(true_gam(1:30))
  elseif strcmp(data_type_all(type_idx), 'l1-ball')
      true_gamIndex = find(beta > 0.001); %%% 0.001 is the threshold
      true_gam(true_gamIndex) = 1;
  else
      true_gam(1:num_true) = 1;
  end
  lpmodel.true = FindLogPostProb(true_gam, y, x, p,g,s0,kappa);
res4all1 = {1:length(find(true_gam)), mlength, inclu_prob,lpmodel.high - lpmodel.true,... 
    };
[TPRconv, FPRconv] = CalcROC(true_gam, inclu_prob);
disp('tradBayes')  % conventional Bayes is done.
%% Bayes DECO & Naive Bayes Partition w/ NO DECO
% set partition size
inclu_prob_all = zeros(p,1);
labels = repmat(0,p, 1);
algorithmType = {'BayesDECO','NaiveBayes'};
grp_size = int16.empty(PartCounts,0);
PartSize = floor(p / PartCounts);
if PartSize == (p / PartCounts)  % evenly split the predictors
    grp_size(1:PartCounts) = PartSize;
else   
    grp_size(1:(PartCounts - 1)) = PartSize;
    grp_size(PartCounts) = p - PartSize * (PartCounts - 1);
end
% find start index of each partitioned set
StartIdx = repmat(1, 1, PartCounts + 1);
StartIdx(2:PartCounts+1) = cumsum(grp_size) + 1;
StartIdx(PartCounts+1) = []; 
% Run MCMC for BayesDECO & Naive Bayes
for name = algorithmType
    if strcmp(name, 'BayesDECO')
        [deco_y, deco_x] = DecoData(y,x);
        disp('BayesDECO')
    elseif strcmp(name, 'NaiveBayes')
        deco_y = y;
        deco_x = x;
        disp('no DECO')
    else disp('error')
    end
    shuffled_cols = randsample(p,p);
    % label predictors (signals -- 1 vs. non-signals -- 0)
    labels = ismember(shuffled_cols, find(true_gam));
    
    parfor i = 1:PartCounts
        grp_idx = shuffled_cols(StartIdx(i):(StartIdx(i) + grp_size(i)- 1));
        grp_init_val = init_val(:, grp_idx);
        part_y = deco_y;
        part_x = deco_x(:,grp_idx);
        [lpmodel_high, mlength, inclu_prob] = RunMetropolis_sumstats(grp_init_val, ...
            part_y, part_x,num_iter, p);
        % Find true model probabiltiy 
        %true_gam = zeros(1,grp_size(i));
        %if strcmp(data_type_all(type_idx), 'group')
            %true_gam(:, grp_idx <= (num_true*r)) = 1;
        %elseif strcmp(data_type_all(type_idx), 'l1-ball')
        true_gam = labels(StartIdx(i):(StartIdx(i) + grp_size(i)- 1));
        lpmodel_true = FindLogPostProb(true_gam, part_y,part_x, p,g,...
        ceil(s0 / PartCounts),kappa);
        grp_true_idx = find(true_gam == 1);
        grp_num_true = sum(true_gam ~= 0);
        res4all(i, :) = {grp_true_idx, mlength, inclu_prob,lpmodel_high - lpmodel_true,... 
       };
    end 
    % Aggregate results & Calculate TPR and FPR
    for i = 1:PartCounts
        inclu_prob_all(StartIdx(i):(StartIdx(i) + grp_size(i)- 1), 1) = ...
            reshape(cell2mat(res4all(i,3)), [],1);
    end
    if strcmp(name, 'BayesDECO')
        [TPRBayDECO, FPRBayDECO] = CalcROC(labels, inclu_prob_all);
    elseif strcmp(name, 'NaiveBayes')
        [TPRNaivB, FPRNaivB] = CalcROC(labels, inclu_prob_all);
    else 
        disp('error')
    end
end
%% plot the results of all 3 methods
plot(FPRconv,TPRconv,'--g',FPRBayDECO, TPRBayDECO,':r', ...
FPRNaivB,TPRNaivB, 'b','LineWidth',2);
str = sprintf('ROC under Model %d (n = %d, p = %d, R_2 = %0.1f)',...
    type_idx, n,p,R2);
title(str);
xlabel({'False Positive Rate'});
ylabel({'True Positive Rate'});
legend('Bayesian ','Bayesian DECO','Bayesian Partition no DECO','Location','southeast')
name_str = sprintf('Model%dn%dp%dR2%d.png',type_idx, n,p,R2*10);
saveas(gcf,name_str);
end


