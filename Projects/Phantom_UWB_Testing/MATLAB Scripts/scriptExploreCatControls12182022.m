% UWB Cat Feeder Tests 12/14/2022
% POC #3 with Antenna - experiments with casing
binCnt = 256;
binSet = 1:binCnt;
% Note: CoarseDelay was changed to 4 to account for 12" antenna wires


%% Dry food, antenna 20mm down 15 Hz
folder = 'C:\Users\lgiovangrandi\Documents\Active Projects\OHG02\Cat Experiments 12-14-2022\20mm';
[uwb, t, fs] = importOut2File2(fullfile(folder, 'records_out2-221214183829.csv'));
frameCnt = size(uwb, 1);

%% Brian's analysis
dtuwb = detrend( uwb, 2);
figure(200)
imagesc(dtuwb)

% Select ROI
suwb1 = uwb;

% Take out the baseline of each column up to 2nd order.
dtsuwb1 = detrend( suwb1,2);
figure(201)
imagesc( dtsuwb1)

% Filter between 1.8 and 4 Hz (along bins)
fuwb = uwbbandpass(dtsuwb1, 1.8,4, fs);
figure(202)
imagesc( fuwb)
%fuwb = highpass(dtsuwb1, 1, fs);

% Pick out the top left patch of checkerboard
s1_1fuwb = fuwb(60:105, 70:95);
figure;
imagesc(s1_1fuwb)
%s1_1fuwb = fuwb;

% 2D FT
figure(203);
imagesc(abs(fft2(s1_1fuwb,300,256)))
% figure;
% imagesc(fftshift(abs(fft2(s1_1fuwb,256,256))))

% PCA by hand: get the "best" pulse wave
[U,S,V] = svd( s1_1fuwb);
pulsewave = s1_1fuwb * V(:,1);
t = (1:length(pulsewave))/fs;
figure(204)
plot( t, pulsewave)


%% Dry food, antenna 20mm down - 24 Hz
folder = 'C:\Users\lgiovangrandi\Documents\Active Projects\OHG02\Cat Experiments 12-14-2022\20mm';
[uwb, t, fs] = importOut2File2(fullfile(folder, 'records_out2-221214184022.csv'));
frameCnt = size(uwb, 1);

%% Demodulate
for k = 1:size(uwb, 1)
	uwb(k,:) = demodScanLine(uwb(k,:), false);
end

%% Brian's analysis
dtuwb = detrend( uwb, 2);
figure(200)
imagesc(dtuwb)

% Select ROI
suwb1 = uwb;

% Take out the baseline of each column up to 2nd order.
dtsuwb1 = detrend( suwb1,2);
figure(201)
imagesc( dtsuwb1)

% Filter between 1.8 and 4 Hz (along bins)
fuwb = uwbbandpass(dtsuwb1, 1.8,4, fs);
figure(202)
imagesc( fuwb)
%fuwb = highpass(dtsuwb1, 1, fs);

% Pick out the top left patch of checkerboard
s1_1fuwb = fuwb(17:32,53:120);
s1_1fuwb = fuwb(80:135, 55:105);
figure;
imagesc(s1_1fuwb)
%s1_1fuwb = fuwb;

% 2D FT
figure(203);
imagesc(abs(fft2(s1_1fuwb,300,256)))
% figure;
% imagesc(fftshift(abs(fft2(s1_1fuwb,256,256))))

% PCA by hand: get the "best" pulse wave
[U,S,V] = svd( s1_1fuwb);
pulsewave = s1_1fuwb * V(:,1);
t = (1:length(pulsewave))/fs;
figure(204)
plot( t, pulsewave)

%% Control 15 Hz
folder = 'C:\Users\lgiovangrandi\Documents\Active Projects\OHG02\Cat Experiments 12-14-2022\No Cat';
[uwb, t, fs] = importOut2File2(fullfile(folder, 'records_out2-221216130229_control_15Hz.csv'));
frameCnt = size(uwb, 1);

%% Brian's analysis
dtuwb = detrend( uwb, 2);
figure(200)
imagesc(dtuwb)

% Select ROI
suwb1 = uwb;

