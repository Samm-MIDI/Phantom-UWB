function [cFreq, fftResult] = carrierFreq(scanLine, sampleFreq)
% Demodulation of UWB radar

if nargin < 2,	sampleFreq = 39e9;;	end

lineLength = length(scanLine);

% Detrend scanline
scanLine = detrend(scanLine,2);

% Extract fundamental frequency
fftLength = 2^14;	%size(uwbData,1);
window = hamming(lineLength)';

fftResult = abs(fft(window .* scanLine, fftLength));

[~, fmaxIdx] = max(fftResult);
% Do a quadratic fit to three data points
fftMax = fftResult((fmaxIdx-1):(fmaxIdx+1));
fftMaxPoly = polyfit(-1:1,fftMax,2);
assert(fftMaxPoly(1)<0);
fftMaxLocal = -fftMaxPoly(2)/(2*fftMaxPoly(1));
fPulse = fmaxIdx + fftMaxLocal;

cFreq = (fPulse * sampleFreq) / (2*floor(fftLength/2));

end