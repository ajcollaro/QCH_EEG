function pipeline_qch(study_list_qch, event_list_qch, archive_name, ...
    model_settings)
    tic

    qch_data = table();

    for i = 1 : height(study_list_qch)
        % Check if we should include this study. - DISABLED.
        %include = qch_study_exclusions([study_list_qch(i).folder ...
        %    '\' study_list_qch(i).name]);

        % Skip if we exclude.
        %if include == false
        %    fprintf('Exclusion criteria found, skipping\n');
        %    continue;
        %end

        fprintf('Collating signal data for study %i\n', i);
        
        % Extract all signal data.
        f4 = ebm_extract([study_list_qch(i).folder '\' ...
            study_list_qch(i).name], model_settings, 'F4.ebm');
        c4 = ebm_extract([study_list_qch(i).folder '\' ...
            study_list_qch(i).name], model_settings, 'C4.ebm');
        o2 = ebm_extract([study_list_qch(i).folder '\' ...
            study_list_qch(i).name], model_settings, 'O2.ebm');
        loc = ebm_extract([study_list_qch(i).folder '\' ...
            study_list_qch(i).name], model_settings, 'LOC.ebm');
        roc = ebm_extract([study_list_qch(i).folder '\' ...
            study_list_qch(i).name], model_settings, 'ROC.ebm');
        m1 = ebm_extract([study_list_qch(i).folder '\' ...
            study_list_qch(i).name], model_settings, 'M1.ebm');
        m2 = ebm_extract([study_list_qch(i).folder '\' ...
            study_list_qch(i).name], model_settings, 'M2.ebm');

        % Align staging data to EEG data, and include only data between
        % analysis start and analysis stop.
        [sleep_stages, staging_info] = extract_events(event_list_qch{i}, ...
            model_settings);

        % Organise data.
        data = table();

        % Demographics go here.
        % data.id = id;
        % data.age = age;
        % data.sex = sex;
        % data.ahi = ahi;
        % data.cahi = cahi;
        % data.oahi = oahi;
        data.eeg_f4 = f4;
        data.eeg_c4 = c4;
        data.eeg_o2 = o2;
        data.eeg_m1 = m1;
        data.eeg_m2 = m2;
        data.eeg_loc = loc;
        data.eeg_roc = roc;
        data.hypnogram = sleep_stages;

        % Store EEG data and labels.
        qch_data = [qch_data; data];
    end

    % All studies complete, save archive.
    save([archive_name '.mat'], 'qch_data', '-v7.3');

    toc
end