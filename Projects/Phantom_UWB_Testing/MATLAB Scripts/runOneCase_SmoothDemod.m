% driveCases_SmoothDemod.m


printPlots = false;

catParams

caseT = readtable('CaseIndex.xlsx')
caseT = fillmissing(caseT, 'previous')
nCases = length(k_indicies)

vnames = {'SampleF','MedianHR','MedianResp','SigPkPk'};
vtypes = { 'double',  'double',    'double', 'double'};
nRvars = length(vnames);
resultsT = table('Size',[nCases,nRvars], ...
    'VariableNames',vnames, ...
    'VariableTypes',vtypes);
for nkcase = 1:nCases
    kcase = k_indicies(nkcase)
    thisCase = caseT(kcase,:)
    filecore  = thisCase.("FileCore"){1}
    filespec  = thisCase.("FileSpec")
   % status      = thisCase.('Status'){1}
    antdist   = thisCase.('AntennaDist')

    folder   = '.'; % sprintf('%2dmm', antdist)
    froot    = sprintf('%s%d',filecore,filespec)
    case_str = sprintf('%s, %dmm',status, antdist)

    smooth_rows = 1:304;
    check_patch_cols = 55:105;

    close all;
    analyzeSubregion_SmoothDemod_2

%     resultsT(kcase,:) = {fs, hr_median,br_median,pkpk}

end

% analysisT = [caseT,resultsT];
% writetable(analysisT, 'AnalysisTable.xlsx')
