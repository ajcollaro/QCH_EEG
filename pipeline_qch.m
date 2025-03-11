function pipeline_qch(study_list_qch, event_list_qch, archive_name, ...
    model_settings)
    tic

    qch_data = table();

    %for i = 1 : height(study_list_qch)
    for i = 10 : 29
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
        [sleep_stages, staging_info, central_apnoeas, ...
            obstructive_apnoeas, mixed_apnoeas, central_hypopneas, ...
            obstructive_hypopneas] = extract_events(event_list_qch{i}, ...
            model_settings);

        % Skip studies where unsufficient EEG data for scoring
        if height(f4) < staging_info.stop * 30 * 128
            continue;
        end

        % Correct length
        f4 = f4(floor(staging_info.discard) + 1 : end, :);
        f4 = f4(staging_info.start * model_settings.fs * 30 + 1 : staging_info.stop * model_settings.fs * 30, :);
        c4 = c4(floor(staging_info.discard) + 1 : end, :);
        c4 = c4(staging_info.start * model_settings.fs * 30 + 1 : staging_info.stop * model_settings.fs * 30, :);
        o2 = o2(floor(staging_info.discard) + 1 : end, :);
        o2 = o2(staging_info.start * model_settings.fs * 30 + 1 : staging_info.stop * model_settings.fs * 30, :);
        loc = loc(floor(staging_info.discard) + 1 : end, :);
        loc = loc(staging_info.start * model_settings.fs * 30 + 1 : staging_info.stop * model_settings.fs * 30, :);
        roc = roc(floor(staging_info.discard) + 1 : end, :);
        roc = roc(staging_info.start * model_settings.fs * 30 + 1 : staging_info.stop * model_settings.fs * 30, :);
        m1 = m1(floor(staging_info.discard) + 1 : end, :);
        m1 = m1(staging_info.start * model_settings.fs * 30 + 1 : staging_info.stop * model_settings.fs * 30, :);
        m2 = m2(floor(staging_info.discard) + 1 : end, :);
        m2 = m2(staging_info.start * model_settings.fs * 30 + 1 : staging_info.stop * model_settings.fs * 30, :);

        % Extract demographics
        [dob, dos, sex, oahi_rem, oahi_nrem, oahi, cahi_rem, cahi_nrem, ...
            cahi, ai] = qch_extra_data([study_list_qch(i).folder '\' ...
            study_list_qch(i).name]);
 
        % Organise data.
        data = table();

        % Demographics go here.
        data.id = i;
        data.dob = dob;
        data.dos = dos;
        data.sex = sex;
        data.oahi_rem = oahi_rem;
        data.oahi_nrem = oahi_nrem;
        data.oahi = oahi;
        data.cahi_rem = cahi_rem;
        data.cahi_nrem = cahi_nrem;
        data.cahi = cahi;
        data.ahi = oahi + cahi;
        data.ahi_rem = oahi_rem + cahi_rem;
        data.ahi_nrem = oahi_nrem + cahi_nrem;
        data.ai = ai;

        data.eeg_f4 = {f4};
        data.eeg_c4 = {c4};
        data.eeg_o2 = {o2};
        data.eeg_m1 = {m1};
        data.eeg_m2 = {m2};
        data.eeg_loc = {loc};
        data.eeg_roc = {roc};
        data.hypnogram = {int8(sleep_stages)};

        data.central_apnoeas = {int8(central_apnoeas)};
        data.obstructive_apnoeas = {int8(obstructive_apnoeas)};
        data.mixed_apnoeas = {int8(mixed_apnoeas)};
        data.central_hypopneas = {int8(central_hypopneas)};
        data.obstructive_hypopneas = {int8(obstructive_hypopneas)};

        % Store EEG data and labels.
        qch_data = [qch_data; data];
    end

    % All studies complete, save archive.
    save([archive_name '.mat'], 'qch_data', '-v7.3');

    toc
end