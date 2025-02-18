% Extract and collate study labels.
function [central_index, obstructive_index] = qch_study_labels( ...
    study_folder)
    tic

    % File containing measurement.
    file = '\central_label.txt';
    if isfile([study_folder file])
        handle = fopen([study_folder file], 'r');
        % Read.
        central_index = [fscanf(handle, '%f')];
        fclose(handle);
    else
        central_index = 0;
    end

    % File containing measurement.
    file = '\obstructive_label.txt';
    if isfile([study_folder file])
        handle = fopen([study_folder file], 'r');
        % Read.
        obstructive_index = [fscanf(handle, '%f')];
        fclose(handle);
    else
        obstructive_index = 0;
    end
    
    toc
end