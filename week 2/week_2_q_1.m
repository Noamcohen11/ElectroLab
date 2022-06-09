%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Noam Cohen 22/05/2022   %
%   Lab - experiment 3      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Error units:
PotentialErrorPrs = 0.6;
PotentialErrorDigit = 0.01;
PlotEveryResistor = 1;
image_save_path = 'G:\My Drive\מעבדה א\מעגלים\graphs\';

results_addr = {
    'week 2/csv_files/Q1/1232 ohm.csv', 1232;
    'week 2/csv_files/Q1/2446 ohm.csv', 2446;
    'week 2/csv_files/Q1/3142 ohm.csv', 3142;
    'week 2/csv_files/Q1/4720 ohm.csv', 4720;
    'week 2/csv_files/Q1/6120 ohm.csv', 6120;
    %'week 2/csv_files/Q1/7020 ohm.csv', 7020;
    'week 2/csv_files/Q1/8180 ohm.csv', 8180;
    'week 2/csv_files/Q1/10830 ohm.csv', 10830;
};

control_time = zeros(1,size(results_addr,1));
control_time_error = zeros(1,size(results_addr,1));

% Fit each result:
for i = 1:size(results_addr,1)

    %% Grab lab results
    results = readtable(string(results_addr(i,1)));
    y = results{:,5};
    x = results{:,4};

    %% use discharged amount as zero
    min_x = find(y == min(y));
    if length(min_x) < 15
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
    x = x - x(1);

    %% Remove data after the capictor discharges.
    zero_x_values = find(y == 0);
    x(zero_x_values(1):length(x)) = [];
    y(zero_x_values(1):length(y)) = [];

    %% Fit the data to recieve dischare control time.
    volt_fit = ExponentFit(x,y);
    fit_values = coeffvalues(volt_fit);
    control_time(i) = 1/fit_values(2);
    conf = confint(volt_fit);        
    control_time_error(i) = abs(1/fit_values(2) - 1/conf(2,2));

    %% Plot volt vs time
    if PlotEveryResistor
        figure
        hold on
        plot(x,y,'.')
        plot(volt_fit)
        grid
        box on
        legend('Original Data',  'Fit')
        hold off
        f = gcf;
        exportgraphics(f,[image_save_path 'volt_vs_time_R_' char(string(results_addr(i,2))) '.png'],'Resolution',300);
    
    end
end
%% Plot resistor vs control time

%resistors are defined in results_addr.
resistors = cell2mat(results_addr(:,2))';
resistor_error = resistors.*PotentialErrorPrs/100 + PotentialErrorDigit;

figure
hold on
errorbar(resistors , control_time, control_time_error, control_time_error, resistor_error , resistor_error ,'LineStyle','none', 'LineWidth', 2)
capacitor_fit = fit(resistors',control_time','poly1');
plot(0,0)
plot(capacitor_fit, '--');
ylim([0 max(control_time) + 0.0002])
hold off 
grid
box on
xlabel('R(Ohm)')
ylabel('T(S)')
legend('Original Data',  'Fit', 'location', 'northwest')
f = gcf;
exportgraphics(f,[image_save_path 'resistor_vs_control_time' '.png'],'Resolution',300);

function f = ExponentFit(x, y)
    coefficients = {'a', 'b'};
    fitt = fittype('a*exp(-b*x)','coefficients', coefficients);
    f = fit(x,y,fitt);
end