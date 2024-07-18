function x = uwbbandpass(x, lpfreq, hpfreq, samplingRate)
% Non-causal, zero-phase low-pass filtering.
%
% In		x				Trace to be filtered
%			cutOff			Cutoff frequency in [Hz]
%			samplingRate	Sampling rate
%
% Out		x				filtered Trace

x = lowpass(highpass(x, lpfreq, samplingRate), hpfreq, samplingRate);
end