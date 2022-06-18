%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Noam Cohen 22/05/2022   %
%   Lab - experiment 3      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Error units:
PotentialErrorPrs = 0.6;
PotentialErrorDigit = 0.01;
PlotEveryResistor = 1;
image_save_path = 'G:\My Drive\מעבדה א\מעגלים\graphs\';

results_table = {
    'week 4/csv_files/Q1/10.5 o.csv', 10.5;
    'week 4/csv_files/Q1/22.2 o.csv', 22.2;
    'week 4/csv_files/Q1/30.4.csv', 30.4;
    'week 4/csv_files/Q1/40.8 o.csv', 40.8;
    'week 4/csv_files/Q1/56.6 o.csv', 56.6;
    'week 4/csv_files/Q1/76.8 o.csv', 76.8;
    'week 4/csv_files/Q1/93 o.csv', 93;
};

%% Grab lab results
% Fit each result:

for i = 1:length(results_table)
    
    plot(x,y,'.')

    %% Grab lab results
    results = readtable(string(results_table(i,1)));
    y = results{:,11};
    x = results{:,10};
    amper(i) = max(y)./cell2mat(results_table(i,2))';
end
