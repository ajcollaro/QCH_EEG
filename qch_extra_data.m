% Apply study exclusion criteria.
function [dob, dos, sex, oahi_rem, oahi_nrem, oahi, cahi_rem, cahi_nrem, ...
    cahi, ai] = qch_extra_data(study_folder)

    dob = "";
    dos = "";
    sex = "";
    oahi_rem = 0;
    oahi_nrem = 0;
    oahi = 0;
    cahi_rem = 0;
    cahi_nrem = 0;
    cahi = 0;
    ai = 0;
    
    file = '\label_dateofbirth.txt';
    if isfile([study_folder file])
        handle = fopen([study_folder file], 'r');
        % Read.
        dob = convertCharsToStrings([fscanf(handle, '%s')]);

        fclose(handle);
    end

    file = '\label_studydate.txt';
    if isfile([study_folder file])
        handle = fopen([study_folder file], 'r');
        % Read.
        dos = convertCharsToStrings([fscanf(handle, '%s')]);

        fclose(handle);
    end

    file = '\label_sex.txt';
    if isfile([study_folder file])
        handle = fopen([study_folder file], 'r');
        % Read.
        sex = convertCharsToStrings([fscanf(handle, '%s')]);

        fclose(handle);
    end

    file = '\label_oahi_rem.txt';
    if isfile([study_folder file])
        handle = fopen([study_folder file], 'r');
        % Read.
        oahi_rem_pre = [fscanf(handle, '%s')];

        oahi_rem = str2num(oahi_rem_pre);

        fclose(handle);
    end

    file = '\label_oahi_nrem.txt';
    if isfile([study_folder file])
        handle = fopen([study_folder file], 'r');
        % Read.
        oahi_nrem_pre = [fscanf(handle, '%s')];

        oahi_nrem = str2num(oahi_nrem_pre);

        fclose(handle);
    end

    file = '\label_oahi.txt';
    if isfile([study_folder file])
        handle = fopen([study_folder file], 'r');
        % Read.
        oahi_pre = [fscanf(handle, '%s')];

        oahi = str2num(oahi_pre);

        fclose(handle);
    end

    file = '\label_cahi_rem.txt';
    if isfile([study_folder file])
        handle = fopen([study_folder file], 'r');
        % Read.
        cahi_rem_pre = [fscanf(handle, '%s')];

        cahi_rem = str2num(cahi_rem_pre);

        fclose(handle);
    end

    file = '\label_cahi_nrem.txt';
    if isfile([study_folder file])
        handle = fopen([study_folder file], 'r');
        % Read.
        cahi_nrem_pre = [fscanf(handle, '%s')];

        cahi_nrem = str2num(cahi_nrem_pre);

        fclose(handle);
    end

    file = '\label_cahi.txt';
    if isfile([study_folder file])
        handle = fopen([study_folder file], 'r');
        % Read.
        cahi_pre = [fscanf(handle, '%s')];

        cahi = str2num(cahi_pre);

        fclose(handle);
    end

    file = '\label_arousalindex.txt';
    if isfile([study_folder file])
        handle = fopen([study_folder file], 'r');
        % Read.
        ai_pre = [fscanf(handle, '%s')];

        ai = str2num(ai_pre);

        fclose(handle);
    end
    
    toc
end