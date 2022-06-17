%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Noam Cohen 21/05/2022   %
%   Lab - experiment 3      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Convert to amper:
VoltUnits = 0.001;
AmperUnits = 0.001;
%Error units:
PotentialErrorPrs = 0.6;
PotentialErrorDigit = 0.01;
VoltmeterErrorPrs = 0.6;
VoltmeterErrorDigit = 0.01;
AmpmeterErrorPrs = 0.5;
AmpmeterErrorDigit = 0.0001;
InitVolt = 1.187;
image_save_path = 'G:\My Drive\מעבדה א\מעגלים\graphs\';
part_a_test = 'week 1/csv_files/q5.csv';

part_a_results = readtable(string(part_a_test));
r = part_a_results{:,1};
v = part_a_results{:,2}*VoltUnits;
i = part_a_results{:,3}*AmperUnits;
v_diff = InitVolt - v;
r_error = r.*PotentialErrorPrs/100 + PotentialErrorDigit;
v_error = v.*VoltmeterErrorPrs/100 + VoltmeterErrorDigit;
i_error = i.*AmpmeterErrorPrs/100 + AmpmeterErrorDigit;
vdiff_error = sqrt(v_error.^2 + (InitVolt*VoltmeterErrorPrs/100 + VoltmeterErrorDigit).^2);

%% Plot v vs r
figure
hold on
errorbar(r , v, v_error, v_error, r_error, r_error,'LineStyle','none', 'LineWidth', 2)
volt_fit = VoltageFit(r,v);
plot(volt_fit, '--r')
grid
box on
xlabel('R(Ohm)')
ylabel('V(V)')
legend('Original Data',  'Fitted Curve')
ylim([0 max(v) + 0.2])
hold off
f = gcf;
exportgraphics(f,[image_save_path 'ressitor_vs_volt.png'],'Resolution',300);


%% Plot v diff vs i
figure
hold on
errorbar(i , v_diff, vdiff_error, vdiff_error, i_error, i_error,'LineStyle','none', 'LineWidth', 2)
vdiff_fit = fit(i,v_diff,'poly1');
plot(vdiff_fit, '--r')
grid
box on
xlabel('I(A)')
ylabel('Vdiff(V)')
legend('Original Data',  'Fitted Curve')
hold off
f = gcf;
exportgraphics(f,[image_save_path 'vdiff_vs_current.png'],'Resolution',300);


function f = VoltageFit(x, y)
    coefficients = {'a', 'b'};
    fitt = fittype('a*x/(x+b)','coefficients', coefficients);
    f = fit(x,y,fitt);
end