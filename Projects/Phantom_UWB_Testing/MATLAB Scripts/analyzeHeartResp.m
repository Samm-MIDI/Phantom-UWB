% analyzeHeartResp.m
heartlof = 0.4;
hearthif = 6;
resplof = 0.1;
resphif = 0.6;
[hr_sec,hr_min,heartwave,hfuwb,th] = findrate_wave(uwb,heartlof,hearthif,fs,false);
hr_sec
[respr_sec,respr_min,respwave,rfuwb,tr] = findrate_wave(uwb,resplof,resphif,fs,false);
respr_sec

skheart = skewness( heartwave);
if skheart < 0
    heartwave = -heartwave;
end

figure;
subplot(2,1,1);
plot( th, heartwave);
ylabel('Heart');
title(['Heart Rate: ',num2str(hr_min,'%.1f'), ' bpm']);
subtitle( ['File: ', escuscore(froot)])
subplot(2,1,2);
plot( tr,respwave);
ylabel('Resp');
title(['Resp Rate: ',num2str(respr_min,'%.1f'), ' resp / min']);
xlabel('t [sec]');

