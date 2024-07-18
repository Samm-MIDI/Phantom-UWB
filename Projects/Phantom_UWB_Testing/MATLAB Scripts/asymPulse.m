% asymPulse.m

% pls3 is an assymetric pulse
t = (-64:63)/128;
w = 20;
lam = 0.2;
pls3 = (cos(w*t)-sin(w*t)).*exp(-(t/lam).^2);
figure;
plot(t, pls3)
fpls3 = fft(pls3);

% Target is a sine wave
starg = sin(2*pi*t);
figure;
plot( t, starg)
title('starg = sin')
fstarg = fft(starg);
figure;
plot( abs(fstarg))

% Calculate the kernel
rattargtopls3 = fstarg ./ fpls3;
figure;
semilogy([abs(fstarg(:)),abs(fpls3(:)),abs(rattargtopls3(:))])
kerntd3 = ifft( rattargtopls3);
% figure;
% plot(abs(kerntd3))
figure;
plot(real(kerntd3))
figure;
plot(imag(kerntd3))
% figure;
% plot(angle(kerntd3))
figure;
plot( t, conv(pls3, kerntd3, 'same'))

% Evaluate at discrete shifts
flipk = fliplr(kerntd3);
flipk*pls3'
for k = -4:2
    flipk*circshift(pls3',k)
end
