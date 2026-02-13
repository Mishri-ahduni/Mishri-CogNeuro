clear all; clc;
folderPath = 'C:\Users\Dell\Downloads\Cog nwueo data';
cd(folderPath);

%% 1. Load Data 
% Assuming your raw data follows the structure discussed: 
% Trials with NA_Signal, Pupil_Signal, Arousal, and StimulusType
load('Synthetic_CogNeuro_Data.mat'); 

%% 2. Processing Parameters (Based on Bang et al. 2023)
fs = 100; % Sampling frequency
t = (1:size(syntheticData(1).NA_Signal, 2)) / fs; % Time vector
win_start = 0.5; % 0.5s baseline 
win_end = 1.5;   % 1s window centered on stimulus 

%% 3. Contrast Analysis: High vs Low Arousal Oddballs
% The paper finds that pupil-NA coupling is positive in High Arousal 
% but negative/neutral in Low Arousal for Oddball stimuli[cite: 424, 85].

% Filter trials
idxHighOdd = strcmp({syntheticData.Arousal}, 'High') & strcmp({syntheticData.Stimulus}, 'Oddball');
idxLowOdd = strcmp({syntheticData.Arousal}, 'Low') & strcmp({syntheticData.Stimulus}, 'Oddball');

% Calculate Averages
avgNA_High = mean(vertcat(syntheticData(idxHighOdd).NA_Signal), 1);
avgNA_Low = mean(vertcat(syntheticData(idxLowOdd).NA_Signal), 1);

%% 4. Plotting Results (The "Bang et al." Figure Style)
figure('Color', 'w', 'Position', [100, 100, 800, 400]);

% Plot NA Responses
subplot(1, 2, 1); hold on;
plot(t, avgNA_High, 'r', 'LineWidth', 2, 'DisplayName', 'High Arousal Oddball');
plot(t, avgNA_Low, 'b', 'LineWidth', 2, 'DisplayName', 'Low Arousal Oddball');
xline(1.0, '--k', 'Stimulus Onset'); % 1s Stimulus duration [cite: 556]
title('Noradrenaline (NA) Dynamics');
xlabel('Time (s)'); ylabel('Signal (Z-score)');
legend('Location', 'best'); grid on;

% Plot Pupil-NA Correlation (HMM Style approximation)
subplot(1, 2, 2);
high_na = avgNA_High;
high_pupil = mean(vertcat(syntheticData(idxHighOdd).Pupil_Signal), 1);
scatter(high_na, high_pupil, 10, 'filled', 'MarkerFaceColor', 'r');
lsline; % Add trend line
title('Pupil-NA Coupling (High Arousal)');
xlabel('NA Estimate'); ylabel('Pupil Dilation');
grid on;

fprintf('Analysis complete. Results reflect modulation of attention by arousal[cite: 424].\n');