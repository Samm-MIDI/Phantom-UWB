t = (-64:63)/128;
w = 20;
lam = 0.2;

% pls3 is an assymetric pulse
pls3 = (cos(w*t)+sin(w*t)).*exp(-(t/lam).^2);

% This works great. But it has a limited range of sensitivity: if the pulse
% itself is narrow, then the range overwhich this is sensitive is also
% narrow. In that sense, starg is better because it is sensitive over half
% the window.
figure;
plot(pls3)
title('pls3 = asymmetric pulse')
fpls3 = fft(pls3);
psfpls3 = fpls3*exp(-i*pi/2);
ifpsfpls3 = ifft(psfpls3);
% figure;
% plot( conv(pls3,ifpsfpls3,'same'))
figure;
plot( real(conv(pls3,ifpsfpls3,'same')))
title('real part of convolution')
figure;
plot( imag(conv(pls3,ifpsfpls3,'same')))
title( 'imag part of convolution')
figure;
plot( (conv(pls3,imag(ifpsfpls3),'same')))
title('convolution with imag part of kernel')
