function h = binViewer(fuwb, initialBin)
if nargin < 2;
    initialBin = 114;
end
axi = [];
axp = [];
% Create constant elements of figure
figh = figure;
figymax = 1337;
fighght = 700;
set(gcf, 'Position', [1000 (figymax-fighght) 925 fighght]);
axi = subplot(4,1,[1,2,3]);
axp = subplot(4,1,4);
imh = imagesc(axi, fuwb, 'ButtonDownFcn',{@buttonUpdate,axi,axp,fuwb});
set(figh, 'WindowKeyPressFcn', {@arrowUpdate,axi,axp,fuwb})
% xl = xline(axi, initialBin, 'Color', 'r', 'linewidth', 1.0);
shg
end

function buttonUpdate(src,evt,axi,axp,fuwb)
% disp(src);
% disp(evt);
ipoint = evt.IntersectionPoint;
newnbin = round(ipoint(1));
plot(axp, fuwb(:,newnbin));
title(num2str(newnbin))

% repaint line
xl = evalin('caller', 'xl');
delete(xl);
newxl = xline(axi, newnbin, 'Color', 'r', 'linewidth', 1.0);
assignin('caller','xl',newxl);
assignin('caller','nbin',newnbin);
end

function arrowUpdate(src,evt,axi,axp,fuwb)
% disp(src);
% disp(evt);
nbin = evalin('caller', 'nbin');
key = evt.Key;
if strcmp(key, 'rightarrow')
%     disp('right arrow');
    newnbin = nbin + 1;
elseif strcmp(key, 'leftarrow')
%     disp('left arrow');
    newnbin = nbin -  1;
else
    return
end
% ipoint = evt.IntersectionPoint;
% nbin = round(ipoint(1))
plot(axp, fuwb(:,newnbin));
title(num2str(newnbin))

% repaint line
xl = evalin('caller', 'xl');
delete(xl);
newxl = xline(axi, newnbin, 'Color', 'r', 'linewidth', 1.0);
assignin('caller','xl',newxl);
assignin('caller','nbin',newnbin);
end

