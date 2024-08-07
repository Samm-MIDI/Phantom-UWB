function [smoothF, rawF] = calc_smooth_demod_freq(uwb,fguess)
% [smoothF, rawF] = calc_smooth_demod_freq(uwb,fguess);
% Calculate a smooth demodulation frequency as a function of row number
% Frequency is allowed to be a linear function of row number
% Inputs:
%   uwb: 2D double: UWB data. Rows are vs. "slow" time. Cols are "radar"
%     time.
%   fguess (opt) scalar double: a guess at the demodulation frequency
%     Default value: 3.

% History:
% 2024Jul29 bpw: Now calls "demodScanLine" instead of with "_v2". But the
%   no-suffix name is the same as the older _v2 version. In other words,
%   this is just a name change to "demodScanLine".
% 2024Jul25 bpw: Initial version extracted from
%   "analyzeSubregion_SmoothDemod_3.m"

if nargin < 2
    fguess = 3;
end

% Given fguess compute a raw demodulation frequency for each row
nrows = size(uwb, 1);
rawF = [];
for k = 1:nrows
    [~,~,rawF(k)] = demodScanLine(detrend(uwb(k,:),fguess));
end

% Create a linear fit to rawF: smoothF
pF = polyfit(1:nrows,rawF,1);
smoothF = polyval(pF,1:nrows);

end