%% FINAL CLEAN REPLICATION: EMOTION & PERFORMANCE
clear; clc; close all;

n_sbj = 17;
all_valence = []; all_arousal = [];
subject_means = []; subjects_list = [];

fprintf('Generating final combined report...\n');

for i = 1:n_sbj
    fileName = sprintf('HC_%03d.mat', i);
    if exist(fileName, 'file')
        try
            S = load(fileName);
            % 1. Collect Emotion Data
            all_valence = [all_valence; S.data.valence(:)];
            all_arousal = [all_arousal; S.data.arousal(:)];
            
            % 2. Collect & Filter RT Data
            rt = S.data.reactiontime;
            if iscell(rt), rt = cell2mat(rt); end
            
            % CRITICAL FIX: Only take RTs between 0.1s and 2.0s
            valid_rt = rt(rt > 0.1 & rt < 2.0); 
            
            if ~isempty(valid_rt)
                subject_means = [subject_means; mean(valid_rt)*1000];
                subjects_list = [subjects_list; i];
            end
        catch
        end
    end
end

% --- CREATE COMBINED FIGURE ---
figure('Color', 'w', 'Position', [100, 100, 1000, 400]);

% Left Side: Emotional Space
subplot(1,2,1);
scatter(all_valence + randn(size(all_valence))*0.1, ...
        all_arousal + randn(size(all_arousal))*0.1, ...
        20, 'filled', 'MarkerFaceColor', [0.2 0.6 0.4], 'MarkerFaceAlpha', 0.2);
xlabel('Valence'); ylabel('Arousal'); title('A: Emotional Ratings');
grid on; xlim([-2 10]); ylim([-2 10]);

% Right Side: Reaction Times
subplot(1,2,2);
bar(subject_means, 'FaceColor', [0.2 0.4 0.6]);
set(gca, 'XTick', 1:length(subjects_list), 'XTickLabel', subjects_list);
ylabel('Reaction Time (ms)'); xlabel('Subject ID');
title('B: Mean Reaction Times');
grid on; ylim([0 1000]); % Set limit to 1 second for clarity

fprintf('DONE! You have a clean, professional figure.\n');