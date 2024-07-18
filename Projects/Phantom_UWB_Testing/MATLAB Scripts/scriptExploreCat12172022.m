% UWB Cat Feeder Tests 12/14/2022
% POC #3 with Antenna - experiments with casing
folder = 'C:\Users\lgiovangrandi\Documents\Active Projects\OHG02\Cat Experiments 12-14-2022\20mm';
binCnt = 256;
binSet = 1:binCnt;
% Note: CoarseDelay was changed to 4 to account for 12" antenna wires

folder = 'C:\Users\lgiovangrandi\Documents\Active Projects\OHG02\Cat Experiments 12-21-2022 (Cat #2)\20mm';
[uwb, t, fs] = importOut2File2(fullfile(folder, 'records_out2-221221152111_2.csv'));
[uwb, t, fs] = importOut2File2(fullfile(folder, 'records_out2-221221152142.csv'));
[uwb, t, fs] = importOut2File2(fullfile(folder, 'records_out2-221221152812.csv'));
[uwb, t, fs] = importOut2File2(fullfile(folder, 'records_out2-221221152410.csv'));

[uwb, t, fs] = importOut2File2(fullfile(folder, 'records_out2-221221152410_1.csv'));
[uwb, t, fs] = importOut2File2(fullfile(folder, 'records_out2-221221152648_2.csv'));
[uwb, t, fs] = importOut2File2(fullfile(folder, 'records_out2-221221152221_2.csv'));
frameCnt = size(uwb, 1);


%% Dry food, antenna 20mm down
[uwb, t, fs] = importOut2File2(fullfile(folder, 'records_out2-221214183829.csv'));
frameCnt = size(uwb, 1);
%% Dry food, antenna 20mm down
[uwb, t, fs] = importOut2File2(fullfile(folder, 'records_out2-221214183909.csv'));
frameCnt = size(uwb, 1);
%% Dry food, antenna 20mm down
[uwb, t, fs] = importOut2File2(fullfile(folder, 'records_out2-221214183947.csv'));
frameCnt = size(uwb, 1);
%% Dry food, antenna 20mm down
[uwb, t, fs] = importOut2File2(fullfile(folder, 'records_out2-221214184022.csv'));
frameCnt = size(uwb, 1);

%%
folder = 'C:\Users\lgiovangrandi\Documents\Active Projects\OHG02\Cat Experiments 12-14-2022\60mm';

%% Dry food, antenna 70mm down -XXXXX
[uwb, t, fs] = importOut2File2(fullfile(folder, 'records_out2-221214184139.csv'));
frameCnt = size(uwb, 1);
%% Dry food, antenna 70mm down
[uwb, t, fs] = importOut2File2(fullfile(folder, 'records_out2-221214184218.csv'));
frameCnt = size(uwb, 1);
%% Dry food, antenna 70mm down
[uwb, t, fs] = importOut2File2(fullfile(folder, 'records_out2-221214184257.csv'));
frameCnt = size(uwb, 1);
%% Dry food, antenna 70mm down - XXXX
[uwb, t, fs] = importOut2File2(fullfile(folder, 'records_out2-221214184332.csv'));
frameCnt = size(uwb, 1);



%% test files 12-16-2022
folder = 'C:\Users\lgiovangrandi\Documents\Active Projects\OHG02\Cat Experiments 12-14-2022\No Cat';
[uwb, t, fs] = importOut2File2(fullfile(folder, 'records_out2-221216130229_control_15Hz.csv'));
frameCnt = size(uwb, 1);

%% test files 12-16-2022
folder = 'C:\Users\lgiovangrandi\Documents\Active Projects\OHG02\Cat Experiments 12-14-2022\No Cat';
[uwb, t, fs] = importOut2File2(fullfile(folder, 'records_out2-221216130331_control_24Hz.csv'));
frameCnt = size(uwb, 1);

%% test files 12-16-2022
folder = 'C:\Users\lgiovangrandi\Documents\Active Projects\OHG02\Cat Experiments 12-14-2022\No Cat';
[uwb, t, fs] = importOut2File2(fullfile(folder, 'records_out2-221216130819_HumanSternum_24Hz.csv'));
frameCnt = size(uwb, 1);

%% test files 12-16-2022
folder = 'C:\Users\lgiovangrandi\Documents\Active Projects\OHG02\Cat Experiments 12-14-2022\No Cat';
[uwb, t, fs] = importOut2File2(fullfile(folder, 'records_out2-221216130508_box_1.csv'));
frameCnt = size(uwb, 1);


%% Demodulate
for k = 1:size(uwb, 1)
	uwb(k,:) = demodScanLine(uwb(k,:), false);
end

%% Detrend
%uwb = uwb - uwb(1,:);
uwb = detrend(uwb, 2);

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
surface(X, Y, (uwb), 'EdgeColor', 'none');
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

%% Brian's analysis
dtuwb = detrend( uwb, 2);
figure(300)
imagesc(dtuwb)

% Select ROI
suwb1 = uwb;

% Take out the baseline of each column up to 2nd order.
dtsuwb1 = detrend( suwb1,2);
figure(301)
imagesc( dtsuwb1)

% Filter between 1.8 and 4 Hz (along bins)
fuwb = uwbbandpass(dtsuwb1, 1.8,4, fs);
figure(302)
imagesc( fuwb)
%fuwb = highpass(dtsuwb1, 0.5, fs);

% Pick out the top left patch of checkerboard
s1_1fuwb = fuwb(1:75,53:120);
%s1_1fuwb = fuwb(280:360, 90:130);
figure;
imagesc(s1_1fuwb)
%s1_1fuwb = fuwb;

% 2D FT
figure(303);
imagesc(abs(fft2(s1_1fuwb,300,256)))
% figure;
% imagesc(fftshift(abs(fft2(s1_1fuwb,256,256))))

% PCA by hand: get the "best" pulse wave
[U,S,V] = svd( s1_1fuwb);
pulsewave = s1_1fuwb * V(:,1);
%pulsewave = s1_1fuwb * V(:,1) + s1_1fuwb * V(:,2) + s1_1fuwb * V(:,3) + s1_1fuwb * V(:,4) + s1_1fuwb * V(:,5) + s1_1fuwb * V(:,6) + s1_1fuwb * V(:,7);
t = (1:length(pulsewave))/fs;
figure(304)
plot( t, pulsewave)