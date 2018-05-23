clc
clear

testFilePath = 'TestData\2. Куда вы поедите летом\Test1.xlsx';

[dataPath, ~, ~] = fileparts(testFilePath);

[~, ~, test] = xlsread(testFilePath);

[rows cols] = size(test);

output = zeros(rows - 1, 2);
 
for iRow=2:rows
	audioFilePath = fullfile(dataPath, char(test(iRow, 1)));
	[iStart iEnd] = analyseAudio(audioFilePath, 10);  
   
	output(iRow - 1, 1) = iStart;
    output(iRow - 1, 2) = iEnd;
end

fname = strcat('output.xls');
xlswrite(fullfile(dataPath, fname), output);
