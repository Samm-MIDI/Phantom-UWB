% UWB Phantom Testing Template
%Just import your data and run the script

binCnt = 256;
binSet = 1:binCnt;

%Start of Day- Add folder for data
folder = '/MATLAB Drive/Data/uwb_records_out-240802'; %Change to your file path

%Copy-paste these lines to import data, swap out the file name to your data file
   % [uwb, t, fs] = importOut2File2(fullfile(folder,'113701_60BPM_0RPM_Step0.csv')); %
   % [uwb, t, fs] = importOut2File2(fullfile(folder,'113742_75BPM_0RPM_Step0.csv')); %
   % [uwb, t, fs] = importOut2File2(fullfile(folder,'113823_90BPM_0RPM_Step0.csv')); %
   % [uwb, t, fs] = importOut2File2(fullfile(folder,'113904_105BPM_0RPM_Step0.csv'));%
%
    [uwb, t, fs] = importOut2File2(fullfile(folder,'113904_105BPM_0RPM_Step0.csv'));%
    [uwb, t, fs] = importOut2File2(fullfile(folder,'113904_105BPM_0RPM_Step0.csv'));% Only the LAST uncommented test will run!


frameCnt = size(uwb, 1);

%% Load control (no motors running)

%Importing is the same as with normal data, copy paste import lines, adjust file names

%08/02/2024
folder = '/MATLAB Drive/Data/uwb_records_out-240802';
[uwbRef, t, fs] = importOut2File2(fullfile(folder,'084248_0BPM_0RPM_Step0.csv')); %Control test with no motors running

uwbRef = uwbRef(100,:);

%% Demodulate

for k = 1:size(uwb, 1)
	uwb(k,:) = demodScanLine(uwb(k,:), false);
end

%% Detrend
%uwb = uwb - uwb(1,:);
uwb = detrend(uwb, 2);

%% Remove reference (control)

uwb = uwb - repmat(uwbRef, frameCnt, 1);
%This is like removing a DC offset, it does nothing to change a
%frequency-based analysis

%% analyzeHeartResp

%Human Parameters
heartlof = 0.6; %adjusted from 0.8
hearthif = 5; %adjusted from 6
resplof = 0.1;
resphif = 0.6;

%Cat Parameters
%heartlof = 2;
%hearthif = 6;
%resplof = 0.5;
%resphif = 1.2;

[hr_sec,hr_min,heartwave,hfuwb,th] = findrate_wave(uwb,heartlof,hearthif,fs,false,1);
hr_sec
[respr_sec,respr_min,respwave,rfuwb,tr] = findrate_wave(uwb,resplof,resphif,fs,false,2);
respr_sec


skheart = skewness( heartwave);
if skheart < 0
    heartwave = -heartwave;
end

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

