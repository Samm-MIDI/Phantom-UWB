% loadUWB.m
folder = '.';
froot = 'records_out2-220610-12'
[uwb, t, fs] = importOut2File2(fullfile(folder, [froot,'.csv']));
