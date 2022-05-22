%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Noam Cohen 22/05/2022   %
%   Lab - experiment 3      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Error units:
PotentialErrorPrs = 0.6;
PotentialErrorDigit = 0.01;
PlotEveryResistor = 1;

results_addr = {
    'csv_files/part_2/2  - 2438 ohm.csv', 2438;
    'csv_files/part_2/2 - 582 ohm.csv', 582;
    'csv_files/part_2/2 - 3342 ohm.csv', 3342;
    'csv_files/part_2/2 - 4220 ohm.csv', 4220;
    'csv_files/part_2/2 - 5060 ohm.csv', 5060;
    'csv_files/part_2/2 - 6430 ohm.csv', 6430;
    'csv_files/part_2/2 - 7220 ohm.csv', 7220;
    'csv_files/part_2/2 - 8480 ohm .csv', 8480;
    'csv_files/part_2/2 - 9400 ohm.csv', 9400;
    'csv_files/part_2/2 - 10800 ohm.csv', 10800;
};

lifetime = zeros(1,size(results_addr,1));

% Fit each result:
for i = 1:size(results_addr,1)

    %% Grab lab results
    results = readtable(string(results_addr(i,1)));
    y = results{:,5};
    x = results{:,4};


    %% Remove initial plato
    init_value = y(1);
    zero_x_values = find(y == 0);
    plato_x_values = [1; find(y == init_value)];
    for j = 2:length(plato_x_values)
        if (plato_x_values(j) > zero_x_values(1))
            break
        end
        x(1:plato_x_values(j)-plato_x_values(j-1)) = [];
        y(1:plato_x_values(j)-plato_x_values(j-1)) = [];
    end
    
    min_x_values = find(y == min(y));
    zero_x_values = find((y == 0) & (x > x(min_x_values(1))));
    lifetime(i) = (x(zero_x_values(1)) - x(1))/(2*exp(1));

    if PlotEveryResistor
        figure
        hold on
        plot(x,y,'.')
        plot(x(zero_x_values(1)), y(zero_x_values(1)), '.', 'color', 'r')
        hold off
    end

end

resistors = cell2mat(results_addr(:,2))';

% Plot 
figure
hold on
plot(resistors, lifetime, '.')
hold off
grid
box on
xlabel('R(Ohm)')
ylabel('T(S)')
legend('Original Data',  'Fitted Curve')