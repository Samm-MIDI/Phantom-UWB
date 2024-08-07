function [mag, phs] = demod_rows_at_frequencies(uwb, smoothF, detrend_order)
% [mag, phs] = demod_rows_at_frequencies(uwb, smoothF, detrend_order);
% Demodulate "uwb" data where each row is demoded at frequency given by the
% corresponding entry in "smoothF"
% Inputs:
%   uwb: 2D double: UWB data: Rows are in "slow" time. Cols are in "radar"
%     time.
%   smoothF: 1D double: values of frequency at which to demodulate rows of
%     "uwb"
%   detrend_order: (opt) scalar integer: order of detrending fit function
%     Default: 3

% History:
% 2024Jul29 bpw: Changed the name of "demodScanLine" to remove the "_v2"
%   suffix. The new name refers to the contents of _v2.
% 2024Jul25 bpw: Initial version extracted from
%   analyzeSubregion_SmoothDemod_3;

if nargin < 3
    detrend_order = 3;
end

doPlots = false; % Tell demodScanLine function not to make plots

nrows = size(uwb,1);
assert( nrows == length(smoothF))
mag = [];
phs = [];
for k = 1:nrows
    [thismag,thisphase] = demodScanLine(detrend(uwb(k,:),detrend_order),smoothF(k),doPlots);
    mag(k,:) = thismag;
    phs(k,:) = thisphase;
end

end