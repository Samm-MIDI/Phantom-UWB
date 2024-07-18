% UWB Tests 06/10/2022
% POC #3 with Antenna - experiments with casing
folder = '.';
binCnt = 256;
binSet = 1:binCnt;

% UWB Settings
% 		"StaggeredPRF": 1,
% 		"PRF": 100000000.0,
% 		"DACmin": 0,
% 		"PGSelect": 0,
% 		"PulsesPerStep": 70,
% 		"PRFDivide": 1,
% 		"DACstep": 8,
% 		"SweepMode": 1,
% 		"MediumDelay": 0,
% 		"FineDelay": 0,
% 		"Iterations": 45,
% 		"DACmax": 8184,
% 		"MasterClockDivide": 0,
% 		"SendEveryPulse": 0,
% 		"ContinuousPulseMode": 0,
% 		"CoarseDelay": 2


%% on chest, handheld, battery on back
[uwb, t, fs] = importOut2File2(fullfile(folder, 'records_out2-220610-1.csv'));
frameCnt = size(uwb, 1);
% good bins: 114 125

%% on chest, handheld, battery on back - repeat
[uwb, t, fs] = importOut2File2(fullfile(folder, 'records_out2-220610-2.csv'));
frameCnt = size(uwb, 1);

%% on apex, handheld, battery on back
[uwb, t, fs] = importOut2File2(fullfile(folder, 'records_out2-220610-3.csv'));
frameCnt = size(uwb, 1);
% good bins: 93 103 113

%% held on chest, casing with battery
[uwb, t, fs] = importOut2File2(fullfile(folder, 'records_out2-220610-4.csv'));
frameCnt = size(uwb, 1);

%%  held on chest, casing with battery - repeat
[uwb, t, fs] = importOut2File2(fullfile(folder, 'records_out2-220610-5.csv'));
frameCnt = size(uwb, 1);

%% held on apex, casing with battery
[uwb, t, fs] = importOut2File2(fullfile(folder, 'records_out2-220610-6.csv'));
frameCnt = size(uwb, 1);
% Good bin: 105

%% held on atria, casing with battery
[uwb, t, fs] = importOut2File2(fullfile(folder, 'records_out2-220610-7.csv'));
frameCnt = size(uwb, 1);
% Good bin: 

%% held on neck, casing with battery
[uwb, t, fs] = importOut2File2(fullfile(folder, 'records_out2-220610-8.csv'));
frameCnt = size(uwb, 1);
% Good bin: 80 76 93 94 87

%% held on chest, casing with battery - repeat - not good
[uwb, t, fs] = importOut2File2(fullfile(folder, 'records_out2-220610-9.csv'));
frameCnt = size(uwb, 1);
% Good bin:

%% split antenna, chest, 5 mm gap
[uwb, t, fs] = importOut2File2(fullfile(folder, 'records_out2-220610-10.csv'));
frameCnt = size(uwb, 1);
% Good bin: 

%% split antenna, chest, 20 mm gap
[uwb, t, fs] = importOut2File2(fullfile(folder, 'records_out2-220610-11.csv'));
frameCnt = size(uwb, 1);
% Good bin: 

%% split antenna, apex, 10 mm gap
[uwb, t, fs] = importOut2File2(fullfile(folder, 'records_out2-220610-12.csv'));
frameCnt = size(uwb, 1);
% Good bin: 86 97 98, -91 -92


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
figure
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
% bin = [85 95 105 115];	% for apex #6
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
% bin = 104;
figure('position', [500, 500, 600, 300]);
plot((t-t(1)), uwb(:,bin), 'linewidth', 2);
ylabel('UWB [cnt]');
title(['Bin #' num2str(bin)]);
xlabel('Frame #');
ylabel('UWB [cnt]');


%% Line plot
% bin = 150;
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
% bin = 105;
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
surface(X, Y, uwb, 'EdgeColor', 'none');
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


%% Local functions
function interactiveLineScan(src, event, uwbData, tVect, samplingRate)
	currentBin = get(gcf, 'UserData');
	switch event.Key
		case 'leftarrow'
			currentBin = max(1, currentBin - 1);
		case 'rightarrow'
			currentBin = min(currentBin + 1, 256);
		otherwise
			return
	end
	set(gcf, 'UserData', currentBin);
	% Plot
	subplot(3,1,1);
	plot((tVect-tVect(1)), uwbData(:,currentBin), 'linewidth', 2);
	ylabel('UWB [cnt]');
	title(['Time-Series for Bin #' num2str(currentBin)]);
	subplot(3,1,2);
	plot((tVect-tVect(1)), lowpass(uwbData(:,currentBin), 0.5, samplingRate), 'linewidth', 2);
	ylabel('Resp UWB [cnt]');
	subplot(3,1,3);
	plot((tVect-tVect(1)), lowpass(highpass(uwbData(:,currentBin), 1, samplingRate), 4, samplingRate), 'linewidth', 2);
	xlabel('Time [s]');
	ylabel('Pulse UWB [cnt]');
	linkaxes(get(gcf, 'children'), 'x');
	%xlim([0 10]);
end