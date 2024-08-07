% test_plots.m

figure;
x = 1:size(uwb,2);
y = t;
xlab = 'index';
ylab = 't [sec]';
image_2Duwb(uwb, x, y, xlab, ylab);
title( '"Raw" UWB Signal')

figure;
image_2Duwb(mag, x, y, xlab, ylab);
title( 'Magnitude of demodulated signal')

figure;
image_2Duwb(phs, x, y, xlab, ylab);
title( 'Phase of demodulated signal')

figure;
x = check_patch_cols;
image_2Duwb(smag, x, y, xlab, ylab);
title( 'Subset of Columns of Magnitude')

figure;
image_2Duwb(hifsmag, x, y, xlab, ylab);
title( 'Magnitude High-Pass-Filtered along Columns')

figure;
plot(t, pulsewave)
xlabel('time [sec]')
ylabel('Amplitudee [arb]')
title( 'Heartbeat Waveform: First PC of the Columns');

figure;
x = check_patch_cols;
image_2Duwb(lofsmag, x, y, xlab, ylab);
title( 'Magnitude Band-Pass-Filtered along Columns')

