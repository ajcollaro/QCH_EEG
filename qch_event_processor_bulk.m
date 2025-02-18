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