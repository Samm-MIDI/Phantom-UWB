function [f_subs, t_subs, fs] = slidingF(sig, window, shift, tbase)
if nargin < 4, tbase = 1:length(sig); end
if nargin < 3, shift = 16; end
if nargin < 2, window = 32; end

mask = hamming(window);

nfft = 256;
dt = mean(diff(tbase));
fs = 1/dt;

nsig = length(sig);
nsamples = floor((nsig-window)/shift)+1;

f_subs = [];
t_subs = [];
for k = 1:nsamples
    lastaddr = (k-1)*shift+window;
    firstaddr = lastaddr - (window-1);
    subsig = sig(firstaddr:lastaddr);
    Fsubsig = fft(mask.*subsig,256);
    [~, kFmax] = max(abs(Fsubsig));
    fFmax = (kFmax - 1)/nfft * fs;
    % plot(abs(Fsubsig));
    f_subs(k) = fFmax;
    t_subs(k) = tbase(lastaddr);
end

end