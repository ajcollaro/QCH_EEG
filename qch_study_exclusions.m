% Apply study exclusion criteria.
function [flag, age] = qch_study_exclusions(study_folder)

    age = 0;
    flag = false;

    % Age criteira.
    file = '\age_label.txt';
    if isfile([study_folder file])
        handle = fopen([study_folder file], 'r');
        % Read.
        read_age = [fscanf(handle, '%s')];
        age = str2num(read_age);

        if isempty(age)
            age = 9999;
        end

        fclose(handle);
    end

    % File containing measurement.
    file = '\study_type.txt';
    if isfile([study_folder file])
        handle = fopen([study_folder file], 'r');
        % Read.
        read_study_type = [fscanf(handle, '%s')];
        read_study_type = string(read_study_type);
        fclose(handle);

        % Is this a Diagnostic study?
        if contains(read_study_type, 'iagnostic')
            if age >= 1 && age ~= 9999
                flag = true;
            end
        else
            flag = false;
        end

        % Check what also could be in a Diagnostic study.
        if contains(read_study_type, 'O2') || ...
            contains(read_study_type, 'xygen') || ...
            contains(read_study_type, 'Split') || ...
            contains(read_study_type, 'PAP')
            flag = false;
        end

        % Exclude based on date.
        if contains(study_folder, '2022') || ...
            contains(study_folder, '2023') || ...
            contains(study_folder, '2024')
            flag = false;
        end
    end

    if isfile([study_folder '\Tx Flow.ebm']) || ...
            isfile([study_folder '\Tx Leak.ebm']) || ...
            isfile([study_folder '\Leak - Respironics.ebm']) || ...
            isfile([study_folder '\Flow - Trilogy.ebm']) || ...
            isfile([study_folder '\Mask Pressure.ebm'])
        flag = false;
    end
            
    
    toc
end