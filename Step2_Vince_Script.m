%% ------------------------------------------------------------

%%used this for the main figure plotting, I used Step2_3 for calling
%%variables for the log plots 
%  Step 0: Setup
% ------------------------------------------------------------
cd  '/Users/amrithah/Desktop/CalhounLab/Dissertation/Projects/Chapter7_Paper_6_Diss_Clinical_Outcomes/ICA_Results/Depression_ICA_Analyses_Clinical_Outcomes'

set(gca, 'FontSize', 13);
set(findall(gcf, 'type', 'text'), 'FontSize', 13); %increase font size for all figures

a = spm_read_vols(spm_vol('Depression_ICA_Output_Rest_Clinical_Outcomes_Results_group_loading_coeff_.nii'));

hcind = 1:76; %76 subjects
depind = 77:2819; %2743 subjects

nSub  = size(a,1);
nComp = size(a,2);   % number of components directly from data

%% ------------------------------------------------------------
%  Step 1: Build full connectivity matrices for each subject
% ------------------------------------------------------------
out_mat = zeros(nSub, nComp, nComp);

for j = 1:nSub
    vec = icatb_mat2vec(a(j,:)' * a(j,:));   % vectorized connectivity
    mat = icatb_vec2mat(vec);                % convert to square matrix
    out_mat(j,:,:) = mat;                    % store
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
%% ------------------------------------------------------------
%  Step 5: Plot all three matrices
% --- Plot 1 ---
plotMatrix(HC_mean_final, [-.8 .8], 'Average Control CoM');
colorbar;
ax = gca;  % current axes
set(gca, 'FontSize', 13);
text(ax, 1.12, 0.5, 'z-scored CoM values', ...
    'Units', 'normalized', ...
    'HorizontalAlignment', 'center', ...
    'VerticalAlignment', 'middle', ...
    'Rotation', 90, ...
    'FontWeight', 'bold');
set(gca, 'FontSize', 13);
%% 
% --- Plot 2 ---
plotMatrix(dep_mean_final, [-.8 .8], 'Average Patient CoM');
colorbar;

ax = gca;
set(gca, 'FontSize', 13);
text(ax, 1.12, 0.5, 'z-scored CoM values', ...
    'Units', 'normalized', ...
    'HorizontalAlignment', 'center', ...
    'VerticalAlignment', 'middle', ...
    'Rotation', 90, ...
    'FontWeight', 'bold');
set(gca, 'FontSize', 13);

%%  --- Plot 3 ---
plotMatrix(Diff_mean_final, [-.4 .4], 'Average Control - Patient CoM');
colorbar;

ax = gca;
set(gca, 'FontSize', 13);
text(ax, 1.12, 0.5, 'z-scored CoM values', ...
    'Units', 'normalized', ...
    'HorizontalAlignment', 'center', ...
    'VerticalAlignment', 'middle', ...
    'Rotation', 90, ...
    'FontWeight', 'bold');
%% ------------------------------------------------------------
%  Nested function for plotting (updated to save .fig)
% ------------------------------------------------------------
function plotMatrix(M, clim, ttl, tickPositions, uniqueCats)

    figure;
    imagesc(M, clim);
    colormap whitejet;
    axis image;
    colorbar;
    title(ttl);

    xticks(tickPositions);
    yticks(tickPositions);
    xticklabels(uniqueCats);
    yticklabels(uniqueCats);
    xtickangle(90);

    % ---- Save figure as .fig ----
    fname = [regexprep(ttl, '\s+', '_') '.fig'];
    savefig(gcf, fname);

end
