% driveCases_SmoothDemod.m

close all; clear

dogParams
good_data_region

% folder = strcat(getenv("DataRoot"), "/OHG-03/fromOHG01/POC_TRT_Demo_220722")
folder = "."

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
    food      = thisCase.('Food'){1}
    antdist   = thisCase.('AntennaDist')

    froot    = sprintf('%s%04d',filecore,filespec)
    case_str = sprintf('%s, %dmm',food, antdist)

    close all;
    analyzeSubregion_SmoothDemod
    resultsT(kcase,:) = {fs, hr_median,br_median,pkpk}

end

analysisT = [caseT,resultsT];
writetable(analysisT, 'Results/AnalysisTable.xlsx')
