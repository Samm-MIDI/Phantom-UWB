szuwb = size(uwb)
nrows = szuwb(1)
% for k = 1:nrows
% [thismag,thisphase] = demodScanLine(uwb(k,:),true);
% mag(k,:) = thismag;
% phs(k,:) = thisphase;
% end
% figure;
% imagesc(mag)
% imagesc(detrend(mag,3));
% imagesc(phs)
% imagesc(detrend(phs,3));
% smag = mag(:,55:103);
% imagesc(detrend(smag,3));
% for k = 1:nrows
% [thismag,thisphase,thisf] = demodScanLine(uwb(k,:),true);
% mag(k,:) = thismag;
% phs(k,:) = thisphase;
% fPulse(k) = thisf;
% end
% plot(fPulse)
% close all
% plot(fPulse)
% [thismag,thisphase,thisf] = demodScanLine(uwb(20,:),true);
% figure;
% plot(fftResult)
% pxx = pyulear(uwb(20,:),512,1024);
% pxx = pyulear(uwb(20,:),256,1024);
% plot(pxx)
% figure;
% plot(pxx)
% (pxx,f) = pyulear(uwb(20,:),256,1024,39e9);
% [pxx,f] = pyulear(uwb(20,:),256,1024,39e9);
% plot(f,pxx)
% [pxx,f] = pyulear(detrend(uwb(20,:),3),256,1024,39e9);
% plot(f,pxx)
% [thismag,thisphase,thisf] = demodScanLine(detrend(uwb(20,:),3),false);
% fPulse/x2SamplingRate
% fPulse/fftLength*x2SamplingRate
% [thismag,thisphase,thisf] = demodScanLine(detrend(uwb(20,:),3),false);
% [thismag,thisphase,thisf] = demodScanLine_v2(detrend(uwb(20,:),3),false);
% thisf
% [thismag,thisphase,thisf] = demodScanLine_v2(detrend(uwb(20,:),3),false);
% thisf
% [thismag,thisphase,thisf] = demodScanLine_v2(detrend(uwb(20,:),3),false);
% [thismag,thisphase,thisf] = demodScanLine_v2(detrend(uwb(20,:),3));
% thisf
% [thismag,thisphase,thisf] = demodScanLine_v2(detrend(uwb(20,:),3),thisf);
% [thismag,thisphase,thisf] = demodScanLine_v2(detrend(uwb(20,:),3),0.9*thisf);
% [thismag,thisphase,thisf] = demodScanLine_v2(detrend(uwb(20,:),3),thisf);
% [thismag,thisphase,thisf] = demodScanLine_v2(detrend(uwb(20,:),3));
% [thismag,thisphase,thisf] = demodScanLine_v2(detrend(uwb(20,:),3),thisf);
carrierF = [];
for k = 1:nrows
[~,~,carrierF(k)] = demodScanLine_v2(detrend(uwb(k,:),3));
end
figure; plot(carrierF)
pF = polyfit(1:nrows,carrierF,1);
smoothF = polyval(pF,1:nrows);
plot(1:nrows,carrierF, 1:nrows,smoothF);

mag = [];
phs = [];
for k = 1:nrows
[thismag,thisphase] = demodScanLine_v2(detrend(uwb(k,:),3),smoothF(k),true);
mag(k,:) = thismag;
phs(k,:) = thisphase;
end
figure;
imagesc(phs);
imagesc(detrend(phs,3));
imagesc(detrend(mag,3));
imagesc(uwb);
imagesc(detrend(mag,3));
smag  = mag(:,55:105);
imagesc( detrend(smag,3));
hifsmag = uwbbandpass(smag, heartlof,0.45*fs,fs);
fsmag = uwbbandpass(smag, heartlof,7, fs);
imagesc(hifsmag)
plot(mean(fsmag(:,40:end),2));
fs/5.9
ans*60
lfsmag = uwbbandpass(smag, 0.3,heartlof, fs);
imagesc(lfsmag)
plot(mean(lfsmag(:,40:end),2));
101/6
fs/ans
ans*60
[pxx,f] = pyulear(mean(lfsmag(:,40:end),2),256,1024,fs);
plot(f,pxx);
heartlof
lfsmag = uwbbandpass(smag, 0.2,1, fs);
imagesc(lfsmag)
[pxx,f] = pyulear(mean(lfsmag(:,40:end),2),256,1024,fs);
plot(f,pxx);
lfsmag = uwbbandpass(smag, 0.3,1.2, fs);
[pxx,f] = pyulear(mean(lfsmag(:,40:end),2),256,1024,fs);
plot(f,pxx);
plot(mean(lfsmag(:,40:end),2));
lfsmag = uwbbandpass(smag, 0.3,1.8, fs);
[pxx,f] = pyulear(mean(lfsmag(:,40:end),2),256,1024,fs);
plot(mean(lfsmag(:,40:end),2));
plot(f,pxx);
plot(mean(lfsmag(:,40:end),2));
t
t = (1:nrows)/fs;
plot(t)
plot(t,mean(lfsmag(:,40:end),2));
smoothmag = mag;
smoothphs = phs;
for k = 1:nrows
[thismag,thisphase] = demodScanLine_v2(detrend(uwb(k,:),3));
mag(k,:) = thismag;
phs(k,:) = thisphase;
end
figure;
plot(t,mean(lfsmag(:,40:end),2));
title('LF using smooth demod freq')
figure;
smag = mag(:,55:103);
lfsmag = uwbbandpass(smag, 0.3,1.8, fs);
plot(t,mean(lfsmag(:,40:end),2));
title('LF using jagged demod freq');