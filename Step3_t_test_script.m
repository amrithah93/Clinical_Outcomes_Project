%% do t-tests to see group differences between the components using loadings
%load Clinical Outcomes CoM Workspace
% Run t-test
hcind = 1:76;        % 76 subjects
depind = 77:2819;    % 2743 subjects

% Run t-test between groups
[h, p, ci, stats] = ttest2(a(hcind,:), ...
                           a(depind,:));

% Extract significant p-values
sig_idx_p = find(p < 0.05);
p_sig = p(sig_idx_p);

% Round to 2 decimals
p_sig_rounded = round(p_sig, 2);

%show all decimal points for p values since they are super small
format long e   % show many decimals
p_values = p;   
%% repeat same process but for q values, get components with loadings that passed threshold
%% correct for FDR correction
q = mafdr(p_sig); %correct p vals for FDR correction
sig_idx_q = find(q<0.05); %find q values < 0.05
%% Vince check: q_significant_loadings_group_differences = sum(mafdr(2*(1-tcdf(stats.tstat,212)))<0.05); revealed 9 comps

% Extract significant q-values (FDR < 0.05)
% Indices for q < 0.01
idx_lt_001 = find(q == 0 | q < 0.01); %account for 0 values since many are so low

% Indices for 0.01 ≤ q < 0.05
idx_001_to_005 = find(q >= 0.01 & q < 0.05);

% Indices for q < 0.05 (all significant)
idx_lt_005 = find(q < 0.05);

% Print results
disp('Indices where q < 0.01:')
disp(idx_lt_001)

disp('Indices where 0.01 ≤ q < 0.05:')
disp(idx_001_to_005)

disp('Indices where q < 0.05:')
disp(idx_lt_005)
