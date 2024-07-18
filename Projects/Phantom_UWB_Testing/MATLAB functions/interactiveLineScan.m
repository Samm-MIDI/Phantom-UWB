function interactiveLineScan(src, event, uwbData, tVect, samplingRate)

FOCUS = 'HR';
max_bin = width( uwbData);
currentBin = get(gcf, 'UserData');
switch event.Key
	case 'leftarrow'
		currentBin = max(1, currentBin - 1);
	case 'rightarrow'
		currentBin = min(currentBin + 1, max_bin);
	otherwise
		return
end
set(gcf, 'UserData', currentBin);

%uwbData = uwbData - uwbData(:, 160);

% detrendedUWB = highpass(uwbData(:,currentBin), 0.2, samplingRate);
detrendedUWB = uwbData(:,currentBin);

% Plot
axh(1) = subplot(4,1,1);
plot((tVect-tVect(1)), uwbData(:,currentBin), 'linewidth', 2);
ylabel('UWB [cnt]');
title(['Time-Series for Bin #' num2str(currentBin)]);
axh(2) = subplot(4,1,2);
plot((tVect-tVect(1)), detrendedUWB, 'linewidth', 2);
ylabel('Detrended UWB [cnt]');
axh(3) = subplot(4,1,3);
switch FOCUS
	case 'HR'
		filteredUWB = lowpass(highpass(uwbData(:,currentBin), 1, samplingRate), 4, samplingRate);
	case 'RR'
		filteredUWB = lowpass(highpass(uwbData(:,currentBin), 0.2, samplingRate), 4, samplingRate);
end
plot((tVect-tVect(1)), filteredUWB, 'linewidth', 2);
ylabel('Filtered UWB [cnt]');
xlabel('Time [s]');
linkaxes(axh, 'x');

axh(4) = subplot(4,1,4);
fftLength = 1024;	%size(uwbData,1);
% window = hamming(size(uwbData,1));
% scaling = fftLength / sum(window);
% 
% spectrum = fft(window .* (uwbData(:,currentBin)-mean(uwbData(:,currentBin))),...
% 				fftLength);
% spectrum = spectrum(1:floor(fftLength/2)+1);
% spectrum(2:end) = 2 * spectrum(2:end);
% spectrum = abs(spectrum)/fftLength;
% spectrum = spectrum * scaling;
% plot((samplingRate/2)*[0:floor(fftLength/2)]/floor(fftLength/2), 10*log10(spectrum), 'linewidth', 2);
% xlabel('Frequency [Hz]');
% ylabel('PSD');

segLen = round(length(detrendedUWB)/1);
[psd, f] = pwelch(detrendedUWB, segLen, round(0.95*segLen), fftLength, samplingRate);
%plot(f, 10*log10(psd), 'linewidth', 2);
plot(f, psd, 'linewidth', 2);
ylim([-1e10 1e10])
xlabel('Frequency [Hz]');
ylabel('PSD');
