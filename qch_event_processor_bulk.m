% Tabulate list of events for each study.
function [event_list_qch] = qch_event_processor_bulk( ...
    event_handler, study_list)
    tic

    % Initialisation.
    out_dir = 'C:\out';
    
    % Setup import of delimited data.
    var_names = {'onset','duration','trial_type','value','channels'} ;
    var_types = {'double','double','char','char','char'} ;
    delimiter = '\t';
    data_start_line = 2;
    extra_col_rule = 'ignore';

    % Preallocate for speed.
    event_list_qch{length(study_list)} = 0;

    % Iterate through list of tests.
    for i = 1 : length(study_list)

        study_name = [study_list(i).folder '\' study_list(i).name];
        
        fileList = dir(study_name);

        % Correct duplicate esedbs.
        esedbFiles = [];
    
        for j = 1 : length(fileList)
            [~, ~, ext] = fileparts(fileList(j).name);  % Extract the file extension.
            if strcmpi(ext, '.esedb')  % Check if the file is a .esedb file (case-insensitive).
                esedbFiles = [esedbFiles; fileList(j)];
            end
        end
    
        if length(esedbFiles) >= 2
            for j = 1 : length(esedbFiles)
                fileName = esedbFiles(j).name;  % Get the name of the current .esedb file
                
                % Check if 'dr' (case-insensitive) is NOT present in the file name
                if isempty(regexpi(fileName(end - 12 : end), 'dr'))
                    % Rename the file by appending .BACKUP
                    oldFullPath = fullfile(study_name, fileName);
                    newFileName = [fileName '.BACKUP'];
                    newFullPath = fullfile(study_name, newFileName);
                    
                    % Rename the file
                    movefile(oldFullPath, newFullPath);
                    fprintf('Renamed file: %s -> %s\n', fileName, newFileName);
                end
            end
        else
            fprintf('Less than 2 .esedb files found, no renaming necessary.\n');
        end

        % Setup command.
        command = ['python "' event_handler '" -t my_task "' ...
            study_list(i).folder '\' study_list(i).name '" -o "' ...
            out_dir '"'];

        % 1 by 1.
        mustBeTextScalar(command);

        % Run command.
        system(command);
        
        % Feed in events.
        fprintf('\nImporting events for study %i\n', i);

        opts = delimitedTextImportOptions('VariableNames', var_names,...
            'VariableTypes', var_types,...
            'Delimiter', delimiter,...
            'DataLines', data_start_line,...
            'ExtraColumnsRule', extra_col_rule);

        event_file = [out_dir ...
            '\patient\eeg\patient_task-my_task_events.tsv'];
        mustBeTextScalar(event_file);

        if isfile(event_file)
            event_list_qch{i} = readtable(event_file, opts);
        end
    end

    toc
end