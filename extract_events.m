function [sleep_stages, staging_info, cen_apnoea, obs_apnoea, mix_apnoea, ...
    cen_hypop, obs_hypop] = extract_events(events, model_settings)
    tic

    sleep_stages = 0;

    obs_apnoea = 0;
    cen_apnoea = 0;
    mix_apnoea = 0;
    obs_hypop = 0;
    cen_hypop = 0;

    staging_info = struct();
    staging_info.offset = 0;

    staging_info.start = 9999;
    staging_info.stop = 9999;

    epoch_overall = 0;
    epoch = 0;
    
    % Create event list.
    for i = 1 : height(events)
        if (i == 1)
            staging_info.offset = events.onset(i);
        end
    
        if (i > 1)
            if (events.onset(i) == events.onset(i - 1) && ...
                    contains(events.trial_type(i), "SLEEP", 'IgnoreCase', true) && ...
                    contains(events.trial_type(i - 1), "SLEEP", 'IgnoreCase', true))
                fprintf('Duplicate scoring detected\n');
                continue;
            end
        end

        if contains(events.trial_type(i), "SLEEP-", 'IgnoreCase', true)
            epoch_overall = epoch_overall + 1;
        end

        if contains(events.trial_type(i), "ANALYSIS-START", 'IgnoreCase', true)
            staging_info.start = epoch_overall;
        elseif contains(events.trial_type(i), "ANALYSIS-STOP", 'IgnoreCase', true)
            staging_info.stop = epoch_overall;
        end

        if i < staging_info.start || i > staging_info.stop
            continue;
        end

        if contains(events.trial_type(i), "SLEEP-UNSCORED", 'IgnoreCase', true)
            epoch = epoch + 1;
            sleep_stages(epoch) = 1;
        elseif contains(events.trial_type(i), "SLEEP-S0", 'IgnoreCase', true)
            epoch = epoch + 1;
            sleep_stages(epoch) = 1;
        elseif contains(events.trial_type(i), "SLEEP-S1", 'IgnoreCase', true)
            epoch = epoch + 1;
            sleep_stages(epoch) = 2;
        elseif contains(events.trial_type(i), "SLEEP-S2", 'IgnoreCase', true)
            epoch = epoch + 1;
            sleep_stages(epoch) = 3;
        elseif contains(events.trial_type(i), "SLEEP-S3", 'IgnoreCase', true)
            epoch = epoch + 1;
            sleep_stages(epoch) = 4;
        elseif contains(events.trial_type(i), "SLEEP-S4", 'IgnoreCase', true)
            epoch = epoch + 1;
            sleep_stages(epoch) = 4;
        elseif contains(events.trial_type(i), "SLEEP-NREM", 'IgnoreCase', true)
            epoch = epoch + 1;
            sleep_stages(epoch) = 6; % For spotting infant/poor quality studies
        elseif contains(events.trial_type(i), "SLEEP-REM", 'IgnoreCase', true)
            epoch = epoch + 1;
            sleep_stages(epoch) = 5;
        end

        if contains(events.trial_type(i), "APNEA-OBSTRUCTIVE", 'IgnoreCase', true)
            obs_apnoea(epoch) = 1;
        elseif contains(events.trial_type(i), "APNEA-CENTRAL", 'IgnoreCase', true)
            cen_apnoea(epoch) = 1;
        elseif contains(events.trial_type(i), "APNEA-MIXED", 'IgnoreCase', true)
            mix_apnoea(epoch) = 1;
        elseif contains(events.trial_type(i), "HYPOPNEA-OBSTRUCTIVE", 'IgnoreCase', true)
            obs_hypop(epoch) = 1;
        elseif contains(events.trial_type(i), "HYPOPNEA-CENTRAL", 'IgnoreCase', true)
            cen_hypop(epoch) = 1;    
        end
    end

    obs_apnoea(end + 1 : epoch) = 0;
    cen_apnoea(end + 1 : epoch) = 0;
    mix_apnoea(end + 1 : epoch) = 0;
    obs_hypop(end + 1 : epoch) = 0;
    cen_hypop(end + 1 : epoch) = 0;

    staging_info.epochs = epoch;
    staging_info.epoch_samples = epoch * 30;
    staging_info.discard = model_settings.fs * staging_info.offset;
    staging_info.samples = (staging_info.epoch_samples * model_settings.fs) ...
        - staging_info.discard;

    sleep_stages = sleep_stages';

    toc
end