function [modalparams_t] = get_modalParameters(vibrationData, fs)
%GET_MODALPARAMETERS (data,starts,sampLen,isimpact) extracts the modal
%parameters of the vibration data. This script is not particular on the
%location of the strike or sensors. 
% 
%   INPUT:  vibrationData - vibration data from the .cvt files
%                      fs - sampling frequency of the vibration sensor
%   OUTPUT: modalparams_t - table continaining the modal parameters
%
%   Output description:
%       contains natural_frequencies, damping_ratio
%


num_sensors = size(vibrationData,1) - 1;
winlen = 64000; 
mnum = 25;

if num_sensors > 1
    Y = vibrationData(2:num_sensors+1,:)';
    X = zeros(size(Y));            
    for i = 1:num_sensors
        X(:,i) = vibrationData(1,:)';
    end    
    measurement = 'rovingoutput';
elseif num_sensors == 1
    X = vibrationData(1,:)';
    Y = vibrationData(2,:)';
    measurement = 'rovinginput';
end

[frf,f] = modalfrf(X,Y,fs,winlen,'Measurement',measurement, ...
                                 'Sensor','acc');

[fn,dr] = modalfit(frf,f,fs,mnum);

modalparams.natural_freuencies = fn;
modalparams.damping_ratio = dr;

modalparams_t = struct2table(modalparams);

end

