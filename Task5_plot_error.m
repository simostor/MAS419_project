% Plotting absolute error

t = out.Absolute_position_error.time;
e = out.Absolute_position_error.signals.values;

targetTimes = [0 2 4 6 8];
indices = zeros(size(targetTimes));

for k = 1:numel(targetTimes)
    [~, indices(k)] = min(abs(t - targetTimes(k)));
end

figure
plot(t, e)
grid on
hold on
plot(t(indices), e(indices), 'o')

customText = ["P1"; "P2"; "P3"; "P4"; "P5"];

labels = arrayfun(@(val, txt) sprintf('%.2f mm\n%s', val, txt), ...
    e(indices), customText, 'UniformOutput', false);

dx = 0.02 * (max(t) - min(t));
dy = 0.02 * (max(e) - min(e));

text(t(indices) + dx, e(indices) + dy, labels, ...
    'VerticalAlignment', 'middle', ...
    'HorizontalAlignment', 'left', ...
    'FontSize', 10, ...
    'Interpreter', 'none')

xlabel('Time [s]')
ylabel('Absolute position error [mm]')
legend('Absolute position error')
title('Absolute position error')