% analyzeHeartResp.m

%Need to specify file location & name to run
%folder = '/MATLAB Drive';
%[uwb, t, fs] = importOut2File2(fullfile(folder, 'records_out2-221221152111_2.csv'));

%Human Parameters
heartlof = 0.8;
hearthif = 4; %adjusted from 6
resplof = 0.1;
resphif = 0.6;

%Cat Parameters
%heartlof = 2;
%hearthif = 6;
%resplof = 0.5;
%resphif = 1.2;


[hr_sec,hr_min,heartwave,hfuwb,th] = findrate_wave(uwb,heartlof,hearthif,fs,false);
hr_sec;
[respr_sec,respr_min,respwave,rfuwb,tr] = findrate_wave(uwb,resplof,resphif,fs,false);
respr_sec;

skheart = skewness( heartwave);
if skheart < 0
    heartwave = -heartwave;
end
%% 

figure;
subplot(2,1,1);
plot( th, heartwave);
ylabel('Heart');
title(['Heart Rate: ',num2str(hr_min,'%.1f'), ' bpm']);
%subtitle( ['File: ', escuscore(froot)])
subplot(2,1,2);
plot( tr,respwave);
ylabel('Resp');
title(['Resp Rate: ',num2str(respr_min,'%.1f'), ' resp / min']);
xlabel('t [sec]');

%% 

%Functions to run

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



    function [fmx_sec, fmx_min] = reprate(pcuwb,fs)
    [Fpcuwb,zuwb,f,pidx] = pulseFFT(pcuwb,fs,2,false);
    aFpcuwb = abs( Fpcuwb);
    % Find max
    [maxamp,imx] = max(aFpcuwb);
    fmx_sec = f(imx);
    fmx_min = fmx_sec * 60;

        function [F1zuwb,zuwb,f,pfidx] = pulseFFT(fuwb,fs,kos, plotFlag)
        if nargin < 4;
            plotFlag = false;
        end
        if nargin < 3;
            kos = 1;  % Oversample factor
        end
        
        zuwb = fuwb - mean(fuwb,1);
        szuwb = size(zuwb);
        nt = szuwb(1);
        nbins = szuwb(2);
        knt_2 = kos * nt / 2;
        assert( rem(kos*nt,2) == 0)
        
        % Construct frequency axis
        fidx = [0:(knt_2-1),-knt_2:-1];
        fnyq = fs/2;
        f = fidx/knt_2*fnyq;
        pfidx = 1:knt_2;
        
        % Do FFT
        F1zuwb = fft(zuwb, kos*nt, 1);
        psdF1zuwb = sum(abs(F1zuwb(pfidx,:)).^2,2);
        
        % Plots?
        if plotFlag
            figure;
            imagesc(zuwb)
            colorbar
        %     figure;
        %     plot(f)
            figure;
            imagesc( abs(F1zuwb.^2))
            figure;
            plot(f(pfidx),abs((F1zuwb(pfidx,:)).^2))
            xlabel('frequency [Hz]')
            figure;
            plot(f(pfidx),psdF1zuwb)
            xlabel('frequency [Hz]')
        end

        end

    end

end
