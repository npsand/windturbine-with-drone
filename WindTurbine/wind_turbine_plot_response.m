% Code to plot simulation results for sscv_wind_turbine
%% Plot Description:
%
% This script shows how to generate plot of the state transitions,
% normalized physical quantities such as wind speed, wind turbine rotation
% speed, generator power, and pitch angle.

% Copyright 2021-22 The MathWorks, Inc.

% Generate new simulation results

logs_wind_turbine_system = ans.logsout;

% Reuse figure if it exists, else create new figure
if ~exist('wind_turbine_results', 'var') || ...
        ~isgraphics(wind_turbine_results, 'figure')
    wind_turbine_results = figure('Name', 'wind_turbine_results');
end
figure(wind_turbine_results)
clf(wind_turbine_results)
baseValues = [pitchBrakeAngle, turbineRatedPower, vWindCutOut,...
    wTurbineCutOut]; % Base values for normalized physical quantities calculation
plotCharacteristicsCurve(logs_wind_turbine_system,baseValues)
clear baseValues

% Plot simulation results
function plotCharacteristicsCurve(logsout,baseValues)

% Get simulation results
t1 = logsout{2}.Values.Time; % Parking brake state
p1 = logsout{2}.Values.Data;
t2 = logsout{3}.Values.Time; % Generator trip state
p2 = logsout{3}.Values.Data;
t3 = logsout{4}.Values.Time; % Turbine operation state
p3 = logsout{4}.Values.Data;
t4 = logsout{5}.Values.Time; % Pitch angle (deg)
p4 = logsout{5}.Values.Data;
t5 = logsout{6}.Values.Time; % Generator power (MW)
p5 = logsout{6}.Values.Data;
t6 = logsout{7}.Values.Time; % Wind speed (m/s)
p6 = logsout{7}.Values.Data;
t7 = logsout{1}.Values.Time; % Pitch brake state
p7 = logsout{1}.Values.Data;
t8 = logsout{8}.Values.Time; % Turbine rotor rotation speed (rpm)
p8 = logsout{8}.Values.Data;

% Plot results
tiledlayout(2,1)
ax1 = nexttile;
plot(t7, p7,'k','linewidth',3,'LineStyle','--')
hold on
plot(t1, p1,'c','linewidth',1.5,'LineStyle','-.')
plot(t2, p2,'r','linewidth',1.5,'LineStyle','--')
plot(t3, p3,'g','linewidth',1.5,'LineStyle','-.')
grid on
legend('Pitch brake state','Parking brake state','Generator trip state',...
    'Turbine operation state','Location', 'Best')
xlabel('Time (s)')
title('State transitions')

ax2 = nexttile;
plot(t4, p4(:,:)./baseValues(1),'k','linewidth',2,'LineStyle','-.')
hold on
plot(t5, p5(:,:)/baseValues(2),'c','linewidth',2,'LineStyle','--')
plot(t6, p6/baseValues(3),'r','linewidth',2,'LineStyle','-.')
plot(t8, p8/baseValues(4),'g','linewidth',2,'LineStyle','-.')
legend('Pitch angle','Generator power',...
    'Wind speed','Turbine rotation speed','Location', 'Best')
grid on
xlabel('Time (s)')
title('Physical quantities normalized by safety limit value')
linkaxes([ax1 ax2],'x')
end