function [w] = powerWindow(torN,pwr)
if isscalar(torN)
    N = torN;
    N_2 = floor(N/2);
    kstart = -N_2;
    kstop = kstart+(N-1);
    t = (kstart:kstop)/N_2;
else
    N = length(torN);
    t = torN / max(abs(torN));
end

w = 1 - power(abs(t),pwr);

end

