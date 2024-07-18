function filsig = circexpfilt(sig,alpha)
sig = sig(:);
stidx = (1:length(sig))';
expfilt = exp(-(stidx-1)/alpha);
fexpfilt = fft(expfilt./sum(expfilt));
ffsig = fft(sig).*fexpfilt;
filsig = real(ifft(ffsig));
end
