function [rr_sec,rr_min,pulsewave,fuwb,t] = findrate_wave(uwb,lpfreq, hpfreq,fs,plotFlag)
if nargin < 5
    plotFlag = false;
end
dtuwb = detrend(uwb,2);
if lpfreq == 0
    fuwb = lowpass(dtuwb, hpfreq, fs);
else
    fuwb = uwbbandpass(dtuwb, lpfreq,hpfreq, fs);
end

% Construct PCA by hand
[U,S,V] = svd( fuwb);

pulsewave = fuwb * V(:,1);
t = (1:length(pulsewave))/fs;

[rr_sec,rr_min] = reprate( pulsewave,fs);
end
