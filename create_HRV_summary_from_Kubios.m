%% extract relevant HR/V measures from Kubios-generated .MAT summary files
% assumes that
%       1) all .MAT files are stored in one folder (hrv_dir, specify below)
%       2) subject number is part of filename (specify below)
% output: a .TXT and a .CSV file with a summary table (specify below)
%
% michael.gaebler@gmail.com
% version 20150702

clear all

% !!!! ADAPT TWO THINGS HERE !!!!
% 1) specify directory in which all .mat files are stored
hrv_dir = fullfile('D:', 'example_dir');
% 2) specify filename of summary table
filename = 'HRV_values_summary'; % filename to store resulting summary table

% detect all .mat files in that directory
hrfiles = dir(fullfile(hrv_dir,'*.mat'));

for ifile = 1:length(hrfiles) % loop through all found .MAT files
    
    clear Res
    load(fullfile(hrv_dir,hrfiles(ifile).name));
    
    hrv_params(ifile,1) =  Res.HRV.Statistics.mean_RR * 1000;  % mean IBI
    hrv_params(ifile,2) =  Res.HRV.Statistics.std_RR * 1000;   % SD IBI
    hrv_params(ifile,3) =  Res.HRV.Statistics.mean_HRV; % mean HR
    hrv_params(ifile,4) =  Res.HRV.Statistics.std_HRV;  % SD HR
    hrv_params(ifile,5) =  Res.HRV.Statistics.RMSSD * 1000;
    hrv_params(ifile,6) =  Res.HRV.Statistics.NN50;
    hrv_params(ifile,7) =  Res.HRV.Statistics.pNN50;
    
    hrv_params(ifile,8) =  Res.HRV.Frequency.Welch.LF_power * 1000000;
    hrv_params(ifile,9) =  Res.HRV.Frequency.Welch.HF_power * 1000000; % !!! HF-HRV power
    
    hrv_params(ifile,10) = Res.HRV.Frequency.Welch.HF_power_nu;  % HF normalized units
    hrv_params(ifile,11) = Res.HRV.Frequency.Welch.HF_power_prc; % HF normalized units
    hrv_params(ifile,12) = Res.HRV.Frequency.Welch.LF_HF_power;  % LF/HF ratio
    
    hrv_params(ifile,13) =  Res.HRV.Frequency.AR.LF_power * 1000000;
    hrv_params(ifile,14) =  Res.HRV.Frequency.AR.HF_power * 1000000; % !!! HF-HRV power
    
    hrv_params(ifile,15) = Res.HRV.Frequency.AR.HF_power_nu;  % HF normalized units
    hrv_params(ifile,16) = Res.HRV.Frequency.AR.HF_power_prc; % HF normalized units
    hrv_params(ifile,17) = Res.HRV.Frequency.AR.LF_HF_power;  % LF/HF ratio
    
    % !!!! ADAPT HERE !!!!
    hrv_params(ifile,18) = str2num(hrfiles(ifile).name(5:7)); % subject number !!
    
end

% save table as .txt and .csv in hrv_dir
save(fullfile(hrv_dir,[filename '.txt']),'hrv_params','-ascii');
csvwrite(fullfile(hrv_dir,[filename '.csv']),hrv_params);


