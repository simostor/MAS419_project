
%% Required Torque Plot
% Plots all six joint torque signals and marks the maximum
% absolute torque value for each joint.

close all

%% Extract data from Simulink
ScopeData = out.ScopeData;

% Extract time values
t = ScopeData.time;

% Define joint names
jointNames = {'A', 'B1', 'B2', 'G1', 'H1', 'I1'};

% Get the number of torque signals
nSignals = numel(ScopeData.signals);

% Create matrix for all torque signals
T = zeros(length(t), nSignals);

% Extract torque values from each signal
for i = 1:nSignals
    T(:,i) = ScopeData.signals(i).values(:);
end

%% Create figure
figure('Color','w');
hold on
grid on

% Define colors for the torque signals
colors = lines(nSignals);

%% Plot torque signals
for i = 1:nSignals

    % Plot torque signal with correct joint name
    plot(t, T(:,i), ...
        'Color', colors(i,:), ...
        'LineWidth', 1.5, ...
        'DisplayName', ['Torque ' jointNames{i}]);

    % Find the maximum absolute torque value
    [~, idx] = max(abs(T(:,i)));

    % Get actual torque value and corresponding time
    maxTorque = T(idx,i);
    maxTime = t(idx);

    % Mark the maximum absolute torque
    plot(maxTime, maxTorque, 'o', ...
        'MarkerFaceColor', colors(i,:), ...
        'MarkerEdgeColor', 'k', ...
        'MarkerSize', 9, ...
        'HandleVisibility', 'off');

    % Display the actual torque value with joint name
    text(maxTime, maxTorque, ...
        sprintf('  %s: %.1f Nm', jointNames{i}, maxTorque), ...
        'FontSize', 10, ...
        'FontWeight', 'bold', ...
        'Color', colors(i,:));

end

%% Figure settings
xlabel('Time [s]')
ylabel('Torque [Nm]')
title('Required Joint Torque')

% Show legend with correct joint names
legend('Location','best')

% Set time limits
xlim([min(t) max(t)])

% Improve figure size for report
set(gcf, 'Position', [100 100 1200 650])

%% Save figure for report
% Export high-resolution image
exportgraphics(gcf, 'Required_Torque_plot.png', ...
    'Resolution', 300);
