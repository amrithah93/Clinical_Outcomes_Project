%%  Spatial_Component_Visualization_FDR_Corrected.m to view these sorted components from the loading parameter analysis
%previous scripts cleaned p and q values, labelled per NM 2.2 domain and
%subdomain, then sorted by domain and subdomain for visualization purposes
%Load SPECT_CoM_Workspace 
% get into the right path first
cd  '/Users/amrithah/Desktop/CalhounLab/Dissertation/Projects/Chapter7_Paper_6_Diss_Clinical_Outcomes/ICA_Results/Depression_ICA_Analyses_Clinical_Outcomes'
%% Plot significant q values from bar plot from the SPECT SZ analysis here
%all 18 components plotted together
% Ordered list of components, q vals that were significant
comps = sig_idx_q;  

% Build file list
files = cell(1, numel(comps));
for i = 1:numel(comps)
    files{i} = sprintf('Depression_ICA_Output_Rest_Clinical_Outcomes_Results_group_component_ica_.nii,%d', comps(i));
end

% Display all components in ONE montage figure
icatb_image_viewer(files, ...
    'display_type','montage', ...
    'structfile', fullfile(fileparts(which('gift.m')), ...
    'icatb_templates','shrunk_single_subj_T1.nii'), ...
    'threshold', 5.0, ... 
    'slices_in_mm', (-60:8:60), ...
    'convert_to_zscores', 'yes', ...
    'image_values', 'positive', ...
    'iscomposite','yes');

title ('All Domain and Subdomain Components Displayed (FDR Corrected): Loading Parameter Group Differences Plotted '); 
set(gca, 'FontSize', 13);

% Save the figure
savefig('AllComponents_Ordered_FDR_Corrected.fig');