function [pca_wave, U, S, V] = pc1_by_hand(demod_uwb)
% [pca_wave, U, S, V] = pc1_by_hand(demod_uwb);
% Optimally combine columns of demodulated UWB data by computing the first
% principal component. We do this "by hand" by using SVD.
% Inputs:
%   demod_uwb: 2D double: demodulated UWB data: rows in slow time; cols in
%     "radar" time.
% Outputs:
%   pca_wave: 1D double: 1st principal component across columns of
%     demod_uwb. So length(pca_wave) == number of rows of demod_uwb

% History:
% 2024Jul25 bpw: Initial version extracted from 
%   "analyzeSubregion_SmoothDemod_3.m"

nrows = size(demod_uwb,1);

% Do SVD
[U,S,V] = svd( demod_uwb);

% Compute 1st PC
pca_wave = demod_uwb * V(:,1);

assert( length(pca_wave) == nrows);
end