%% ============================================================
% Sanity check
%Convert values from CoM matrices to Signed Log10 p-values - script from
% Vince after having some issues plotting the log plot, and replotting
% another bar plot with the -log10 signed results 
%Use this script
%% ============================================================
% t-test on averaged CoM matrices
cd '/Users/amrithah/Desktop/CalhounLab/Dissertation/Projects/Chapter7_Paper_6_Diss_Clinical_Outcomes/ICA_Results/Depression_ICA_Analyses_Clinical_Outcomes'; 
%% run t-tests on group differences and plot -log10 signed values as a bar plot
%And here is the code (assuming you have a 213x60 matrix of the loading parameters in a variable a):

[h1 p1 ci1 stats1] = ttest2(a(hcind,:),a(depind,:));
 
bar(-log10(p1).*sign(stats1.tstat));
grid on;
 
sigcompspos = find((mafdr(p1)<.05).*(stats1.tstat>0)); %these match what's plotted in the colored bar plot
sigcompsneg = find((mafdr(p1)<.05).*(stats1.tstat<0));  %these match what's plotted in the colored bar plot

% Set x-axis tick labels
x = 1:68; % Label components for the tickmarks
xticks(x); % Set the tickmarks

hold off;

xlabel('NeuroMark SPECT Template Component #s (Components 1-68)')
ylabel('-log10 (p) signed values for all components')
ax = gca;
ax.FontSize = 13;
title('-log10 (p) signed t values: healthy-patient loading parameter group differences'); 

savefig('log10_barplot_ttest.fig');

%% Calculate CoM matrices manually for log plot variables
% Controls CoM
nHC = size(hcind, 1);                     % number of subjects
dot_product_subjects_all_hc = cell(nHC,1);

for i = 1:nHC
    v_control = hcind(i, :)';             % column vector
    dot_product_subjects_all_hc{i} = v_control * v_control.'; 
end

mean_dot_product_hc = mean(cat(3, dot_product_subjects_all_hc{:}), 3);
D_control = mean_dot_product_hc;

% Dep CoM
nDep = size(depind, 1);
dot_product_subjects_all_dep = cell(nDep,1);

for i = 1:nDep
    v_dep = depind(i, :)';
    dot_product_subjects_all_dep{i} = v_dep * v_dep.';
end

mean_dot_product_dep = mean(cat(3, dot_product_subjects_all_dep{:}), 3);
D_dep = mean_dot_product_dep;

%% plot -log10 plot
%% Inputs:
% HC_mean: 68 x 68 x N1
% dep_mean: 68 x 68 x N2
%% ---------------------------------------------------------
% Step 1: Build CoM matrices for each subject

%% ---------------------------------------------------------
%% ============================================================
% Convert values from CoM matrices to Signed Log10 p-values
% Vince-style script: bar plot for loadings, then log10 CoM matrix plot
%% ============================================================

cd '/Users/amrithah/Desktop/CalhounLab/Dissertation/Projects/Chapter6_Paper_5_SPECT Template/Scripts/sc-ICA'

%% ------------------------------------------------------------
% 1) t-test on loading parameters and bar plot
%% ------------------------------------------------------------

% a: 213 x 68 matrix of loading parameters
hcind = 1:76;
szind = 77:213;

[h1, p1, ci1, stats1] = ttest2(a(hcind,:), a(szind,:));   % 1 x 68

figure;
bar(-log10(p1) .* sign(stats1.tstat));
grid on;

sigcompspos = find((mafdr(p1) < .05) .* (stats1.tstat > 0));
sigcompsneg = find((mafdr(p1) < .05) .* (stats1.tstat < 0));

x = 1:68;
xticks(x);

xlabel('NeuroMark SPECT Template Component #s (Components 1-68)')
ylabel('-log10 (p) signed values for all components')
ax = gca;
ax.FontSize = 13;
title('-log10 (p) signed t values: healthy-patient loading parameter group differences');

savefig('log10_barplot_ttest.fig');
movefile('log10_barplot_ttest.fig', ...
    '/Users/amrithah/Desktop/CalhounLab/Dissertation/Projects/Chapter6_Paper_5_SPECT Template/Figures');

%% ------------------------------------------------------------
% 2) t-tests on averaged CoM matrices (HC vs SZ)
%Make the CoM variables manually just in case for plotting 
% Controls
% Correct subject indexing
hcind  = a(1:76, :);        % 76 x 68
depind = a(77:2819, :);     % 2743 x 68

% Controls CoM
dot_product_subjects_all_hc = cell(76,1);

for i = 1:76
    v_control = hcind(i, :)';                     % 68 x 1
    dot_product_subjects_all_hc{i} = v_control * v_control.';   % 68 x 68
end

mean_dot_product_hc = mean(cat(3, dot_product_subjects_all_hc{:}), 3);
D_control = mean_dot_product_hc;

% Patients CoM
nDep = 2743;
dot_product_subjects_all_dep = cell(nDep,1);

for i = 1:nDep
    v_dep = depind(i, :)';                        % 68 x 1
    dot_product_subjects_all_dep{i} = v_dep * v_dep.';   % 68 x 68
end

mean_dot_product_dep = mean(cat(3, dot_product_subjects_all_dep{:}), 3);
D_dep = mean_dot_product_dep;

% Stack into 3‑D matrices
all_matrices_hc  = cat(3, dot_product_subjects_all_hc{:});    % 68 x 68 x 76
all_matrices_dep = cat(3, dot_product_subjects_all_dep{:});   % 68 x 68 x 2743

% Flatten for t-tests (icatb_mat2vec expects N x M x M)
HC_flat  = icatb_mat2vec(permute(all_matrices_hc,  [3 1 2]));   % 76 x edges
dep_flat = icatb_mat2vec(permute(all_matrices_dep, [3 1 2]));   % 2743 x edges

% Run t-tests on flattened edges (subjects in rows)
% Run t-tests on flattened edges
[h2, p2, ci2, stats2] = ttest2(HC_flat, dep_flat);   % p2 is 1 x 2278

% Convert vectors back to 68x68 matrices
p2_mat = icatb_vec2mat(p2);
t2_mat = icatb_vec2mat(stats2.tstat);

% Compute signed -log10(p)
logt = -log10(p2_mat) .* t2_mat;

% FDR mask
sigmask = icatb_vec2mat(fdr_calc(p2) <= 0.05);

%%Apply mask only to upper triangle
n = size(sigmask,1);
ut = triu(true(n),1);

out_masked = logt;
out_masked(ut) = logt(ut) .* sigmask(ut);

% Plot masked result
figure;
imagesc(out_masked, [-15 15]);
axis image;
colormap(whitejet);
colorbar;

xticks(tickPositions);
yticks(tickPositions);
xticklabels(uniqueCats);
yticklabels(uniqueCats);
xtickangle(90);

title('-log10(p) signed t values: Group Differences (Healthy - Patients) FDR Corrected (q < 0.05)');

savefig('log10_FDR_masked_corrected_figure.fig');