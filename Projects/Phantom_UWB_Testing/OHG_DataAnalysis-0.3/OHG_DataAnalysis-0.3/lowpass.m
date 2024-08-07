function x = lowpass(x, cutOff, samplingRate)
% Non-causal, zero-phase low-pass filtering.
%
% In		x				Trace to be filtered
%			cutOff			Cutoff frequency in [Hz]
%			samplingRate	Sampling rate
%
% Out		x				filtered Trace

% Lowpass Butterworth filter, 4th order
[b, a] = butter(4, cutOff/(samplingRate/2), 'low');

% Filter (zero-phase)
x = filtfilt(b, a, x);
