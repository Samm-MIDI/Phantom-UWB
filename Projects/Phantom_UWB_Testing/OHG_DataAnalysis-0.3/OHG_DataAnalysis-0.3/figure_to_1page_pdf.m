function figure_to_1page_pdf(froot_analysis_str, fh, psize)
% figure_to_1page_pdf(froot_analysis_str, fh, psize)
% Render a figure as a 1-page PDF.
% Inputs:
%   froot_analysis_str: string: The root of the PDF file name. See Note.
%   fh: (opt) handle: the handle of the figure to be rendered
%     Default: The current figure: the result of gcf()
%   psize: (opt) 2x1 double: Size of page in inches
%     Default: [7.8, 5.85]
% Outputs:
%   none
% Note: Although external to this function, typically we've been appending
% a few-letter code to the case name to give the PDF file root. Thus, we append
% _HR for heart rate, and _Resp for breathing rate. Again, this function
% doesn't care. This note is just a reminder.

% History:
% 2024Jul26 bpw: Initial version extracted from 
%   "analyzeSubregion_SmoothDemod_3.m"

if nargin < 3
    psize = [7.8,5.85];
end
if nargin < 2
    fh = gcf;
end

set( fh, 'PaperSize', psize);
print(strcat('Results/', froot_analysis_str),'-dpdf')

end