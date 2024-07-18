% analyzeRespirationColumn.m

% From Laurent's interactive plot
UWB_best_column = get(fh, 'UserData')

breathwave = lofsmag(:,UWB_best_column);  % From ColumnProfiler app
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