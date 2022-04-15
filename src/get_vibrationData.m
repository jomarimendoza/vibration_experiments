function [vibdata_ce] = get_vibrationData(data,starts,sampLen,opts)
%GET_VIBRATIONDATA(data,starts,sampLen,isimpact) extracts vibration data for a
%roving impact hammer test setup
%
%   INPUT:  data - matrix output from ADLink
%           starts - start time for each grid point
%           sampLen - samples in time domain 
%           isImpact (true)  - roving impact hammer 
%                    (false) - acclerometer is monitored
%
%   OUTPUT: vibdata_ce - cell array for vibdata contains the data of the
%                        impact hammer and the accelerometer(s)
%                       (e.g. commonly, data(1,:)  -  impact hammer 
%                                       data(>1,:) - accelerometers
%   
%   Output description:
%       n - starts [index]
%       vibdata_ce{n}.impactForce  - force at grid point
%       vibdata_ce{n}.accData(k,:) - kth accelerometer

arguments
    data double
    starts double
    sampLen double
    opts.isImpact = true
end

% number of sensors
num_sensors = size(data,1);
for i = 1:num_sensors
    y{i}.data = data(i,:);
end

% cell array containing data of sensors
vibdata_ce = cell(size(starts,1),1); 

for i = 1:length(starts)
    vibdata_ce{i} = struct('impactForce',0,...
                           'impactHammer',[],... 
                           'accData',[]);
    
    % if impact hammer is used
    if opts.isImpact 
        for k = 1:num_sensors
            if k == 1
                vibdata_ce{i}.impactHammer = ...
                    y{k}.data(starts(i):starts(i) + sampLen - 1);
            else
                vibdata_ce{i}.accData(k-1,:) = ...
                    y{k}.data(starts(i):starts(i) + sampLen - 1);               % extract accelerometer data
            end
        end
        vibdata_ce{i}.impactForce = max(vibdata_ce{i}.impactHammer);

    % purely accelerometers
    else
        vibdata_ce{i}.impactForce = 1;
        for k = 1:length(num_sensors)
            vibdata_ce{i}.accData(k,:) = ...
                y{k}.data(starts(i):starts(i) + sampLen - 1);               % extract accelerometer data
        end    
    end
end

end

