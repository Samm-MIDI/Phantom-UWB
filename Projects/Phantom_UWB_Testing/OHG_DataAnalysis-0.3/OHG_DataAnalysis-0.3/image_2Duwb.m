function image_2Duwb(uwb, x, y, xlab,ylab)
% Parse optional parameters
if nargin < 5
    xlab = 't_{radar}'
    ylab = 't_{bio}'
end
if nargin < 3
    x = 1:size(uwb,1);
    y = 1:size(uwb,2);
    xlab = strcat(xlab, ' [arb]');
    ylab = strcat(ylab, ' [arb]');
end

imagesc(x,y, uwb);
% Note: y,x is in this order because of the way matlab flips coordinates in
% images.
colorbar
xlabel(xlab);
ylabel(ylab);

end
