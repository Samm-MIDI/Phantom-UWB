
%catParams

%loadUWB
[uwb, t, fs] = importOut2File2(fullfile(folder, [froot,'.csv']));
figure;
imagesc(uwb)

dtuwb = detrend( uwb, 2);
figure
imagesc(dtuwb)

% Pick out the bit before the first discontinuity
suwb1 = uwb(smooth_rows,:);

% Take out the baseline of each column up to 2nd order.
dtsuwb1 = detrend( suwb1,2);
% figure;
% imagesc( dtsuwb1)

% Filter between 1.8 and 4 Hz
fuwb = uwbbandpass(dtsuwb1, heartlof,hearthif, fs);
% fuwb = highpass(dtsuwb1, heartlof, fs);
% fuwb = uwbbandpass(dtsuwb1, heartlof,11, fs);
figure;
imagesc( fuwb)

% Pick out the top left patch of checkerboard
s1_1fuwb = fuwb(check_patch_rows, check_patch_cols);
figure;
imagesc(s1_1fuwb)

% 2D FT
fs1_1fuwb = fft2(s1_1fuwb,256,256);
figure;
imagesc(abs(fs1_1fuwb))
% figure;
% imagesc(fftshift(abs(fs1_1fuwb)))
[peak_mag, peak_idx] = findURpeak(abs(fs1_1fuwb));
f_heart_bpm = (peak_idx(1)-1)/256*fs*60

% PCA by hand: get the "best" pulse wave
[U,S,V] = svd( s1_1fuwb);
pulsewave = s1_1fuwb * V(:,1);
t = (1:length(pulsewave))/fs;
figure
plot( t, pulsewave)
title([case_str, ', ', escuscore(froot), ', BPM = ', num2str(f_heart_bpm)]);
xlabel( 'time [sec]');
ylabel( 'UWB waveform [arb]')
% Pk-Pk of waveforms
pkpk = max(pulsewave) - min(pulsewave)
% figure;
% plot( V(:,1));
% title('V(:,1): loading of first PC')