% Initialisation.
clear; close all; clc;
tic

% QCH. --------------------------------------------------------------------
qch_source = 'Z:\RemLogic Patient Data';

% Create master study lists for each archive sand save as a record.
study_list_2015 = qch_studies([qch_source '\2015']);
study_list_2016 = qch_studies([qch_source '\2016']);
study_list_2017 = qch_studies([qch_source '\2017']);
study_list_2018 = qch_studies([qch_source '\2018']);
study_list_2019 = qch_studies([qch_source '\2019']);
study_list_2020 = qch_studies([qch_source '\2020']);
study_list_2021 = qch_studies([qch_source '\2021']);
study_list_2022 = qch_studies([qch_source '\2022']);
study_list_2023 = qch_studies([qch_source '\2023']);
study_list_2024 = qch_studies([qch_source '\2024']);

save('outputs\study_list_2015.mat', 'study_list_2015');
save('outputs\study_list_2016.mat', 'study_list_2016');
save('outputs\study_list_2017.mat', 'study_list_2017');
save('outputs\study_list_2018.mat', 'study_list_2018');
save('outputs\study_list_2019.mat', 'study_list_2019');
save('outputs\study_list_2020.mat', 'study_list_2020');
save('outputs\study_list_2021.mat', 'study_list_2021');
save('outputs\study_list_2022.mat', 'study_list_2022');
save('outputs\study_list_2023.mat', 'study_list_2023');
save('outputs\study_list_2024.mat', 'study_list_2024');

clear study_list_2015;
clear study_list_2016;
clear study_list_2017;
clear study_list_2018;
clear study_list_2019;
clear study_list_2020;
clear study_list_2021;
clear study_list_2022;
clear study_list_2023;
clear study_list_2024;

% Create event master tables for each archive.
event_handler = 'path\to\eegbidscreator';

% 1 by 1 and clear to save memory.
event_list_2015 = qch_event_processor_bulk(event_handler, study_list_2015);
save('outputs\event_list_2015.mat', 'event_list_2015');
clear event_list_2015;

event_list_2016 = qch_event_processor_bulk(event_handler, study_list_2016);
save('outputs\event_list_2016.mat', 'event_list_2016');
clear event_list_2016;

event_list_2017 = qch_event_processor_bulk(event_handler, study_list_2017);
save('outputs\event_list_2017.mat', 'event_list_2017');
clear event_list_2017;

event_list_2018 = qch_event_processor_bulk(event_handler, study_list_2018);
save('outputs\event_list_2018.mat', 'event_list_2018');
clear event_list_2018;

event_list_2019 = qch_event_processor_bulk(event_handler, study_list_2019);
save('outputs\event_list_2019.mat', 'event_list_2019');
clear event_list_2019;

event_list_2020 = qch_event_processor_bulk(event_handler, study_list_2020);
save('outputs\event_list_2020.mat', 'event_list_2020');
clear event_list_2020;

event_list_2021 = qch_event_processor_bulk(event_handler, study_list_2021);
save('outputs\event_list_2021.mat', 'event_list_2021');
clear event_list_2021;

event_list_2022 = qch_event_processor_bulk(event_handler, study_list_2022);
save('outputs\event_list_2022.mat', 'event_list_2022');
clear event_list_2022;

event_list_2023 = qch_event_processor_bulk(event_handler, study_list_2023);
save('outputs\event_list_2023.mat', 'event_list_2023');
clear event_list_2023;

event_list_2024 = qch_event_processor_bulk(event_handler, study_list_2024);
save('outputs\event_list_2024.mat', 'event_list_2024');
clear event_list_2024;

% Run each year individually.
fprintf('Extracting 2015 archive...\n');
load('outputs\study_list_2015.mat', 'study_list_2015');
load('outputs\event_list_2015.mat', 'event_list_2015');
pipeline_qch(study_list_2015, event_list_2015, '2015', model_settings);
