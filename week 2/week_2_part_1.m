%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Noam Cohen 22/05/2022   %
%   Lab - experiment 3      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Error units:
PotentialErrorPrs = 0.6;
PotentialErrorDigit = 0.01;
PlotEveryResistor = 1;

results_addr = {
    'csv_files/part_1/1232 ohm.csv', 1232;
    'csv_files/part_1/2446 ohm.csv', 2446;
    'csv_files/part_1/3142 ohm.csv', 3142;
    'csv_files/part_1/4720 ohm.csv', 4720;
    'csv_files/part_1/6120 ohm.csv', 6120;
    'csv_files/part_1/7020 ohm.csv', 7020;
    'csv_files/part_1/8180 ohm.csv', 8180;
    'csv_files/part_1/10830 ohm.csv', 10830;
};

lifetime = zeros(1,size(results_addr,1));

% Fit each result:
for i = 1:size(results_addr,1)

    %% Grab lab results
    results = readtable(string(results_addr(i,1)));
    y = results{:,5};
    x = results{:,4};

    %% use correct zero
    min_x = find(y == min(y));
    if length(min_x) < 5
        x(min_x) = [];
        y(min_x) = [];
    end 
    y = y + abs(min(y));

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
    
    if PlotEveryResistor
        figure
        plot(x,y,'.')
    end

    zero_x_values = find(y == 0);
    lifetime(i) = (x(zero_x_values(1)) - x(1))/(2*exp(1));
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