 %calculate mean of controls and patient data for loading parameters
 %using a barplot but also HC > SZ, and SZ > HC spatial maps
 cd  '/Users/amrithah/Desktop/CalhounLab/Dissertation/Projects/Chapter7_Paper_6_Diss_Clinical_Outcomes/ICA_Results/Depression_ICA_Analyses_Clinical_Outcomes'

hcind = 1:76; %76 subjects
depind = 77:2819; %2743 subjects

hcmn = mean(a(hcind,:));
depmn = mean(a(depind,:));  

 %% plot the significant components in a bar plot for the new neuromark spect loading parameters
% Data for the bars
data = hcmn - depmn;  %mean difference, with significant ones stars

% Define positions for each bar for clarity in plotting
positions = 1:length(data);

% Define the positions where stars will be added for significant results:
% total 18 significant components
%star_positions_qval_onestar; all were q< 0.01
star_positions_qval_twostar = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20,21,22,23,24,25,26,27,28,29,30,31,32,33,34,35,36,37];  %q<0.01 

% Plot the bars individually to set specific colors
%plot all NeuroMark 2.2 domains and subdomains
%Update order after renaming and moving a component (Comp 7) from cerebellum to TN-DM
%(comp 43)
hold on; % Allows multiple bars to be plotted on the same figure
bar1 = bar(positions(1:12), data(1:12), 'FaceColor', 'red'); % Cerebellar
bar2 = bar(positions(13:22), data(13:22), 'FaceColor', 'green'); % HC-FR
bar3 = bar(positions(23:24), data(23:24), 'FaceColor', 'blue'); % HC-IT
bar4= bar(positions(25), data(25), 'FaceColor', 'cyan'); % HC-TP
bar5= bar(positions(26:27), data(26:27), 'FaceColor', 'magenta'); % paralimbic
bar6= bar(positions(28), data(28), 'FaceColor', 'yellow'); % SC-BG
bar7= bar(positions(29:31), data(29:31), 'FaceColor', 'black'); % SC-EH
bar8= bar(positions(32:34), data(32:34), 'FaceColor', 'red'); % SC-ET
bar9= bar(positions(35:40), data(35:40), 'FaceColor', 'green'); % sensorimotor
bar10= bar(positions(41:42), data(41:42), 'FaceColor', 'blue'); %TN-CE
bar11= bar(positions(43:47), data(43:47), 'FaceColor', 'cyan'); %TN-DM
bar12= bar(positions(48:49), data(48:49), 'FaceColor', 'magenta'); %TN-SA
bar13= bar(positions(50:57), data(50:57), 'FaceColor', 'yellow'); %VI-OC
bar14= bar(positions(58:60), data(58:60), 'FaceColor', 'black'); %VI-OT

% Add single stars (*) above specified bars
for i = 1:length(star_positions_qval_onestar)
    pos = star_positions_qval_onestar(i); % Current bar position
    text(pos, data(pos) + 0.01, '*', 'HorizontalAlignment', 'center', 'FontSize', 14, 'Color', 'k');
end

% Add double stars (**) above specified bars
for i = 1:length(star_positions_qval_twostar)
    pos = star_positions_qval_twostar(i); % Current bar position
    text(pos, data(pos) + 0.01, '**', 'HorizontalAlignment', 'center', 'FontSize', 14, 'Color', 'k');
end

% Add title, labels, and legend
title('Healthy - Patient Mean Loading Parameters Plotted along with Group Difference t-test FDR corrected results (q < 0.05)')
xlabel('NeuroMark SPECT Template Component #s (Components 1-60)')
ylabel('Loading Parameter Values')
L1 = {'cerebellar', 'HC-FR', 'HC-IT', 'HC-TP', 'paralimbic', 'SC-BG', 'SC-EH', 'SC-ET', 'sensorimotor', 'TN-CE', 'TN-DM', 'TN-SA', 'VI-OC', 'VI-OT'}; % Define legend with the NM 2.2 Domains and Subdomains
lgd1 = legend(L1, 'Location', 'northwest');

% Set x-axis tick labels
x = 1:60; % Label components for the tickmarks
xticks(x); % Set the tickmarks

hold on;

ax = gca;
ax.FontSize = 13;

%save file
%make sure to stretch image out before saving! else text gets all jumbled
%up
savefig('Significant_Components_FDR_Corrected_Bar_Plot.fig');