%% BEHAVIOURAL REPLICATION: EMOTIONAL SPACE (ROBUST VERSION)
clear; clc; close all;

n_sbj = 17;
all_valence = [];
all_arousal = [];
subjects_found = 0;

fprintf('Analyzing Behavioural data for 17 subjects...\n');

for i = 1:n_sbj
    fileName = sprintf('HC_%03d.mat', i);
    
    if exist(fileName, 'file')
        try
            % We load the file into a temporary structure 'S' 
            % This is safer than loading directly into the workspace
            S = load(fileName); 
            
            % Check if the 'data' variable exists inside the file
            if isfield(S, 'data')
                all_valence = [all_valence; S.data.valence(:)];
                all_arousal = [all_arousal; S.data.arousal(:)];
                subjects_found = subjects_found + 1;
                fprintf('Successfully loaded Subject %d\n', i);
            end
        catch
            % If Subject 10 is broken, this will catch the error and keep going
            fprintf('!! Warning: Could not open %s (File may be corrupted). Skipping...\n', fileName);
        end
    else
        fprintf('Note: %s not found. Skipping...\n', fileName);
    end
end

% 2. Create the Figure
if subjects_found > 0
    figure('Color', 'w', 'Name', 'Valence-Arousal Space');
    hold on;
    
    % Adding jitter for better visibility
    v_jitter = all_valence + (randn(size(all_valence)) * 0.1);
    a_jitter = all_arousal + (randn(size(all_arousal)) * 0.1);
    
    scatter(v_jitter, a_jitter, 40, 'filled', ...
            'MarkerFaceColor', [0.2 0.6 0.5], 'MarkerFaceAlpha', 0.2);
    
    xlabel('Valence (Emotional Tone: 1=Neg, 9=Pos)');
    ylabel('Arousal (Intensity: 1=Calm, 9=Excited)');
    title(['Emotional Ratings Map (N=' num2str(subjects_found) ' subjects)']);
    
    grid on; xlim([0 10]); ylim([0 10]);
    
    % Add a reference line for the "Neutral" center
    line([5 5], [0 10], 'Color', 'r', 'LineStyle', '--', 'HandleVisibility', 'off');
    
    fprintf('SUCCESS! Figure generated using %d subjects.\n', subjects_found);
else
    fprintf('ERROR: No valid data files could be read.\n');
end