% Take out the baseline of each column up to 2nd order.
dtsuwb1 = detrend( suwb1,2);
figure(201)
imagesc( dtsuwb1)

% Filter between 1.8 and 4 Hz (along bins)
fuwb = uwbbandpass(dtsuwb1, 1.8,4, fs);
figure(202)
imagesc( fuwb)
fuwb = highpass(dtsuwb1, 1, fs);

% Pick out the top left patch of checkerboard
s1_1fuwb = fuwb(150:190, 55:110);
figure;
imagesc(s1_1fuwb)
%s1_1fuwb = fuwb;

% 2D FT
figure(203);
imagesc(abs(fft2(s1_1fuwb,300,256)))
% figure;
% imagesc(fftshift(abs(fft2(s1_1fuwb,256,256))))

% PCA by hand: get the "best" pulse wave
[U,S,V] = svd( s1_1fuwb);
pulsewave = s1_1fuwb * V(:,1);
t = (1:length(pulsewave))/fs;
figure(204)
plot( t, pulsewave)


%% Control 24 Hz
folder = 'C:\Users\lgiovangrandi\Documents\Active Projects\OHG02\Cat Experiments 12-14-2022\No Cat';
[uwb, t, fs] = importOut2File2(fullfile(folder, 'records_out2-221216130331_control_24Hz.csv'));
frameCnt = size(uwb, 1);

%% Demodulate
for k = 1:size(uwb, 1)
	uwb(k,:) = demodScanLine(uwb(k,:), false);
end

%% Brian's analysis
dtuwb = detrend( uwb, 2);
figure(200)
imagesc(dtuwb)

% Select ROI
suwb1 = uwb;

% Take out the baseline of each column up to 2nd order.
dtsuwb1 = detrend( suwb1,2);
figure(201)
imagesc( dtsuwb1)

% Filter between 1.8 and 4 Hz (along bins)
fuwb = uwbbandpass(dtsuwb1, 0.4,4, fs);
figure(202)
imagesc( fuwb)

% Pick out the top left patch of checkerboard
s1_1fuwb = fuwb(65:120, 55:110);
figure;
imagesc(s1_1fuwb)
%s1_1fuwb = fuwb;

% 2D FT
figure(203);
imagesc(abs(fft2(s1_1fuwb,300,256)))
% figure;
% imagesc(fftshift(abs(fft2(s1_1fuwb,256,256))))

% PCA by hand: get the "best" pulse wave
[U,S,V] = svd( s1_1fuwb);
pulsewave = s1_1fuwb * V(:,1);
t = (1:length(pulsewave))/fs;
figure(204)
plot( t, pulsewave)


%% on apex, handheld, battery on back
folder = 'C:\Users\lgiovangrandi\Documents\Active Projects\OHG01\Experiments\06102022';
[uwb, t, fs] = importOut2File2(fullfile(folder, 'records_out2-220610-3.csv'));
frameCnt = size(uwb, 1);
% good bins: 93 103 113

%% Brian's analysis
dtuwb = detrend( uwb, 2);
figure(200)
imagesc(dtuwb)

% Select ROI
suwb1 = uwb;

% Take out the baseline of each column up to 2nd order.
dtsuwb1 = detrend( suwb1,2);
figure(201)
imagesc( dtsuwb1)

% Filter between 1.8 and 4 Hz (along bins)
fuwb = uwbbandpass(dtsuwb1, 0.5,4, fs);
figure(202)
imagesc( fuwb)
%fuwb = highpass(dtsuwb1, 1, fs);

% Pick out the top left patch of checkerboard
s1_1fuwb = fuwb(180:300, 80:120);
figure;
imagesc(s1_1fuwb)
%s1_1fuwb = fuwb;

% 2D FT
figure(203);
imagesc(abs(fft2(s1_1fuwb,300,256)))
% figure;
% imagesc(fftshift(abs(fft2(s1_1fuwb,256,256))))

% PCA by hand: get the "best" pulse wave
[U,S,V] = svd( s1_1fuwb);
pulsewave = s1_1fuwb * V(:,1);
t = (1:length(pulsewave))/fs;
figure(204)
plot( t, pulsewave)
