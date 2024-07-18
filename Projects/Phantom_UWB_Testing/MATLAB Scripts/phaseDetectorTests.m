t = (-64:63)/128;
w = 20;
lam = 0.2;
pls = cos(w*t).*exp(-(t/lam).^2);
figure;
plot( t, pls)

ki = zeros(size(t));
ki(65) = 1;
figure;
plot(t,ki)
cki = conv(pls,ki,'full');
figure;
plot( cki)

% tc = -127:127;
% doc sigmoid
% targ = sigmoid(tc,1,0.1);
% plot(tc,targ)
% targ = sigmoid(tc,1,0.1).*hamming(size(tc));
% targ = sigmoid(tc,1,0.1).*hamming(length(tc));
% plot(tc,targ)
% targ = sigmoid(tc',1,0.1).*hamming(length(tc));
% plot(tc,targ)
% targ = sigmoid(tc',1,0.01).*hamming(length(tc));
% plot(tc,targ)
% targ = sigmoid(tc',1,10).*hamming(length(tc));
% plot(tc,targ)
starg = sin(2*pi*t);
figure;
plot( t, starg)
title('starg = sin')
fstarg = fft(starg);
figure;
plot( abs(fstarg))
fpls = fft(pls);
figure;
plot( abs(fpls))
rattargtopls = fstarg ./ fpls;
figure;
plot( abs(rattargtopls))
figure;
plot( t, abs(rattargtopls),t, abs(fstarg))
figure;
plot( t, angle(rattargtopls),t, angle(fstarg))
kerntd = ifft( rattargtopls);
figure;
plot(abs(kerntd))
figure;
plot(conv(pls,kerntd,'same'))
figure;
plot(real(kerntd))
figure;
plot(imag(kerntd))
figure;
plot(t,pls)

w = 30; lam = 0.1;
pls2 = cos(w*t).*exp(-(t/lam).^2);
figure;
plot( t, pls2)
figure;
plot( conv(pls2,kerntd,'same'))
% eye(8)
% impls = eye(8)
% Fimpls = fft(impls);
% real(Fimpls)
% imag(Fimpls)

% pls3 = (cos(w*t)+sin(w*t)).*exp(-(t/lam).^2);
% plot(t, pls3)
%% pls3 is an assymetric pulse
pls3 = (cos(w*t)+sin(w*t)).*exp(-(t/lam).^2);
figure;
plot(t, pls3)
fpls3 = fft(pls3);
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
pls3*kerntd3'
fliplr(pls3)*kerntd3'
fliplr(pls3)*circshift(kerntd3',1)
fliplr(pls3)*circshift(kerntd3',-1)
fliplr(pls3)*circshift(kerntd3',-2)
fliplr(pls3)*circshift(kerntd3',-3)
fliplr(pls3)*circshift(kerntd3',-4)

%%
% targ = sigmoid(tc',1,10).*hamming(length(tc));
% plot(sigmoid(tc',1,10))
% plot( hamming(length(tc)))
% setupMatlab
% plot(powerWindow(t,1))
% plot(powerWindow(t,2))
% plot(powerWindow(t,4))
% plot(powerWindow(t,5))
% targ2 = sigmoid(tc',1,10).*powerWindow(t,5);
% plot( targ2)
% targ2 = sigmoid(tc',1,10).*powerWindow(t',5);
% size(powerWindow(t',5))
% plot(tc)
% targ2 = sigmoid(tc',1,10).*powerWindow(tc',5);
% plot(targ2)
% ftarg2 = fft(targ2);
% rattargtopls2_3 = ftarg3 ./ fpls3;
% rattargtopls2_3 = ftarg2 ./ fpls3;
% kerntd2_3 = ifft( rattargtopls2_3);
% plot( conv(pls3, kerntd2_3, 'same'))
% targ2 = sigmoid(t',1,10).*powerWindow(t',5);
% ftarg2 = fft(targ2);
% rattargtopls2_3 = ftarg2 ./ fpls3;

%% Try a wider sensitivity region. Note: limit is a sawtooth wave.
% This didn't work: too much power in target at high frequencies
targ2 = sigmoid(t,5,0.1).*powerWindow(t,2);
targ3 = sin(2*pi*t)-1/6*sin(3*2*pi*t);
figure;
plot( t, targ2,t,targ3,t,starg)
figure;
plot([targ2(:),starg(:)])
ftarg2 = fft(targ2);
figure;
semilogy([abs(ftarg2(:)),abs(fstarg(:))])
rattargtopls2_3 = ftarg2 ./ fpls3;
kerntd2_3 = ifft( rattargtopls2_3);
figure;
plot([abs(kerntd2_3(:)),abs(kerntd(:))])
figure;
semilogy([abs(ftarg2(:)),abs(fpls3(:)),abs(rattargtopls2_3(:))])
figure;
plot( conv(pls3, kerntd2_3, 'same'))
figure;
plot( conv(pls3, kerntd3, 'same'))
% figure;
% plot( conv(pls3, kerntd2_3, 'same'))
figure;
plot(kerntd2_3)
figure;
plot(kerntd3)

% This works great. But it has a limited range of sensitivity: if the pulse
% itself is narrow, then the range overwhich this is sensitive is also
% narrow. In that sense, starg is better because it is sensitive over half
% the window.
figure;
plot(pls3)
fpls3 = fft(pls3);
psfpls3 = fpls3*exp(i*pi/2);
ifpsfpls3 = ifft(psfpls3);
figure;
plot( conv(pls3,ifpsfpls3,'same'))
figure;
plot( real(conv(pls3,ifpsfpls3,'same')))
figure;
plot( imag(conv(pls3,ifpsfpls3,'same')))
figure;
plot( (conv(pls3,imag(ifpsfpls3),'same')))
