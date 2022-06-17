
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Noam Cohen 22/05/2022   %
%   Lab - experiment 3      %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Error units:
PlotEveryResistor = 1;
image_save_path = 'G:\My Drive\מעבדה א\מעגלים\graphs\';

results_addr = {

    'week 3/csv_files/Q2/15 k hz.csv', 15;
    'week 3/csv_files/Q2/14 kHz.csv', 14;
    'week 3/csv_files/Q2/16.5 kHz.csv', 16.5;
    'week 3/csv_files/Q2/14 kHz.csv', 14;
    'week 3/csv_files/Q2/18.8 kHz.csv', 18.8;
    'week 3/csv_files/Q2/24.2  kHz.csv', 24.2;
    'week 3/csv_files/Q2/26.5 kHz.csv', 26.5;
    'week 3/csv_files/Q2/28.6 kHz.csv', 28.6;
    'week 3/csv_files/Q2/25.3 k hz.csv',25.3;
    'week 3/csv_files/Q2/29.6 khz.csv',29.6;
    'week 3/csv_files/Q2/29.5 k hz.csv', 29.5;
    'week 3/csv_files/Q2/30.9 k hz.csv', 30.9;
    'week 3/csv_files/Q2/31.9  k hz.csv', 31.9;
    'week 3/csv_files/Q2/32.5 k hz.csv', 32.5;
     'week 3/csv_files/Q2/32.7 k hz.csv', 32.7;
    % 'week 3/csv_files/Q2/33.082 k hz.csv', 33,082;
    'week 3/csv_files/Q2/33.00 k hz.csv', 33.00;
    'week 3/csv_files/Q2/33.150 k hz.csv', 33.150;
    'week 3/csv_files/Q2/33.182 k hz.csv', 33.182;
    'week 3/csv_files/Q2/33.26.csv', 33.26;
    'week 3/csv_files/Q2/33.3 k hz.csv', 33.3;
    'week 3/csv_files/Q2/33.386 k hz.csv', 33.386;
    'week 3/csv_files/Q2/33.4 k hz.csv', 33.4;
    'week 3/csv_files/Q2/33.4.csv', 33.4;
    'week 3/csv_files/Q2/33.5 k Hz.csv', 33.5;
    'week 3/csv_files/Q2/33.6 k hz.csv', 33.6;
    'week 3/csv_files/Q2/33.604 k hz.csv', 33.604;
    'week 3/csv_files/Q2/33.72 k hz.csv', 33.72;
    'week 3/csv_files/Q2/33.92 k hz.csv', 33.92;
    'week 3/csv_files/Q2/33.98 k hz.csv', 33.98;
    'week 3/csv_files/Q2/34.387 k hz.csv', 34.387;
    'week 3/csv_files/Q2/34.5 k hz.csv', 34.5;
    'week 3/csv_files/Q2/35.5 k hz.csv', 35.5;
    'week 3/csv_files/Q2/36.3 k hz.csv', 36.3;
    'week 3/csv_files/Q2/37.2 k hz.csv', 37.2;
    'week 3/csv_files/Q2/38.4 k hz.csv', 38.4;
    'week 3/csv_files/Q2/39.46 k hz.csv', 39.46;
    'week 3/csv_files/Q2/40.6 k hz.csv', 40.6;
    'week 3/csv_files/Q2/41.4 k hz.csv', 41.4;
    'week 3/csv_files/Q2/43 k hz.csv', 43;
    'week 3/csv_files/Q2/45 k hz.csv', 45;
    'week 3/csv_files/Q2/46 k hz.csv', 46;
    'week 3/csv_files/Q2/51.7 k hz.csv', 51.7;
    'week 3/csv_files/Q2/54 k hz.csv', 54;
    'week 3/csv_files/Q2/7 k hz.csv', 7;
    'week 3/csv_files/Q2/9.5 k hz.csv', 9.5;
};

amplitude_ratio = zeros(1,size(results_addr,1));
phase_diff = zeros(1,size(results_addr,1));

% Fit each result:
for i = 1:size(results_addr,1)

    %% Grab lab results
    results = readtable(string(results_addr(i,1)));
    signal_y = results{:,11};
    signal_x = results{:,10};
    og_y = results{:,5};
    og_x = results{:,4};

    %% convert 0 to mean
    signal_y = signal_y - mean(signal_y);
    og_y = og_y - mean(og_y);
    signal_fit = SinWave(signal_x, signal_y);
    og_fit = SinWave(og_x, og_y);
    signal_params = confint(signal_fit);
    og_params = confint(og_fit);   
    amplitude_ratio(i) = signal_params(2,1)/og_params(2,1);
    phase_diff(i) = abs(signal_params(2,1) - og_params(2,1));

end

herz = cell2mat(results_addr(:,2))';

PlotFunc(herz, amplitude_ratio);
xlabel('frequency(Herz)')
ylabel('amplitude Ratio')

PlotFunc(herz, phase_diff);
xlabel('frequency(Herz)')
ylabel('phase diff')

function f = SinWave(x, y)
    coefficients = {'a', 'b', 'c'};
    fo = fitoptions('Method','NonlinearLeastSquares', 'StartPoint', [7.0323 2.5143e+05 -2.6642]); % Use the parameters gathered as starting points.
    fitt = fittype('a*sin(b*x + c)','coefficients', coefficients,'options', fo);
    f = fit(x,y,fitt);
end

function PlotFunc(x,y)
    figure
    hold on
    box on
    grid
    plot(x,y, '.')
    hold off
end 

