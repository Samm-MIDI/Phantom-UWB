if (exist('printPlots') == 0)
    printPlots = true
end

%catParams

%loadUWB
[uwb, t, fs] = importOut2File2(fullfile(folder, [froot,'.csv']));
% figure;
% imagesc(uwb)

szuwb = size(uwb);
nrows = szuwb(1);

% Demod using smooth frequency
% First calculate the raw frequency
carrierF = [];
for k = 1:nrows
[~,~,carrierF(k)] = demodScanLine_v2(detrend(uwb(k,:),3));
end
pF = polyfit(1:nrows,carrierF,1);
smoothF = polyval(pF,1:nrows);
% figure; 
% plot(1:nrows,carrierF, 1:nrows,smoothF);
% Do the demod
mag = [];
phs = [];
for k = 1:nrows
[thismag,thisphase] = demodScanLine_v2(detrend(uwb(k,:),3),smoothF(k),false);
mag(k,:) = thismag;
phs(k,:) = thisphase;
end
% figure;
% % subplot(2,1,1);
% imagesc(detrend(mag,3));
% % subplot(2,1,2);
% figure;
% imagesc(detrend(phs,3));
% figure;
% imagesc(detrend(phs(:,check_patch_cols)))

% Pick out columns to work on
smag  = mag(:,check_patch_cols);
szsmag = size(smag);
ncolsmag = szsmag(2);

% Filter for heartbeat
hifsmag = uwbbandpass(smag, heartlof,hearthiNyqFactor*fs/2,fs);
% figure;
% imagesc( hifsmag)

% PCA by hand: get the "best" pulse wave
[U,S,V] = svd( hifsmag);
pulsewave = hifsmag * V(:,1);
t = (1:length(pulsewave))/fs;

% Do sliding frequency analysis
[f_subs,t_subs] = slidingF(pulsewave,32,16,t);
hr_median = 60*median(f_subs)
figure
subplot(2,1,1);
plot(t_subs,60*f_subs)
ylabel('BPM')
title(['Pulse: ',case_str, ', ', escuscore(froot), '. Median BPM = ', num2str(hr_median,3)]);
subplot(2,1,2);
plot(t,pulsewave)
xlabel( 'time [sec]')
ax = axis;
axt = ax(1:2);
subplot(2,1,1);
ax = axis;
ax(1:2) = axt;
axis(ax);
set( gcf, 'PaperSize', [7.8,5.85]);
if printPlots
    print([froot, '_HR'],'-dpdf')
end

% Pk-Pk of waveforms
pkpk = max(pulsewave) - min(pulsewave)

%% Analyze for breathing
% Filter for breathing
% Filter for heartbeat
lofsmag = uwbbandpass(smag, resplof,resphif,fs);
% figure;
% imagesc( lofsmag)

% Use the neighborhood of the biggest signal to get a breathing wave
l1lofsmag = sum(abs(lofsmag),1);
[~,maxcolidx] = max(l1lofsmag)
if (maxcolidx == ncolsmag)
    maxcolidx = maxcolidx - 1
end
if (maxcolidx == 1)
    maxcolidx = 2
end
cols = (maxcolidx-1):(maxcolidx+1)
% % PCA by hand: get the "best" breathing wave
% [loU,loS,loV] = svd( lofsmag(:,cols));
% breathwave = lofsmag(:,cols) * loV(:,1);
breathwave = sum(lofsmag(:,cols),2);
% figure;
% plot( t, breathwave);

% Sliding frequency analysis
f_analysis_width = 64;
f_analysis_shift = 4;
[brf_subs,brt_subs] = slidingF(breathwave,f_analysis_width,f_analysis_shift,t);
br_median = 60*median(brf_subs)
figure
subplot(2,1,1);
plot(brt_subs,60*brf_subs)
ylabel('RPM')
title(['Resp: ',case_str, ', ', escuscore(froot), '. Median RPM = ', num2str(br_median,2)]);
subplot(2,1,2);
plot(t,breathwave)
xlabel( 'time [sec]')
ax = axis;
axt = ax(1:2);
subplot(2,1,1);
ax = axis;
ax(1:2) = axt;
axis(ax);
set( gcf, 'PaperSize', [7.8,5.85]);
if printPlots
    print([froot, '_Resp'],'-dpdf')
end