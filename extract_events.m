function [sleep_stages, staging_info] = extract_events(events, model_settings)
    tic

    sleep_stages = 0;
    staging_info = struct();

    epoch = 0;
    
    % Create event list.
    for i = 1 : height(events)  
        if contains(events.trial_type(i), "SLEEP-UNSCORED", 'IgnoreCase', true)
            epoch = epoch + 1;
            sleep_stages(epoch) = 9999;
        elseif contains(events.trial_type(i), "SLEEP-S0", 'IgnoreCase', true)
            epoch = epoch + 1;
            sleep_stages(epoch) = 1;
        elseif contains(events.trial_type(i), "SLEEP-S1", 'IgnoreCase', true)
            epoch = epoch + 1;
            sleep_stages(epoch) = 2;
        elseif contains(events.trial_type(i), "SLEEP-S2", 'IgnoreCase', true)
            epoch = epoch + 1;
            sleep_stages(epoch) = 2;
        elseif contains(events.trial_type(i), "SLEEP-S3", 'IgnoreCase', true)
            epoch = epoch + 1;
            sleep_stages(epoch) = 3;
        elseif contains(events.trial_type(i), "SLEEP-S4", 'IgnoreCase', true)
            epoch = epoch + 1;
            sleep_stages(epoch) = 9999;
        elseif contains(events.trial_type(i), "SLEEP-NREM", 'IgnoreCase', true)
            epoch = epoch + 1;
            sleep_stages(epoch) = 9999;
        elseif contains(events.trial_type(i), "SLEEP-REM", 'IgnoreCase', true)
            epoch = epoch + 1;
            sleep_stages(epoch) = 4;
        else
            continue;
        end

        if (epoch == 1)
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
    end

    staging_info.epochs = epoch;
    staging_info.epoch_samples = epoch * 30;
    staging_info.discard = model_settings.fs * staging_info.offset;
    staging_info.samples = (staging_info.epoch_samples * model_settings.fs) ...
        - staging_info.discard;

    sleep_stages = sleep_stages';

    toc
end