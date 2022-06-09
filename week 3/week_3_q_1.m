%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Noam Cohen 22/05/2022   %
%   Lab - experiment 3      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Error units:
PotentialErrorPrs = 0.6;
PotentialErrorDigit = 0.01;
PlotEveryResistor = 1;
image_save_path = 'G:\My Drive\מעבדה א\מעגלים\graphs\';

overdamped_test = 'week 3/csv_files/Q1/3.56 k ohm underdamped.csv';

%% Grab lab results
results = readtable(string(overdamped_test));
y = results{:,11};
x = results{:,10};

figure
hold on
plot(x,y,'.')
grid
box on
legend('Original Data',  'Fit')
hold off
f = gcf;
exportgraphics(f,[image_save_path 'week_3_overdamp.png'],'Resolution',300);

function f = ExponentFit(x, y)
    coefficients = {'a', 'b'};
    fitt = fittype('a*exp(-b*x)','coefficients', coefficients);
    f = fit(x,y,fitt);
end