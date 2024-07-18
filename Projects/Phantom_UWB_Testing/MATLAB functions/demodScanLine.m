function [mag, phase,fPulse] = demodScanLine(scanLine, plotFlag)
% Demodulation of UWB radar

if nargin < 2,	plotFlag = true;	end

lineLength = length(scanLine);

% Detrend scanline
scanLine = detrend(scanLine);

% Extract fundamental frequency
x2SamplingRate = 39e9;		% 39 GHz on average

fftLength = 2^14;	%size(uwbData,1);
window = hamming(lineLength)';

fftResult = abs(fft(window .* scanLine, fftLength));

% if plotFlag
% 	figure;
% 	fftResult = fftResult(1:floor(fftLength/2)+1);
% 	plot((x2SamplingRate/2)*[0:floor(fftLength/2)]/floor(fftLength/2), fftResult, 'linewidth', 2);
% 	xlabel('Frequency [Hz]');
% 	ylabel('PSD');
% end

[~, fPulse] = max(fftResult);
fPulse = (fPulse * x2SamplingRate) / (2*floor(fftLength/2));

% Generate quadrature oscillators (Note: OneHealth uses +/-45deg rather
% than 0/90, but the result (mag, phase) is the same.
tRef = [0:lineLength-1] / x2SamplingRate;
sineRef = sin(tRef * 2*pi * fPulse);
cosineRef = cos(tRef * 2*pi * fPulse);

% Demodulate
I = scanLine .* sineRef;
Q = scanLine .* cosineRef;

% Low-pass (poor-man's envelope - could use something else here)
lpI = lowpass(I, 1.5e9, x2SamplingRate);
lpQ = lowpass(Q, 1.5e9, x2SamplingRate);

% Magnitude and phase
mag = sqrt(lpI.^2 + lpQ.^2);
phase = unwrap(angle(lpI + 1j*lpQ));

if plotFlag
	figure(222);
	subplot(5,1,1);
	plot(scanLine, 'linewidth', 1);
	title(sprintf('Detrended Scan Line (fPulse = %.1f GHz)', fPulse/1e9));
	subplot(5,1,2);
	plot([I; Q]', 'linewidth', 1);
	title('I/Q');
	subplot(5,1,3);
	plot([lpI; lpQ]', 'linewidth', 1);
	title('Low-passed I/Q');
	subplot(5,1,4);
	plot(mag, 'linewidth', 1);
	title('Magnitude');
	subplot(5,1,5);
	plot(phase, 'linewidth', 1);
	title('Unwrapped Phase');
end





