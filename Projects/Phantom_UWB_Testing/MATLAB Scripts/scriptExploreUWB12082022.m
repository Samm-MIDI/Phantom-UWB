% UWB Cat Feeder Tests 12/21/2022
% POC #3 with Antenna - experiments with casing
folder = 'C:\Users\lgiovangrandi\Documents\Active Projects\OHG02\Cat Experiments 12-08-2022\Data Files';
binCnt = 256;
binSet = 1:binCnt;
% Note: CoarseDelay was changed t 4 to account for 12" antenna wires


%% Dry food, antenna 70mm down
[uwb, t, fs] = importOut2File2(fullfile(folder, 'records_out2-221208180545.csv'));
frameCnt = size(uwb, 1);
%% Dry food, antenna 70mm down
[uwb, t, fs] = importOut2File2(fullfile(folder, 'records_out2-221208180623.csv'));
frameCnt = size(uwb, 1);
%% Dry food, antenna 20mm down
[uwb, t, fs] = importOut2File2(fullfile(folder, 'records_out2-221208180354.csv'));
frameCnt = size(uwb, 1);
%% Dry food, antenna 20mm down
[uwb, t, fs] = importOut2File2(fullfile(folder, 'records_out2-221208180429.csv'));
frameCnt = size(uwb, 1);


%% Wet food, antenna 70mm down
[uwb, t, fs] = importOut2File2(fullfile(folder, 'records_out2-221208181458.csv'));
frameCnt = size(uwb, 1);
%% Wet food, antenna 70mm down
[uwb, t, fs] = importOut2File2(fullfile(folder, 'records_out2-221208181537.csv'));
frameCnt = size(uwb, 1);
%% Wet food, antenna 20mm down
[uwb, t, fs] = importOut2File2(fullfile(folder, 'records_out2-221208181211.csv'));
frameCnt = size(uwb, 1);
%% Wet food, antenna 20mm down
[uwb, t, fs] = importOut2File2(fullfile(folder, 'records_out2-221208181247.csv'));
frameCnt = size(uwb, 1);



%% Standard plots

% Line plot
figure('position', [100, 500, 400, 200]);
plot(binSet, uwb);
xlim([binSet(1) binSet(end)]);
%ylim([0.5 2.5]*1e6);
xlabel('Bin');
ylabel('UWB [cnt]');
title('Overlaid Radar Frames');

