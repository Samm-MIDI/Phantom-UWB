% driveCases_SmoothDemod.m

close all; clear

humanParams

caseT = readtable('CaseIndex.xlsx')
caseT = fillmissing(caseT, 'previous')
nCases = height(caseT)

vnames = {'SampleF','MedianHR','MedianResp','SigPkPk'};
vtypes = { 'double',  'double',    'double', 'double'};
nRvars = length(vnames);
resultsT = table('Size',[nCases,nRvars], ...
    'VariableNames',vnames, ...
    'VariableTypes',vtypes);
for kcase = 1:nCases
    thisCase = caseT(kcase,:)
    filecore  = thisCase.("FileCore"){1}
    filespec  = thisCase.("FileSpec")
    %status      = thisCase.('Status'){1}
    antdist   = thisCase.('AntennaDist')

    folder   = '.'; % sprintf('%2dmm', antdist)
    froot    = sprintf('%s%d',filecore,filespec)
    case_str = sprintf('%s, %dmm', antdist)

    smooth_rows = 1:304;
    check_patch_cols = 55:105;

    close all;
    analyzeSubregion_SmoothDemod_2
    resultsT(kcase,:) = {fs, hr_median,br_median,pkpk}

end

analysisT = [caseT,resultsT];
writetable(analysisT, 'AnalysisTable.xlsx')
