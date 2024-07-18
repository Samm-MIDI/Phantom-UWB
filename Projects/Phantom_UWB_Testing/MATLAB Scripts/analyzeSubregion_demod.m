
%catParams

%loadUWB
[uwb, t, fs] = importOut2File2(fullfile(folder, [froot,'.csv']));
figure;
imagesc(uwb)

% Demod each row
szuwb = size(uwb);
nrows = szuwb(1);
mag = [];
phs = [];
for k = 1:nrows
    [mag(k,:),phs(k,:),fPulse(k)] = demodScanLine(uwb(k,:),false);
end
figure;
imagesc(mag); colorbar
figure;
imagesc(phs); colorbar

dtmag = detrend( mag, 3);
figure
imagesc(dtmag)

% Pick out the bit before the first discontinuity
smag = mag(smooth_rows,:);

% Take out the baseline of each column up to 3rd order.
dtsmag = detrend( smag,3);
figure;
imagesc( dtsmag)


% Filter between 1.8 and 11 Hz
fmag = uwbbandpass(dtsmag, heartlof,0.9*fs/2, fs);
% fuwb = highpass(dtsuwb1, heartlof, fs);
% fuwb = uwbbandpass(dtsuwb1, heartlof,11, fs);
figure;
imagesc( fmag(:,check_patch_cols))

smagpeak = sum(fmag(:,20:32),2);
smagtredge = sum(fmag(:,35:45),2);

figure;
subplot(2,1,1);
plot(smagpeak);
subplot(2,1,2);
plot(smagtredge);

% % Pick out the top left patch of checkerboard
% s1_1fuwb = fuwb(check_patch_rows, check_patch_cols);
% figure;
% imagesc(s1_1fuwb)
% 
% % 2D FT
% fs1_1fuwb = fft2(s1_1fuwb,256,256);
% figure;
% imagesc(abs(fs1_1fuwb))
% % figure;
% % imagesc(fftshift(abs(fs1_1fuwb)))
% [peak_mag, peak_idx] = findURpeak(abs(fs1_1fuwb));
% f_heart_bpm = (peak_idx(1)-1)/256*fs*60
% 
% PCA by hand: get the "best" pulse wave
rows = 10:50;
% cols =  24:36;
cols =  12:24;  % Lot's of features in pulsewave.
sfmag = fmag(rows,cols);
[U,S,V] = svd( sfmag);
if mean(V(:,1)) > 0
    V(:,1) = -V(:,1);
end
pulsewave = sfmag * V(:,1);
t = (1:length(pulsewave))/fs;

% Look at power spectra for heart rate
[pxx,f_s] = pyulear(pulsewave,length(pulsewave),1024,fs);
f_m = f_s*60;
figure;
plot(f_m,pxx)
% Pick out peak
[~,pkidx] = max(pxx);
f_heart_bpm = f_m(pkidx)

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
figure; plot(V(:,1))
