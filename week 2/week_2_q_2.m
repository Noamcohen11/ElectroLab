%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Noam Cohen 22/05/2022   %
%   Lab - experiment 3      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Error units:
PotentialErrorPrs = 0.6;
PotentialErrorDigit = 0.01;
PlotEveryResistor =1;

results_addr = {
      %'csv_files/Q2/2  - 2438 ohm.csv', 2438;
      'csv_files/Q2/2 - 582 ohm.csv', 582;
      %'csv_files/Q2/2 - 3342 ohm.csv', 3342;
      %'csv_files/Q2/2 - 4220 ohm.csv', 4220;
      %'csv_files/Q2/2 - 5060 ohm.csv', 5060;
      %'csv_files/Q2/2 - 6430 ohm.csv', 6430;
      %'csv_files/Q2/2 - 7220 ohm.csv', 7220;
      %'csv_files/Q2/2 - 8480 ohm .csv', 8480;
      %'csv_files/Q2/2 - 9400 ohm.csv', 9400;
      %'csv_files/Q2/2 - 10800 ohm.csv', 10800;
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
    x = x - x(1);

    %% Remove data after the capictor discharges.
    zero_x_values = find(y == 0);
    x = x(zero_x_values(length(zero_x_values)):length(x));
    y = y(zero_x_values(length(zero_x_values)):length(y));
    x = x - x(1);

    volt_fit = ExponentFit(x,y);
    fit_values = coeffvalues(volt_fit);
    control_time(i) = 1/fit_values(2);
    conf = confint(volt_fit);
    control_time_error(i) = abs(1/fit_values(2) - 1/conf(2,2));

    if PlotEveryResistor
        figure
        hold on
        plot(x,y,'.')
        plot(volt_fit)
        hold off
        xlabel('T(S)')
        ylabel('V(V)')
        legend('Original Data',  'Fit', 'location', 'northwest')
    end

end

% resistors = cell2mat(results_addr(:,2))';
% resistor_error = resistors.*PotentialErrorPrs/100 + PotentialErrorDigit;

% figure
% hold on
% k = 1./control_time;
% % plot (resistors, 1./control_time, '.')
% errorbar(resistors , 1./control_time, (1./control_time)*(control_time_error/control_time), (1./control_time)*(control_time_error/control_time), resistor_error , resistor_error ,'LineStyle','none', 'LineWidth', 2)
% capacitor_fit = fit(resistors',1./control_time','poly1');
% plot(0,0)
% plot(capacitor_fit, '--');
% % ylim([0 max(control_time) + 0.0002])
% hold off 
% grid
% box on
% xlabel('R(Ohm)')
% ylabel('T(S)')
% legend('Original Data',  'Fit', 'location', 'northwest')
% f = gcf;

function f = ExponentFit(x, y)
    coefficients = {'a', 'b'};
    fitt = fittype('a*(1- exp(-b*x))','coefficients', coefficients);
    f = fit(x,y,fitt);
end