function [rate_permin,rate_persec,fs,pxcdata] = rate_from_xcorr(data,t_or_fs, do_bkg_sub)
data = data(:);   % Convert to column vector
if nargin < 3
    do_bkg_sub = true;
end
if nargin < 2
    fs = 1;
    t = (0:(length(data)-1)'/fs);
end
if isscalar( t_or_fs)
    fs = t_or_fs;
    t = (0:(length(data)-1)'/fs);
else
    t = t_or_fs(:);
    fs = 1/mean(diff(t));
end

% If flag, subtract linear background
if do_bkg_sub
    p1 = polyfit(t,data,1);
    zdata = data - polyval(p1,t);
else    % else, just subtract mean value
    zdata = data - mean(data);
end

% Do the xcorr
[xcdata, lags] = xcorr(zdata);

% Now, pick apart the waveform to find the right peak
% Only use positive lags
maskpos = lags >=0;
pxcdata = xcdata(maskpos);
plags = lags(maskpos);
% Find the first negative peak
[minxc,minxcidx] = min(pxcdata);
% Zero out stuff to the left
pxcdata(1:minxcidx) = 0;
% Now, find the first positive peak
[maxxc, maxxcidx] = max( pxcdata);
period = plags(maxxcidx) / fs;
rate_persec = 1/period;
rate_permin = rate_persec * 60;
end