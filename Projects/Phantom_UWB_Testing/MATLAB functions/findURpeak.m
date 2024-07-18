function [peakmag, peakidx] = findURpeak(abs_fft2)
% Find max of each row in the scalar "image"
[m_row,i_row] = max(abs(abs_fft2),[],2);
% Now, find the max of those maxes
[m_col,i_col] = max(m_row);
peakidx = [i_col,i_row(i_col)]
peakmag = abs_fft2(peakidx(1),peakidx(2))
end

