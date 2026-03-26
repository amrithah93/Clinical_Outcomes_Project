 %calculate mean of controls and patient data for loading parameters
 %using a barplot but also HC > SZ, and SZ > HC spatial maps
 cd  '/Users/amrithah/Desktop/CalhounLab/Dissertation/Projects/Chapter7_Paper_6_Diss_Clinical_Outcomes/ICA_Results/Depression_ICA_Analyses_Clinical_Outcomes'

hcmn = mean(a(hcind,:));
depmn = mean(a(depind,:));  

% Plot significant components for NeuroMark SPECT loading parameters
% plot the significant components in a bar plot for the new neuromark spect loading parameters

data = hcmn - depmn;   % mean difference

positions = 1:length(data);

% Define significance positions
star_positions_qval_onestar = [];   % none in your description
star_positions_qval_twostar = [2,6,8,9,10,14,15,16,17,18,19,21,22,23,25,26,27,28,29,30,32,33,35,36,38,39,41,43,48,49,50,52,53,54,55,56,57,58,59,62,63,65,66,68]; % all 44 are q < 0.01

figure; 
hold on;

% --- Plot each NeuroMark domain separately (your original structure) ---

bar1  = bar(positions(1:9),   data(1:9),   'FaceColor', 'red');          % cerebellar
bar2  = bar(positions(10:18), data(10:18), 'FaceColor', 'green');        % HC-FR
bar3  = bar(positions(19:28), data(19:28), 'FaceColor', 'blue');         % HC-TP
bar4  = bar(positions(29:31), data(29:31), 'FaceColor', 'cyan');         % HC-IT
bar5  = bar(positions(32:33), data(32:33), 'FaceColor', 'magenta');      % SC-BG
bar6  = bar(positions(34:37), data(34:37), 'FaceColor', 'yellow');       % SC-EH
bar7  = bar(positions(38),    data(38),    'FaceColor', [0.8 0.4 1]);    % SC-ET
bar8  = bar(positions(39:49), data(39:49), 'FaceColor', [0.3 0.8 0.9]);  % sensorimotor
bar9  = bar(positions(50:56), data(50:56), 'FaceColor', [0.9 1.0 0.9]);    % TN-DM
bar10 = bar(positions(57:58), data(57:58), 'FaceColor', [1 0.5 0]);      % TN-SA
bar11 = bar(positions(59:68), data(59:68), 'FaceColor', [0 0.8 0.8]);    % VI-OC

% --- Add stars for significance ---

% Single stars (none defined, but keeping structure)
for i = 1:length(star_positions_qval_onestar)
    pos = star_positions_qval_onestar(i);
    text(pos, data(pos) + 0.02, '*', ...
        'HorizontalAlignment', 'center', 'FontSize', 14, 'Color', 'k');
end

% Double stars (your 37 significant components)
for i = 1:length(star_positions_qval_twostar)
    pos = star_positions_qval_twostar(i);
    text(pos, data(pos) + 0.02, '**', ...
        'HorizontalAlignment', 'center', 'FontSize', 14, 'Color', 'k');
end

% --- Labels, title, legend ---

title('Healthy - Patient Mean Loading Parameters with FDR-corrected Significant Components (all values significant at q <0.05 and < 0.01)');
xlabel('NeuroMark SPECT Template Component #s (1–68)');
ylabel('Loading Parameter Values');

legend({'cerebellar','HC-FR','HC-TP','HC-IT','SC-BG','SC-EH','SC-ET', ...
        'sensorimotor','TN-DM','TN-SA','VI-OC'}, ...
        'Location','northwest');

xticks(1:68);

ax = gca;
ax.FontSize = 13;

% Save figure
savefig('Significant_Components_FDR_Corrected_Bar_Plot.fig');