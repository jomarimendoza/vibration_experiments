function [vibrationData] = cvt2double(cvtFile)
%CVT2DOUBLE(cvtFile) converts .cvt files to cell variables obtained
%from conversion using DAQCvt application.
%
%   INPUT:  cvtFile - selected cvt files (one or more) 
%
%   OUTPUT: vibrationData - contains the vibration data of from the cvt
%           file. It stores the data into an n-by-m matrix, where [n] is
%           the number of sensors and [m] is the number of samples on each
%           sensor

% Extract data from cvt files
file_contents = fileread(fullfile(cvtFile.folder,cvtFile.name)); 
struct_contents = splitlines(file_contents);

info = struct_contents(1:2);
data_struct = struct_contents(3:end);

% Display file name of .cvt 
fprintf('\nLoading %s\n', cvtFile.name);                                  
if contains(info{1},'ADLink')                                               
    fprintf('================================================\n');
    fprintf('          Data loaded from ADLINK DAQ           \n');
    fprintf('================================================\n');
else
    error('Data is not from ADLINK');
end

% Display number of extracted channels
if contains(info{2},'Channel_')
    nCh = size(strsplit(info{2},' '),2)-1;
    fprintf(' > Number of Channels: %d \n',nCh);
end

fprintf(' > Converting to cell strings \n');

% TODO: review this if 'UniformOutput' = false in necessary
ce_ceData = cellfun(@strsplit,data_struct,'UniformOutput',false);
    
fprintf(' > Processing cvt data \n');
data_tmp = str2double([ce_ceData{1:end-1}]);
data_cell = data_tmp(~isnan(data_tmp));                     % remove nans

fprintf(' > Converting to matlab double 2D array \n');
vibrationData = reshape(data_cell,nCh,length(data_cell)/nCh);       

end

