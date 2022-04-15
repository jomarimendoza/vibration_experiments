% include necessary directories for scripts
addpath(genpath('src'));
addpath(genpath('_contents'));

%% Set environment variables

% EDIT: change to the dataset directory
dataset_dir = '.';
% EDIT: change to the MIRToolbox directory 
toolboxes_dir = '.';
% EDIT: change to results directory
results_dir = '';
% EDIT: change to output figures directory
figures_dir = '.';
% EDIT: change to location of ADLink Utitlity Converter
daqcvt_program = '"C:/ADLINK/MAPS Core/DASK/Utility/UD-DASK_DAQCvt.exe"';

setenv('DIR_DATASET', dataset_dir);
setenv('DIR_TOOLBOX', toolboxes_dir);
setenv('EXE_DAQCVT', daqcvt_program);
setenv('outdir_results', results_dir);
setenv('outdir_plots', figures_dir);

% include toolboxes in execution 
addpath(genpath(getenv('DIR_TOOLBOX')));

% do not show warnings
warning('off','all');