% False-color plot
X = repmat(binSet(:)', frameCnt, 1);
Y = repmat((1:frameCnt)', 1, length(binSet));
figure;
surface(X, Y, (uwb-uwb(1,:)), 'EdgeColor', 'none');
xlim([1 256]);
zlabel('UWB [cnt]');
xlabel('Bin');
ylabel('Time [frame]');
title('False-color plot of Radar frames over time');

% Interactive plot
fh = figure('position', [500, 200, 600, 500]);
set(fh, 'UserData', 51, 'KeyPressFcn', {@interactiveLineScan, uwb, t, fs});
fakeEvent.Key = 'leftarrow';
interactiveLineScan([], fakeEvent, uwb, t, fs);
clear fakeEvent



%% RR & HR fused
bin = [80 93 94];	% for neck measurement
bin = [85 95 105 115];	% for apex #6
figure('position', [500, 200, 600, 500]);
subplot(3,1,1);
plot((t-t(1)), uwb(:,bin), 'linewidth', 2);
ylabel('UWB [cnt]');
title(['Bin #[' num2str(bin) ']']);
subplot(3,1,2);
plot((t-t(1)), lowpass(mean(uwb(:,bin)-mean(uwb(:,bin),1),2), 0.5, fs), 'linewidth', 2);
ylabel('Resp UWB [cnt]');
title(['Respiration from Bin #[' num2str(bin) ']']);
subplot(3,1,3);
plot((t-t(1)), lowpass((highpass(uwb(:,bin), 1, fs)), 4, fs), 'linewidth', 2);
xlabel('Time [s]');
ylabel('Pulse UWB [cnt]');
title(['Pulse from Bin #[' num2str(bin) ']']);
pause(1);

%% Pulse resampling
rs = 5;
bin = [80 93 94];	% for neck measurement
%bin = [85 95 105 115];	% for apex #6
pulse = lowpass(mean(highpass(uwb(:,bin), 1, fs), 2), 4, fs);
rspulse = lowpass(mean(highpass(resample(uwb(:,bin), rs, 1), 1, fs), 2), 4, fs);

rsPulse = resample(pulse, rs, 1);
figure
%plot((t-t(1)), pulse, 'linewidth', 2);
hold on
plot((0:length(rsPulse)-1)/(fs*rs), rsPulse, 'linewidth', 2);
hold off
xlabel('Time [s]');
ylabel('Pulse UWB [cnt]');


%% Line plot
bin = 104;
figure('position', [500, 500, 600, 300]);
plot((t-t(1)), uwb(:,bin), 'linewidth', 2);
ylabel('UWB [cnt]');
title(['Bin #' num2str(bin)]);
xlabel('Frame #');
ylabel('UWB [cnt]');


%% Line plot
bin = 150;
figure('position', [500, 500, 600, 300]);
for bin = 20:150
% 	subplot(2,1,1);
% 	plot((t-t(1)), uwb(:,bin), 'linewidth', 2);
% 	ylabel('UWB [cnt]');
% 	title(['Bin #' num2str(bin)]);
% 	subplot(2,1,2);
% 	plot((t-t(1)), lowpass(uwb(:,bin), 5, 16.66), 'linewidth', 2);
% 	xlabel('Time [s]');
% 	ylabel('Filtered UWB [cnt]');
	subplot(3,1,1);
	plot((t-t(1)), uwb(:,bin), 'linewidth', 2);
	ylabel('UWB [cnt]');
	title(['Bin #' num2str(bin)]);
	subplot(3,1,2);
	plot((t-t(1)), lowpass(uwb(:,bin), 0.5, fs), 'linewidth', 2);
	ylabel('Resp UWB [cnt]');
	subplot(3,1,3);
	plot((t-t(1)), lowpass(highpass(uwb(:,bin), 1, fs), 4, fs), 'linewidth', 2);
	xlabel('Time [s]');
	ylabel('Pulse UWB [cnt]');
	pause(1);
end

%% RR & HR
bin = 105;
figure('position', [500, 500, 600, 300]);
subplot(3,1,1);
plot((t-t(1)), uwb(:,bin), 'linewidth', 2);
ylabel('UWB [cnt]');
title(['Bin #' num2str(bin)]);
subplot(3,1,2);
plot((t-t(1)), lowpass(uwb(:,bin), 0.5, fs), 'linewidth', 2);
ylabel('Resp UWB [cnt]');
subplot(3,1,3);
plot((t-t(1)), lowpass(highpass(uwb(:,bin), 1, fs), 4, fs), 'linewidth', 2);
xlabel('Time [s]');
ylabel('Pulse UWB [cnt]');
pause(1);


%% Surface plot
X = repmat(binSet(:)', frameCnt, 1);
Y = repmat((1:frameCnt)', 1, length(binSet));
figure
surface(X, Y, uwb, 'FaceAlpha', 0.5);
view(45, 30);
xlim([1 256]);
zlabel('UWB [cnt]');
xlabel('Bin');
ylabel('Time [frame]');

%% False-color plot
X = repmat(binSet(:)', frameCnt, 1);
Y = repmat((1:frameCnt)', 1, length(binSet));
figure
surface(X, Y, uwb-mean(uwb,1), 'EdgeColor', 'none');
xlim([1 256]);
zlabel('UWB [cnt]');
xlabel('Bin');
ylabel('Time [frame]');


%% Waterfall plot
X = repmat(binSet(:)', frameCnt, 1);
Y = repmat((1:frameCnt)', 1, length(binSet));
figure
waterfall(X, Y, uwb);
view(45, 30);
zlabel('UWB [cnt]');
xlabel('Bin');
ylabel('Time [frame]');
