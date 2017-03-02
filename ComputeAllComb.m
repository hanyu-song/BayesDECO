n = [200, 1000];
p = [1000,10000];
num_true = 5;
R2 = 0.5;
%R2 = 0.9;
%type = {'ind', 'corr','group','factor','l1-ball'}; 
%grp_size = 250;
%type_idx = [1,2,3,4,5];
%alg_idx = [1,2,3];
type_idx = [1,2,3,4,5];
alg_idx = [1,2,3];
% generating plots
    %[a,b,c,d,e] = ndgrid(n(1), p(1), num_true, type_idx, R2);
    %result = arrayfun(@RunExpr_ROCplots, a,b,c,d, e,'UniformOutput',0);
   [aa,bb,cc,dd,ee,ff] = ndgrid(n(1), p(1), num_true, type_idx, R2, alg_idx);
   %[dd,ff] = ndgrid(type_idx, alg_idx);
    [minT, averT,tlapsed] = arrayfun(@RecordRunTime, aa,bb,cc,dd,ee,ff, 'UniformOutput',0);   

    save('runtime200.mat', 'minT','averT','tlapsed');
    
    exit;
    