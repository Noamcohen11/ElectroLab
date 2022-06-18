%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Noam Cohen 22/05/2022   %
%   Lab - experiment 3      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Error units:
PotentialErrorPrs = 0.6;
PotentialErrorDigit = 0.01;
PlotEveryResistor = 1;
image_save_path = 'G:\My Drive\מעבדה א\מעגלים\graphs\';

overdamped_test = 'week 3/csv_files/Q1/overdamped 20.96 ohm.csv';
underdamped_test = 'week 3/csv_files/Q1/3.56 k ohm underdamped.csv';
% min_resistor_test = 'week 3/csv_files/Q1/10 ohm underdamped.csv';
criticaldamp_test = 'week 3/csv_files/Q1/critical test 6.84 k ohm.csv';
tests = {underdamped_test overdamped_test criticaldamp_test};

%% Grab lab results
% Fit each result:

for i = 1:length(tests)

    %% Grab lab results
    results = readtable(string(tests(i)));
	y = results{:,11};
	x = results{:,10};

    %% use discharged amount as zero
    while length(find(y == y(length(y)))) < 15
        x(y == y(length(y))) = [];
        y(y == y(length(y))) = [];
    end
    final = y(length(y));
    y = y - final;

    %%remove initial charge
    initial_max = find(y == max(y));
    x(1:initial_max(1)) = [];
    y(1:initial_max(1)) = [];

    %% Remove initial plato
    init_value = y(1);
    if (i == 2)
    	init_value = y(17);
	end
    if (i == 3)
        init_value = y(2);
    end
    plato_x_values = [1; find(y == init_value)];
    for j = 2:length(plato_x_values)
        x(1:plato_x_values(j)-plato_x_values(j-1)) = [];
        y(1:plato_x_values(j)-plato_x_values(j-1)) = [];
    end
    x = x - x(1);

    % Remove data after the capictor discharges.
    % x_of_min_y = find(y == min(y));
    % zero_x_values = find(y == 0);
    % valid_values = find(zero_x_values > x_of_min_y(1));

    % x(zero_x_values(valid_values(1) + 2):length(x)) = [];
    % y(zero_x_values(valid_values(1) + 2):length(y)) = [];

    %Fit and plot
    if (i == 1)
    	figure
		hold on
		grid
		box on
		plot(x,y,'.')
        under_fit = UnderDampedFit(x,y);
	    plot(under_fit);
	    legend('original data','underdamped fit');
	    f = gcf;
	    exportgraphics(f,[image_save_path 'week_3_underdamp.png'],'Resolution',300);
    end

    if (i == 2)
    	figure
		hold on
		grid
		box on
		plot(x,y,'.')
        over_fit = OverDampedFit(x,y);
	    plot(over_fit);
	    legend('original data','overdamped fit');
	    f = gcf;
	    exportgraphics(f,[image_save_path 'week_3_overdamp.png'],'Resolution',300);
    end

    if (i == 3)
    	figure
		hold on
		grid
		box on
		plot(x,y,'.')
        crit_fit = CriticalDampFit(x,y);
	    plot(crit_fit);
        xlabel('volt[V]')
        ylabel('Time[S]')
	    legend('original data','criticaly damped fit');
	    f = gcf;
	    exportgraphics(f,[image_save_path 'week_3_criticaly_damped.png'],'Resolution',300);
    end
end

function f = UnderDampedFit(x, y)
    %% Get fit parametes:
    
    fit_params = [0.0100 70000 0.3300 10000];
    %% Fit:
    fo = fitoptions('Method','NonlinearLeastSquares', 'StartPoint', fit_params);         % Use the parameters gathered as starting points.
    fitt = fittype('a.*exp(-b*x).*(cos(x*w)) + c.*exp(-b*x).*(sin(x*w))','coefficients', {'a', 'b', 'c', 'w'}, 'options', fo);
    f = fit(x,y,fitt);
end

function f = OverDampedFit(x, y)
    %% Get fit parametes:
    
    fit_params = [0.7952 0.1869 0.4898 120000];
    %% Fit:
    fo = fitoptions('Method','NonlinearLeastSquares', 'StartPoint', fit_params);         % Use the parameters gathered as starting points.
    fitt = fittype('a*exp(-b*x) + c*exp(-d*x)','coefficients', {'a', 'b', 'c', 'd'}, 'options', fo);
    f = fit(x,y,fitt);
end

function f = CriticalDampFit(x, y)
    %% Get fit parametes:
    
    fit_params = [-0.0020 60000 0.0034];
    %% Fit:
    fo = fitoptions('Method','NonlinearLeastSquares', 'StartPoint', fit_params);         % Use the parameters gathered as starting points.
    fitt = fittype('(a*x+b)*exp(-c*x)','coefficients', {'a', 'b', 'c'}, 'options', fo);
    f = fit(x,y,fitt);
end