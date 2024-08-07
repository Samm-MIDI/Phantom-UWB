function rate_median = plot_sliding_f_results(twave, pwave, t_subs, f_subs, plot_freq_per_minute)
% rate_median = plot_sliding_f_results(twave, pwave, t_subs, f_subs, plot_freq_per_minute)
% Plot the results of a "sliding frequency analysis". (See slidingF.m)
% Inputs:
%   twave: 1D double: times of pwave data
%   pwave: 1D double: pulsatile waveform
%   t_subs: 1D double: times of f_subs data
%   f_subs: 1D double: frequencies at each of the sliding window positions
%   plot_freq_per_minute: (opt) boolean: if true, convert the frequency
%     data into cycles per minute. I.e. * 60. Default: true
% Outputs:
%   rate_median: the median pulsatile rate in either Hz or per minute.

% History:
% 2024Jul26 bpw: Initial version extracted from
%   analyzeSubregion_SmoothDemod_3;

if nargin < 5
    plot_freq_per_minute = true;
end

if plot_freq_per_minute
    f_factor = 60;
    f_string = ' per min';
else
    f_factor = 1;
    f_string = ' Hz';
end

% Median rate
rate_median = median(f_factor * f_subs);
    
ax1 = subplot(2,1,1);
plot(t_subs, f_factor * f_subs)
ylabel(strcat('Rate', f_string))
% Do the title in the caller
% title(['Pulse Wave: ',case_str, ', ', escuscore(froot), '. Median Rate = ', num2str(rate_median,2)]);
ax2 = subplot(2,1,2);
plot(twave,pwave)
xlabel( 'time [sec]')
% Link x axes
% ax = axis;
% axt = ax(1:2);
% subplot(2,1,1);
% ax = axis;
% ax(1:2) = axt;
% axis(ax);
linkaxes([ax1, ax2], 'x')
end