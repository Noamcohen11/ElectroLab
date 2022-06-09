%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Noam Cohen 21/05/2022   %
%   Lab - experiment 3      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Convert to amper:
CurrentUnits = 0.001;
%Error units:
AmpmeterErrorPrs = 0.5;
AmpmeterErrorDigit = 0.0001;
VoltmeterErrorPrs = 0.6;
VoltmeterErrorDigit = 0.01;


resistor_tests = {
    'week 1/csv_files/resistor_1.csv'
    'week 1/csv_files/resistor_2.csv'
};

full_test_path = 'week 1/csv_files/resistor_full.csv';

for i = 1:length(resistor_tests)

    %% Grab lab results
    results{i} = readtable(string(resistor_tests(i)));
end

writetable(cat(1,results{:}),full_test_path);
full_results = readtable(string(full_test_path));
y = full_results{:,2}.*CurrentUnits;
x = full_results{:,1};
y_error = y.*AmpmeterErrorPrs/100 + AmpmeterErrorDigit;
x_error = x.*VoltmeterErrorPrs/100 + VoltmeterErrorDigit;

%% Plot 
resistor_fit = fit(x,y,'poly1');
figure
hold on
errorbar(x , y, y_error, y_error, x_error, x_error,'LineStyle','none', 'LineWidth', 2)
plot(resistor_fit, '--r')
hold off
grid
box on
xlabel('V(V)')
ylabel('I(A)')
legend('Original Data',  'Fitted Curve')

