% Tabulate completed list of studies.
function [study_list] = qch_studies(source)
    tic

    % Generate list.
    study_list = vertcat(dir(source));

    % Remove ghost entries.
    mark_delete = false(size(study_list, 1), 1);

    for i = 1 : size(study_list, 1)
        if size(study_list(i, 1).name) <= 2
            mark_delete(i) = true;
        end
    end

    % Generate clean study list.
    study_list(mark_delete, :) = [];

    toc
end