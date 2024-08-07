function [naf_td_sig, f] = plot_FT_of_columns(td_sig, fs, hif_lim, lof_lim, use_per_minute)
% [naf_td_sig, f] = plot_FT_of_columns(td_sig, hif_lim, lof_lim, use_per_minute);
% Display the normed, absolute magnitude of the Fourier Transform of the
% columns of td_sig. Optionally, limit range of frequencies to display.
% Optionally, use cycles per minute vs. cycles per second (Hz).
% Inputs:
%   td_sig: 2D double: columns are signal vs time.
%   fs: scalar double: sampling frequncy in Hz
%   hif_lim: (opt) scalar: maximum frequency to display. Default: 80
%   lof_lim: (opt) scalar: minimum frequency to display. Default: 0
%   use_per_minute: (opt) boolean: state frequencies as cycles per minute.
%     Default: true.
% Outputs:
%   naf_td_sig: 2D double: columns are norm'd mag. signal vs frequency
%   f: 1D double: frequency axis values
% Note: only the plot is clipped by hif_lim & lof_lim. The values returned
%   are the full spectra.

% History:
% 2024Jul25 bpw: Initial version extracted from
%   analyzeSubregion_SmoothDemod_3;

nFT = 256;

% Process optional arguments:
if nargin < 5
    use_per_minute = true;
end
if nargin < 4
    lof_lim = 0;
end
if nargin < 3
    hif_lim = 80;
end

% Compute FT of columns and related quantities
f_td_sig = fft(td_sig,nFT,1);
% Absolute value (magnitude) of complex FT
af_td_sig = abs(f_td_sig);
% Normalized magntude of FT.
naf_td_sig = af_td_sig ./ max(af_td_sig,[],1);

% Synthesize frequency axis
f_sec = (0:(nFT-1))/(nFT-1)*fs;
f_min = f_sec*60;
if use_per_minute
    f = f_min;
    yaxlabel = '1/min.';
else
    f = f_sec;
    yaxlabel = 'Hz';
end

% Determine the mask for plotting
fmask = (lof_lim <= f) & (f <= hif_lim);
% Extract the bits
subf = f(fmask);
subnaf_td_sig = naf_td_sig(fmask,:);
ncol = size(naf_td_sig,2);
imagesc((1:ncol),subf,naf_td_sig(fmask,:));
colorbar
ylabel(['Frequency ', yaxlabel]);
title('Normd Mag of FT of columns')
end