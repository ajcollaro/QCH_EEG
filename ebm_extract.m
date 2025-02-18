% Extract signals from *.ebm files and pre-process.
function [signal] = ebm_extract(study, model_settings, file)
    tic

    % Extract F4 and transpose.
    [data, varargout] = ebmread([study '\' file]);
        
    signal_raw = double(data) * 1e6;

    % Resample and add zeroes to match desired length.
    signal_resampled = resample(signal_raw, model_settings.fs, round(varargout.samplingrate));

    signal = single(signal_resampled);

    toc
end