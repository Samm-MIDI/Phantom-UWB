function x = highpass(x, cutOff, samplingRate)
% Non-causal, zero-phase high-pass filtering.
%
% In		x				Trace to be filtered
%			cutOff			Cutoff frequency in [Hz]
%			samplingRate	Sampling rate
%
% Out		x				filtered Trace

% Highpass Butterworth filter, 4th order
[b, a] = butter(4, cutOff/(samplingRate/2), 'high');

% Filter (zero-phase)
x = filtfilt(b, a, x);

