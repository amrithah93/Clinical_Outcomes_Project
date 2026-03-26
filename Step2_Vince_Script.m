%% ------------------------------------------------------------

%%used this for the main figure plotting, I used Step2_3 for calling
%%variables for the log plots 
%  Step 0: Setup
% ------------------------------------------------------------
cd '/Users/amrithah/Desktop/CalhounLab/Dissertation/Projects/Chapter7_Paper_6_Diss_Clinical_Outcomes/ICA_Results/Depression_ICA_Analyses_Clinical_Outcomes';

% Load group loading coefficients
a = spm_read_vols(spm_vol('Depression_ICA_Output_Rest_Clinical_Outcomes_Results_group_loading_coeff_.nii'));

% Basic info
nSub  = size(a,1);
nComp = size(a,2);

% Subject groups
hcind  = a(1:76);
depind =a(77:2819);

% Preallocate connectivity matrices
out_mat = zeros(nSub, nComp, nComp);

% Build connectivity matrices
for j = 1:nSub
    C = a(j,:)' * a(j,:);   % outer product = connectivity
    out_mat(j,:,:) = C;
end

out_clean = out_mat;
%% ------------------------------------------------------------
%  Step 4: Compute group means
% ------------------------------------------------------------
HC_mean   = squeeze(mean(out_clean(hcind,:,:)));
dep_mean   = squeeze(mean(out_clean(depind,:,:)));
Diff_mean = HC_mean - dep_mean;

%% 
% Step 5: Reorder within domain for the 3 matrices
HC_mean_final = HC_mean;
dep_mean_final = dep_mean;
Diff_mean_final = Diff_mean; 

%% --- Make domain/subdomain labels appear only once ---

% Convert categorical → cell array if needed
Labels = cellstr(Labels);

% Find unique categories in order of appearance
[uniqueCats, ~, idx] = unique(Labels, 'stable');

% Tick positions = first occurrence of each category
tickPositions = arrayfun(@(u) find(idx == u, 1, 'first'), 1:numel(uniqueCats));

%% for controls plot
figure;
imagesc(HC_mean_final, [-.8 .8]);
colormap whitejet;
axis image;
colorbar;
title('Average Control CoM');

xticks(tickPositions);
yticks(tickPositions);

xticklabels(uniqueCats);
yticklabels(uniqueCats);

xtickangle(90);

savefig('Average_Control_CoM.fig');
%%  for patients plot
figure;
imagesc(dep_mean_final, [-.8 .8]);
colormap whitejet;
axis image;
colorbar;
title('Average Patient CoM');

xticks(tickPositions);
yticks(tickPositions);

xticklabels(uniqueCats);
yticklabels(uniqueCats);

xtickangle(90);

savefig('Average_Patient_CoM.fig');
%% for diff plots
figure;
imagesc(Diff_mean_final, [-.4 .4]);
colormap whitejet;
axis image;
colorbar;
title('Average Control - Patient CoM');

xticks(tickPositions);
yticks(tickPositions);

xticklabels(uniqueCats);
yticklabels(uniqueCats);

xtickangle(90);

savefig('Average_Control_minus_Patient_CoM.fig');