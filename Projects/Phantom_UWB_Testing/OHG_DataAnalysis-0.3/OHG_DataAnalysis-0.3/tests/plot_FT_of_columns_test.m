% plot_FT_of_columns_test.m

fs = 15.1515;
nrows = 304;
ncols = 40;
fb = 15;
alpha = 0.1

fb_sec = fb/60

y = 1:nrows;
x = 1:ncols;
sx = x/ncols;
sy = y/nrows;
[sX,sY] = meshgrid(sx,sy);

[X,Y] = meshgrid(x,y);
tY = Y/fs;

% imagesc(tY); colorbar; shg
% f2D = fb_sec .*(1 + 0.01.*sY);
% imagesc(f2D); colorbar; shg
% fakeBreathing = cos(f2D.*tY);
% imagesc(fakeBreathing); colorbar; shg
% f2D = fb_sec .*(1 + 0.01.*sX);
% fakeBreathing = cos(f2D.*tY);
% imagesc(fakeBreathing); colorbar; shg
% imagesc(tY); colorbar; shg
% shg
% fakeBreathing = cos(2*pi*f2D.*tY);
% imagesc(fakeBreathing); colorbar; shg

f2D = fb_sec .*(1 + alpha.*sX);
fakeBreathing = cos(2*pi*f2D.*tY);
figure
imagesc(fakeBreathing); colorbar; shg

% which plot_FT_of_columns
% setupMatlab
% which plot_FT_of_columns
% shg
% plot_FT_of_columns(fakeBreath, fs, 80, 0, true); shg
% plot_FT_of_columns(fakeBreathing, fs, 80, 0, true); shg
% ax = gca;
% ax.YAxis
% f(fmask)
% plot_FT_of_columns(fakeBreathing, fs, 80, 0, true); shg
% f(fmask)
% df = mean(diff(f(fmask)))
% subf = f(fmask);
% y_ax_limits = [subf(0)-df/2, subf(end)+df/2]
% y_ax_limits = [subf(0)-df/2, subf(:end)+df/2]
% first(subf)
% subf(end)
% y_ax_limits = [subf(1)-df/2, subf(end)+df/2]
% ylimit(y_ax_limits)
% ylim(y_ax_limits)
% shg
% doc imagesc
% imagesc(subf,1:40,naf_td_sig); shg
% imagesc((1:40),subf,naf_td_sig); shg
% imagesc((1:40),subf,naf_td_sig(fmask,:)); shg

figure
plot_FT_of_columns(fakeBreathing, fs, 80, 0, true); shg