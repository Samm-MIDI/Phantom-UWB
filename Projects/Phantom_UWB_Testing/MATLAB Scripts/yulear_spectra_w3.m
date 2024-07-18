fmax_plot = 80;
norder = 1024;

figure;
zval = zeros(size(t));
plot( t, breathwave,'k',t(50:170),zval(50:170)-4e4,'r',t(160:232),zval(160:232)-3.8e4,'b')

[pxx1,f1] = pyulear(breathwave,256,norder,fs);
f1_min = 60*f1;
fmask1 = f1_min <= fmax_plot;
figure;
plot( f1_min(fmask1), pxx1(fmask1));
title('Pxx_yulear (full) vs. f [RPM]')
xlabel('f [RPM]')
ylabel('Pxx [arb]')
f_peaks = [7.768, 11.319, 15.092, 18.8654, 21.7507, 25.968]
df_peaks = diff(f_peaks)

[pxx2,f2] = pyulear(breathwave(50:170),170-50+1,norder,fs);
f2_min = 60*f2;
fmask2 = f2_min <= fmax_plot;
figure;
plot( f2_min(fmask2), pxx2(fmask2));
title('Pxx_yulear, bins 50:170 vs. f [RPM]')
xlabel('f [RPM]')
ylabel('Pxx [arb]')

[pxx3,f3] = pyulear(breathwave(160:232),(232-160+1),norder,fs);
f3_min = 60*f3;
fmask3 = f3_min <= fmax_plot;
figure;
plot( f3_min(fmask3), pxx3(fmask3));
title('Pxx_yulear, bins 160:232 vs. f [RPM]')
xlabel('f [RPM]')
ylabel('Pxx [arb]')


% f1fake_min = 15.1
f1fake_min = 17.75
f1fake_sec = f1fake_min / 60;
% f2fake_min = 20.35
% f2fake_min = 17.75
f2fake_min = 20.7
f2fake_sec = f2fake_min / 60;

fake1 = cos(2*pi*f1fake_sec*t) - 0.8*cos(2*pi*2*f2fake_sec*(t+0.4));
figure;
plot(t, fake1)
[pfake1, ffake_sec] = pyulear(fake1(50:170),170-50+1,norder,fs);
ffake_min = ffake_sec * 60;
fmaskfake = ffake_min <= fmax_plot;
figure; 
plot( ffake_min(fmaskfake), pfake1(fmaskfake))

f2bfake_min = 21.3
f2bfake_sec = f2bfake_min / 60;
fake2 =  -1.6*cos(2*pi*2*f2bfake_sec*(t+0.4));
figure;
plot(t, fake2)
[pfake2, ffake_sec] = pyulear(fake2(160:232),(232-160+1),norder,fs);
ffake_min = ffake_sec * 60;
fmaskfake = ffake_min <= fmax_plot;
figure; 
plot( ffake_min(fmaskfake), pfake2(fmaskfake))

tswitch = 11.1
tmask = t < tswitch;
fake1sw2(tmask) = fake1(tmask);
fake1sw2(~tmask) = fake2(~tmask)+ 0.35;
figure;
plot(t, fake1sw2)
[pfake1sw2, ffake_sec] = pyulear(fake1sw2,256,norder,fs);
ffake_min = ffake_sec * 60;
fmaskfake = ffake_min <= fmax_plot;
figure; 
plot( ffake_min(fmaskfake), pfake1sw2(fmaskfake))

