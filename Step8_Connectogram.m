%final figure - plot connectograms from general group difference
%correlations healthy-controls, and also the FDR corrected results from the
%bar plot
%display -log10(q) signed values, same as what was done in step 4 but just
%displayed differently
fname = 'Depression_ICA_Output_Rest_Clinical_Outcomes_Results_group_component_ica_.nii';
%% --- Extract significant edges and values from logplot  ---
n = size(sigmask,1);

% Upper triangle mask
ut_matrix = triu(true(n),1);

% Significant edges (FDR-corrected)
sig_edges = sigmask & ut_matrix;

% Extract component pairs
[Comp1, Comp2] = find(sig_edges);

% Extract corresponding significant values
Values = out_masked(sig_edges);

% Map components to domain labels
Domain1 = Labels(Comp1);
Domain2 = Labels(Comp2);

% Build final clean table
SigTable = table(Comp1, Comp2, Domain1, Domain2, Values, ...
    'VariableNames', {'Comp1', 'Comp2', 'Domain1', 'Domain2', 'Value'});

%% --- Build full connectivity matrix C for connectogram ---
C = zeros(n);          % start with all zeros
C(sig_edges) = Values; % fill significant upper-triangle values
C = C + C.';           % mirror to lower triangle

%% --- Use full 68 labels (connectogram requires all nodes) ---
% Note to self: structure script this way for each of the domains/subdomains to have it's
% own color block in the legend; if you do loops, it will separate out each
% color block in it's own way, which is confusing 
comp_network_names = {
    'cerebellar', [1 2 3 4 5,6,7,8,9];
    'HC-FR', [10,11,12,13,14,15,16,17,18];            
    'HC-TP', [19,20,21,22,23,24,25,26,27,28 ];   
    'HC-IT', [29,30,31];
    'SC-BG', [32,33];      
    'SC-EH', [34,35,36,37];
    'SC-ET', 38;
    'sensorimotor', [39,40,41,42,43,44,45,46,47,48,49];
    'TN-DM', [50,51,52,53,54,55,56];
    'TN-SA', [57,58];
    'VI-OC', [59,60,61,62,63,64,65,66,67,68];
    };  
%% --- Plot connectogram ---
icatb_plot_connectogram([], comp_network_names, ...
    'C', C, ...
    'threshold', 2, ... %brain image thresholds for pictures above component, don't touch
    'conn_threshold', 2.0460, ... %threshold = 2.0460 determined from t-test pval = 0.05
    'image_file_names', fname, ...
    'colorbar_label', 'Corr', ...
    'display_type', 'render', ...
    'convert_to_zscores', 0, ...
    'slice_plane', 'sagittal', ...
    'exclude_zeros', 1, ...
    'CLIM', [-15, 15]);
savefig('Connectogram_Group_PVal_LogTransformed_ZeroedOut_Results.fig');