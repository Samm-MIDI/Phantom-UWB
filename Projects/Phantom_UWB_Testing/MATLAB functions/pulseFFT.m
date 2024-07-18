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

