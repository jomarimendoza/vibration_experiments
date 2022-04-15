close all; clc; clear;
include;

%% How many vibration data/samples are to converted and analyzed

% SETTINGS
sample_length = 30000;
nfft = 2^nextpow2(sample_length);
fs = 128000;
min_peak_height = 0.03;
nReps = 5;      % -> EDIT: number of strikes per cvt file

[y, Fs] = audioread('_contents/buzz.mp3');                                  % Load sound notif when done computing
player = audioplayer(y, Fs);

system(getenv('EXE_DAQCVT'));                                               % 1. Loads the DAQCvt and convert all .dat files

vib_dir = uigetdir(getenv('DIR_DATASET'), 'Select folder contianing cvt files');  % 2. Select folder containing the vibration files

cvtfiles = dir(fullfile(vib_dir,'**/*.cvt'));

% START THE EXTRACTION OF FILES
for i = 1:length(cvtfiles)  
    data = cvt2double(cvtfiles(i));                                            % Extract the data from the cvt files
    
    [peaks,locs] = findpeaks( data(1,:),'Npeaks', nReps, ...
                                        'MinPeakDistance', sample_length, ...
                                        'MinPeakHeight', min_peak_height );
        if length(peaks) ~= nReps
            figure('Position',[100 150 1800 600])                           % 3.1 IF it is not struck 5 times export manually
            plot(data(1,:));                                                %       name the exported value 's' (!!-IMPORTANT)
            title(cvtfiles(i).name, 'Interpreter', 'none');
            play(player)
            pause;
            starts(:,1) = [s.DataIndex]';
            clear s;    
            close figure 1;
        else
            starts(:,1) = locs - 100;                                       % 3.2 Automatically extract the peak locations
            figure('Position',[100 150 1800 600])
            plot(data(1,:));
            title(cvtfiles(i).name, 'Interpreter', 'none');
            for j = locs-100
                hold on;
                line([j j], [0 1], 'Color','red','LineStyle','--');
            end
            hold off;
            pause(0.2);
            close figure 1;
        end
    
    starts = sort(starts,1);
    
    data_ce = get_vibrationData(data, starts, sample_length);               % extraction of sensor data
    vibration_t = get_modalParameters(data,fs);                             % computation of modal parameters

    fprintf('\n\nNumber of starts: %d\n\n', length(starts));
    
    [~,fname,~] = fileparts(cvtfiles(i).name);

    out_fname = sprintf('%s_vibration_data.mat', fname);                    % output .mat file
    fprintf(['Saving data of sample plate == %s.cvt == to ' ...
        '== %s == \n\n'], fname, out_fname);

    fdir = getenv('outdir_results');
    fprintf('Saved in %s\n', fullfile(fdir, out_fname));
    save(fullfile(fdir,out_fname), 'data', 'nfft','fs', 'vibration_t');
end
