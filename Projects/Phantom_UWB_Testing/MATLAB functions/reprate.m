function [fmx_sec, fmx_min] = reprate(pcuwb,fs)
[Fpcuwb,zuwb,f,pidx] = pulseFFT(pcuwb,fs,2,false);
aFpcuwb = abs( Fpcuwb);
% Find max
[maxamp,imx] = max(aFpcuwb);
fmx_sec = f(imx);
fmx_min = fmx_sec * 60;
end