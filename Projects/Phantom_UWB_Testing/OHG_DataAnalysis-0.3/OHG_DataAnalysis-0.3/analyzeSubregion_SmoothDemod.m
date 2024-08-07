if (exist('printPlots') == 0)
    printPlots = true
end

%loadUWB
[uwb, t, fs] = importOut2File2(fullfile(folder, [froot,'.csv']));

szuwb = size(uwb);
nrows = szuwb(1);

% Demod using smooth frequency
% First calculate the smooth frequency
[smoothF, rawF] = calc_smooth_demod_freq(uwb);

% Then, do the demod
[mag, phs] = demod_rows_at_frequencies(uwb, smoothF);

% Pick out columns to work on
smag  = mag(:,check_patch_cols);
szsmag = size(smag);
ncolsmag = szsmag(2);

% Filter for heartbeat
hifsmag = uwbbandpass(smag, heartlof,hearthiNyqFactor*fs/2,fs);

% PCA by hand: get the "best" pulse wave
pulsewave = pc1_by_hand(hifsmag);

% Generate time coordinate
t = (1:length(pulsewave))/fs;

% Do sliding frequency analysis
[f_subs,t_subs] = slidingF(pulsewave,hr_sliding_f_window,hr_sliding_f_shift,t);
hr_median = 60*median(f_subs)

figure
plot_freq_per_minute = true;
rate_median = plot_sliding_f_results(t, pulsewave, t_subs, f_subs, plot_freq_per_minute)
subplot(2,1,1);
title(['Heart rate: ', escuscore(froot), '. Median Rate = ', num2str(rate_median,2)]);

if printPlots
    figure_to_1page_pdf([froot, '_HR'])
end

% Pk-Pk of waveforms
pkpk = max(pulsewave) - min(pulsewave)

%% Analyze for breathing
% Filter for breathing
lofsmag = uwbbandpass(smag, resplof,resphif,fs);

figure;
use_time_in_minutes = true;
plot_FT_of_columns(lofsmag, fs, 60, 0, use_time_in_minutes); shg
title(['FT of breathing wave: ', escuscore(froot)]);
if printPlots
    figure_to_1page_pdf([froot, '_FT_breathing'])
end

% Try using SVD on breathing
breathwave = pc1_by_hand(lofsmag);
% Generate time coordinate (This should be identical to t above.)
t = (1:length(breathwave))/fs;


% Cross-correlation vs. sliding frequency analysis
if br_do_xcorr
    [rate_permin,rate_persec,fs,pxcdata] = rate_from_xcorr(breathwave, t);
    figure;
    plot(t, breathwave);
    xlabel('time [sec]');
    ylabel('Breath waveform [1]')
    title( strcat(escuscore(froot), ' Breathing rate from xcorr: ', num2str(rate_permin,2),...
        ' BPM'));
    br_median = rate_permin;
else
    [brf_subs,brt_subs] = slidingF(breathwave,br_sliding_f_window,br_sliding_f_shift,t);
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
end

if printPlots
    figure_to_1page_pdf([froot, '_Resp'])
end