%% PLOTS (Uncomment out which you'd like to display)
% % PCA by hand: get the "best" pulse wave
% sub_uwb = uwb(:,55:105);
% [U,S,V] = svd( sub_uwb);
% pulsewave = sub_uwb * V(:,1);
% %pulsewave = sub_uwb * V(:,1) + sub_uwb * V(:,2) + sub_uwb * V(:,3) + sub_uwb * V(:,4) + sub_uwb * V(:,5) + sub_uwb * V(:,6) + sub_uwb * V(:,7);
% t = (1:length(pulsewave))/fs;
% figure(304)
% plot( t, pulsewave)
% plot( t, highpass(pulsewave, 0.5, fs))
% 
% % Line plot
% figure('position', [100, 500, 400, 200]);
% plot(binSet, uwb);
% xlim([binSet(1) binSet(end)]);
% %ylim([0.5 2.5]*1e6);
% xlabel('Bin');
% ylabel('UWB [cnt]');
% title('Overlaid Radar Frames');
% 
% % False-color plot
% X = repmat(binSet(:)', frameCnt, 1);
% Y = repmat((1:frameCnt)', 1, length(binSet));
% figure;
% surface(X, Y, (uwb), 'EdgeColor', 'none');
% xlim([1 256]);
% zlabel('UWB [cnt]');
% xlabel('Bin');
% ylabel('Time [frame]');
% title('False-color plot of Radar frames over time');
% 
% % Interactive plot
% fh = figure('position', [500, 200, 600, 500]);
% set(fh, 'UserData', 51, 'KeyPressFcn', {@interactiveLineScan, uwb, t, fs});
% fakeEvent.Key = 'leftarrow';
% interactiveLineScan([], fakeEvent, uwb, t, fs);
% clear fakeEvent
% 
% % RR & HR fused
% bin = [80 93 94];	% for neck measurement
% bin = [85 95 105 115];	% for apex #6
% figure('position', [500, 200, 600, 500]);
% subplot(3,1,1);
% plot((t-t(1)), uwb(:,bin), 'linewidth', 2);
% ylabel('UWB [cnt]');
% title(['Bin #[' num2str(bin) ']']);
% subplot(3,1,2);
% plot((t-t(1)), lowpass(mean(uwb(:,bin)-mean(uwb(:,bin),1),2), 0.5, fs), 'linewidth', 2);
% ylabel('Resp UWB [cnt]');
% title(['Respiration from Bin #[' num2str(bin) ']']);
% subplot(3,1,3);
% plot((t-t(1)), lowpass((highpass(uwb(:,bin), 1, fs)), 4, fs), 'linewidth', 2);
% xlabel('Time [s]');
% ylabel('Pulse UWB [cnt]');
% title(['Pulse from Bin #[' num2str(bin) ']']);
% pause(1);
% 
% % Pulse resampling
% rs = 5;
% bin = [80 93 94];	% for neck measurement
% %bin = [85 95 105 115];	% for apex #6
% pulse = lowpass(mean(highpass(uwb(:,bin), 1, fs), 2), 4, fs);
% rspulse = lowpass(mean(highpass(resample(uwb(:,bin), rs, 1), 1, fs), 2), 4, fs);
% 
% rsPulse = resample(pulse, rs, 1);
% figure
% %plot((t-t(1)), pulse, 'linewidth', 2);
% hold on
% plot((0:length(rsPulse)-1)/(fs*rs), rsPulse, 'linewidth', 2);
% hold off
% xlabel('Time [s]');
% ylabel('Pulse UWB [cnt]');
% 
% 
% % Line plot
% bin = 104;
% figure('position', [500, 500, 600, 300]);
% plot((t-t(1)), uwb(:,bin), 'linewidth', 2);
% ylabel('UWB [cnt]');
% title(['Bin #' num2str(bin)]);
% xlabel('Frame #');
% ylabel('UWB [cnt]');
% 
% 
% % Line plot
% bin = 150;
% figure('position', [500, 500, 600, 300]);
% for bin = 20:150
% % 	subplot(2,1,1);
% % 	plot((t-t(1)), uwb(:,bin), 'linewidth', 2);
% % 	ylabel('UWB [cnt]');
% % 	title(['Bin #' num2str(bin)]);
% % 	subplot(2,1,2);
% % 	plot((t-t(1)), lowpass(uwb(:,bin), 5, 16.66), 'linewidth', 2);
% % 	xlabel('Time [s]');
% % 	ylabel('Filtered UWB [cnt]');
% 	subplot(3,1,1);
% 	plot((t-t(1)), uwb(:,bin), 'linewidth', 2);
% 	ylabel('UWB [cnt]');
% 	title(['Bin #' num2str(bin)]);
% 	subplot(3,1,2);
% 	plot((t-t(1)), lowpass(uwb(:,bin), 0.5, fs), 'linewidth', 2);
% 	ylabel('Resp UWB [cnt]');
% 	subplot(3,1,3);
% 	plot((t-t(1)), lowpass(highpass(uwb(:,bin), 1, fs), 4, fs), 'linewidth', 2);
% 	xlabel('Time [s]');
% 	ylabel('Pulse UWB [cnt]');
% 	pause(1);
% end
% 
% % RR & HR
% bin = 105;
% figure('position', [500, 500, 600, 300]);
% subplot(3,1,1);
% plot((t-t(1)), uwb(:,bin), 'linewidth', 2);
% ylabel('UWB [cnt]');
% title(['Bin #' num2str(bin)]);
% subplot(3,1,2);
% plot((t-t(1)), lowpass(uwb(:,bin), 0.5, fs), 'linewidth', 2);
% ylabel('Resp UWB [cnt]');
% subplot(3,1,3);
% plot((t-t(1)), lowpass(highpass(uwb(:,bin), 1, fs), 4, fs), 'linewidth', 2);
% xlabel('Time [s]');
% ylabel('Pulse UWB [cnt]');
% pause(1);
% 
% 
% % Surface plot
% X = repmat(binSet(:)', frameCnt, 1);
% Y = repmat((1:frameCnt)', 1, length(binSet));
% figure
% surface(X, Y, uwb, 'FaceAlpha', 0.5);
% view(45, 30);
% xlim([1 256]);
% zlabel('UWB [cnt]');
% xlabel('Bin');
% ylabel('Time [frame]');
% 
% % False-color plot
% X = repmat(binSet(:)', frameCnt, 1);
% Y = repmat((1:frameCnt)', 1, length(binSet));
% figure
% surface(X, Y, uwb-mean(uwb,1), 'EdgeColor', 'none');
% xlim([1 256]);
% zlabel('UWB [cnt]');
% xlabel('Bin');
% ylabel('Time [frame]');
% 
% 
% % Waterfall plot
% X = repmat(binSet(:)', frameCnt, 1);
% Y = repmat((1:frameCnt)', 1, length(binSet));
% figure
% waterfall(X, Y, uwb);
% view(45, 30);
% zlabel('UWB [cnt]');
% xlabel('Bin');
% ylabel('Time [frame]');
% 
% %% Brian's analysis
% dtuwb = detrend( uwb, 2);
% figure(300)
% imagesc(dtuwb)
% 
% % Select ROI
% suwb1 = uwb;
% 
% % Take out the baseline of each column up to 2nd order.
% dtsuwb1 = detrend( suwb1,2);
% figure(301)
% imagesc( dtsuwb1)
% 
% % Filter between 1.8 and 4 Hz (along bins)
% fuwb = uwbbandpass(dtsuwb1, 1,4, fs);
% figure(302)
% imagesc( fuwb)
% %fuwb = highpass(dtsuwb1, 0.5, fs);
% 
% % Pick out the top left patch of checkerboard
% s1_1fuwb = fuwb(1:75,53:120);
% %s1_1fuwb = fuwb(280:360, 90:130);
% figure;
% imagesc(s1_1fuwb)
% %s1_1fuwb = fuwb;
% 
% % 2D FT
% figure(303);
% imagesc(abs(fft2(s1_1fuwb,300,256)))
% % figure;
% % imagesc(fftshift(abs(fft2(s1_1fuwb,256,256))))
% 
% % PCA by hand: get the "best" pulse wave
% [U,S,V] = svd( s1_1fuwb);
% pulsewave = s1_1fuwb * V(:,1);
% %pulsewave = s1_1fuwb * V(:,1) + s1_1fuwb * V(:,2) + s1_1fuwb * V(:,3) + s1_1fuwb * V(:,4) + s1_1fuwb * V(:,5) + s1_1fuwb * V(:,6) + s1_1fuwb * V(:,7);
% t = (1:length(pulsewave))/fs;
% figure(304)
% plot( t, pulsewave)

%% Function Declarations


%findrate_wave (for analyzeHeartResp)
function [rr_sec,rr_min,pulsewave,fuwb,t] = findrate_wave(uwb,lpfreq, hpfreq,fs,plotFlag,type)

if nargin < 5
    plotFlag = false;
end
dtuwb = detrend(uwb,2);
if lpfreq == 0
    fuwb = lowpass(dtuwb, hpfreq, fs);
else
    fuwb = uwbbandpass(dtuwb, lpfreq,hpfreq, fs);
end

[U,S,V] = svd( fuwb);

pulsewave = fuwb * V(:,1);
t = (1:length(pulsewave))/fs;

[rr_sec,rr_min] = reprate(pulsewave,fs,type);
    
    %uwbbandpass
    function x = uwbbandpass(x, lpfreq, hpfreq, samplingRate)

    x = lowpass(highpass(x, lpfreq, samplingRate), hpfreq, samplingRate);


        %High and lowpass
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
        end

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
        end
    end
    
    %reprate
    function [fmx_sec, fmx_min] = reprate(pcuwb,fs,type)
    [Fpcuwb,zuwb,f,pidx] = pulseFFT(pcuwb,fs,2,true,type);
    aFpcuwb = abs( Fpcuwb);
    % Find max
    [maxamp,imx] = max(aFpcuwb);
    fmx_sec = f(imx);
    fmx_min = fmx_sec * 60;
        
        %pulseFFT
        function [F1zuwb,zuwb,f,pfidx] = pulseFFT(fuwb,fs,kos, plotFlag,type)
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
        %   figure;
        %   imagesc(zuwb)
        %   colorbar
        %   figure;
        %   plot(f)
        %   figure;
        %   imagesc( abs(F1zuwb.^2))
            figure;
            plot(f(pfidx),abs((F1zuwb(pfidx,:)).^2))
            %ylim([0,1.7e11]);
            if type == 1
            title('Frequency Distribution of Cardiac Data');
            elseif type == 2
            title('Frequency Distribution of Respiratory Data');
            else
            title('Fourier Transform of Data');
            end
            xlabel('frequency [Hz]')
        %   figure;
        %   plot(f(pfidx),psdF1zuwb)
        %   xlabel('frequency [Hz]')
        end

        end

    end

end

%importOut2File2 (for .csv file imports)
function [uwb, t, fs] = importOut2File2(filename, dataLines)
%IMPORTFILE Import data from a text file
%  RECORDSOUT26CHEST4CFG70DB = IMPORTFILE(FILENAME) reads data from text
%  file FILENAME for the default selection.  Returns the numeric data.
%
%  RECORDSOUT26CHEST4CFG70DB = IMPORTFILE(FILE, DATALINES) reads data
%  for the specified row interval(s) of text file FILENAME. Specify
%  DATALINES as a positive scalar integer or a N-by-2 array of positive
%  scalar integers for dis-contiguous row intervals.
%
%  Example:
%  recordsout26chest4cfg70db = importfile("C:\Users\lgiovangrandi\Documents\Active Projects\OHG01\Experiments\05272022 (Chest)\records_out2-6-chest4-cfg7-0db.csv", [1, Inf]);
%
%  See also READTABLE.
%
% Auto-generated by MATLAB on 27-May-2022 18:14:56

%% Input handling

% If dataLines is not specified, define defaults
if nargin < 2
	dataLines = [1, Inf];
end

%% Set up the Import Options and import the data
opts = delimitedTextImportOptions("NumVariables", 264);

% Specify range and delimiter
opts.DataLines = dataLines;
opts.Delimiter = ",";

% Specify column names and types
opts.VariableNames = ["Var1", "VarName2", "Var3", "Var4", "Var5", "Var6", "Var7", "Var8", "VarName9", "VarName10", "VarName11", "VarName12", "VarName13", "VarName14", "VarName15", "VarName16", "VarName17", "VarName18", "VarName19", "VarName20", "VarName21", "VarName22", "VarName23", "VarName24", "VarName25", "VarName26", "VarName27", "VarName28", "VarName29", "VarName30", "VarName31", "VarName32", "VarName33", "VarName34", "VarName35", "VarName36", "VarName37", "VarName38", "VarName39", "VarName40", "VarName41", "VarName42", "VarName43", "VarName44", "VarName45", "VarName46", "VarName47", "VarName48", "VarName49", "VarName50", "VarName51", "VarName52", "VarName53", "VarName54", "VarName55", "VarName56", "VarName57", "VarName58", "VarName59", "VarName60", "VarName61", "VarName62", "VarName63", "VarName64", "VarName65", "VarName66", "VarName67", "VarName68", "VarName69", "VarName70", "VarName71", "VarName72", "VarName73", "VarName74", "VarName75", "VarName76", "VarName77", "VarName78", "VarName79", "VarName80", "VarName81", "VarName82", "VarName83", "VarName84", "VarName85", "VarName86", "VarName87", "VarName88", "VarName89", "VarName90", "VarName91", "VarName92", "VarName93", "VarName94", "VarName95", "VarName96", "VarName97", "VarName98", "VarName99", "VarName100", "VarName101", "VarName102", "VarName103", "VarName104", "VarName105", "VarName106", "VarName107", "VarName108", "VarName109", "VarName110", "VarName111", "VarName112", "VarName113", "VarName114", "VarName115", "VarName116", "VarName117", "VarName118", "VarName119", "VarName120", "VarName121", "VarName122", "VarName123", "VarName124", "VarName125", "VarName126", "VarName127", "VarName128", "VarName129", "VarName130", "VarName131", "VarName132", "VarName133", "VarName134", "VarName135", "VarName136", "VarName137", "VarName138", "VarName139", "VarName140", "VarName141", "VarName142", "VarName143", "VarName144", "VarName145", "VarName146", "VarName147", "VarName148", "VarName149", "VarName150", "VarName151", "VarName152", "VarName153", "VarName154", "VarName155", "VarName156", "VarName157", "VarName158", "VarName159", "VarName160", "VarName161", "VarName162", "VarName163", "VarName164", "VarName165", "VarName166", "VarName167", "VarName168", "VarName169", "VarName170", "VarName171", "VarName172", "VarName173", "VarName174", "VarName175", "VarName176", "VarName177", "VarName178", "VarName179", "VarName180", "VarName181", "VarName182", "VarName183", "VarName184", "VarName185", "VarName186", "VarName187", "VarName188", "VarName189", "VarName190", "VarName191", "VarName192", "VarName193", "VarName194", "VarName195", "VarName196", "VarName197", "VarName198", "VarName199", "VarName200", "VarName201", "VarName202", "VarName203", "VarName204", "VarName205", "VarName206", "VarName207", "VarName208", "VarName209", "VarName210", "VarName211", "VarName212", "VarName213", "VarName214", "VarName215", "VarName216", "VarName217", "VarName218", "VarName219", "VarName220", "VarName221", "VarName222", "VarName223", "VarName224", "VarName225", "VarName226", "VarName227", "VarName228", "VarName229", "VarName230", "VarName231", "VarName232", "VarName233", "VarName234", "VarName235", "VarName236", "VarName237", "VarName238", "VarName239", "VarName240", "VarName241", "VarName242", "VarName243", "VarName244", "VarName245", "VarName246", "VarName247", "VarName248", "VarName249", "VarName250", "VarName251", "VarName252", "VarName253", "VarName254", "VarName255", "VarName256", "VarName257", "VarName258", "VarName259", "VarName260", "VarName261", "VarName262", "VarName263", "VarName264"];
opts.SelectedVariableNames = ["VarName2", "VarName9", "VarName10", "VarName11", "VarName12", "VarName13", "VarName14", "VarName15", "VarName16", "VarName17", "VarName18", "VarName19", "VarName20", "VarName21", "VarName22", "VarName23", "VarName24", "VarName25", "VarName26", "VarName27", "VarName28", "VarName29", "VarName30", "VarName31", "VarName32", "VarName33", "VarName34", "VarName35", "VarName36", "VarName37", "VarName38", "VarName39", "VarName40", "VarName41", "VarName42", "VarName43", "VarName44", "VarName45", "VarName46", "VarName47", "VarName48", "VarName49", "VarName50", "VarName51", "VarName52", "VarName53", "VarName54", "VarName55", "VarName56", "VarName57", "VarName58", "VarName59", "VarName60", "VarName61", "VarName62", "VarName63", "VarName64", "VarName65", "VarName66", "VarName67", "VarName68", "VarName69", "VarName70", "VarName71", "VarName72", "VarName73", "VarName74", "VarName75", "VarName76", "VarName77", "VarName78", "VarName79", "VarName80", "VarName81", "VarName82", "VarName83", "VarName84", "VarName85", "VarName86", "VarName87", "VarName88", "VarName89", "VarName90", "VarName91", "VarName92", "VarName93", "VarName94", "VarName95", "VarName96", "VarName97", "VarName98", "VarName99", "VarName100", "VarName101", "VarName102", "VarName103", "VarName104", "VarName105", "VarName106", "VarName107", "VarName108", "VarName109", "VarName110", "VarName111", "VarName112", "VarName113", "VarName114", "VarName115", "VarName116", "VarName117", "VarName118", "VarName119", "VarName120", "VarName121", "VarName122", "VarName123", "VarName124", "VarName125", "VarName126", "VarName127", "VarName128", "VarName129", "VarName130", "VarName131", "VarName132", "VarName133", "VarName134", "VarName135", "VarName136", "VarName137", "VarName138", "VarName139", "VarName140", "VarName141", "VarName142", "VarName143", "VarName144", "VarName145", "VarName146", "VarName147", "VarName148", "VarName149", "VarName150", "VarName151", "VarName152", "VarName153", "VarName154", "VarName155", "VarName156", "VarName157", "VarName158", "VarName159", "VarName160", "VarName161", "VarName162", "VarName163", "VarName164", "VarName165", "VarName166", "VarName167", "VarName168", "VarName169", "VarName170", "VarName171", "VarName172", "VarName173", "VarName174", "VarName175", "VarName176", "VarName177", "VarName178", "VarName179", "VarName180", "VarName181", "VarName182", "VarName183", "VarName184", "VarName185", "VarName186", "VarName187", "VarName188", "VarName189", "VarName190", "VarName191", "VarName192", "VarName193", "VarName194", "VarName195", "VarName196", "VarName197", "VarName198", "VarName199", "VarName200", "VarName201", "VarName202", "VarName203", "VarName204", "VarName205", "VarName206", "VarName207", "VarName208", "VarName209", "VarName210", "VarName211", "VarName212", "VarName213", "VarName214", "VarName215", "VarName216", "VarName217", "VarName218", "VarName219", "VarName220", "VarName221", "VarName222", "VarName223", "VarName224", "VarName225", "VarName226", "VarName227", "VarName228", "VarName229", "VarName230", "VarName231", "VarName232", "VarName233", "VarName234", "VarName235", "VarName236", "VarName237", "VarName238", "VarName239", "VarName240", "VarName241", "VarName242", "VarName243", "VarName244", "VarName245", "VarName246", "VarName247", "VarName248", "VarName249", "VarName250", "VarName251", "VarName252", "VarName253", "VarName254", "VarName255", "VarName256", "VarName257", "VarName258", "VarName259", "VarName260", "VarName261", "VarName262", "VarName263", "VarName264"];
opts.VariableTypes = ["string", "double", "string", "string", "string", "string", "string", "string", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double", "double"];

% Specify file level properties
opts.ExtraColumnsRule = "ignore";
opts.EmptyLineRule = "read";

% Specify variable properties
opts = setvaropts(opts, ["Var1", "Var3", "Var4", "Var5", "Var6", "Var7", "Var8"], "WhitespaceRule", "preserve");
opts = setvaropts(opts, ["Var1", "Var3", "Var4", "Var5", "Var6", "Var7", "Var8"], "EmptyFieldRule", "auto");

% Import the data
recordsout26chest4cfg70db = readtable(filename, opts);

%% Convert to output type
uwb = table2array(recordsout26chest4cfg70db);
t = uwb(:,1);
t = t - t(1);
uwb = uwb(:,2:end);
fs = 1 ./ mean(diff(t));
end

%demodScanLine (for initial data cleanup)
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
end

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
end

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
end




