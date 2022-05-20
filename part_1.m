%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Noam Cohen 20/04/2022   %
%   Lab - experiment 2      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Convert to amper:
current_units = 0.001;

resistor_tests = {
    'csv_files/resistor_1.csv'
    'csv_files/resistor_2.csv'
};

full_test_path = 'csv_files/resistor_full.csv';

for i = 1:length(resistor_tests)

    %% Grab lab results
    results{i} = readtable(string(resistor_tests(i)));
end

writetable(cat(1,results{:}),full_test_path);
full_results = readtable(string(full_test_path));
y = full_results{:,2}.*current_units;
x = full_results{:,1};
resistor_fit = fit(x,y,'poly1');

%% Plot 

figure
plot(x,y, '.')
hold on
plot(resistor_fit, '--r')
hold off
grid
box on
xlabel('V(V)')
ylabel('I(A)')
legend('Original Data',  'Fitted Curve')

