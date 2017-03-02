function [TPR, FPR] = CalcROC(labels, scores)
%% This function calculates the false positive and true positive rate under
%each threshold. The function takes two inputs: labels is a boolean vector 
%with the actual classification of each case, and scores is a vector of real-valued 
%prediction scores assigned by some classifier.

[srted_scores,idx4order]=sort(scores, 'descend');
labels = labels(idx4order);
TPR=cumsum(labels)/sum(labels);
FPR=cumsum(~labels)/sum(~labels);
end

