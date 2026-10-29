


clear; clc; close all;

%% Model
mdl = 'Simscape_model_optimization';
load_system(mdl);

set_param(mdl,'SimulationMode','normal');
set_param(mdl,'SimMechanicsOpenEditorOnUpdate','off');

%% Parameters - A, B1 and B2
names = {'KpA_pos','KiA_pos', ...
    'KpB1_pos','KiB1_pos', ...
    'KpB2_pos','KiB2_pos'};

p = sdo.getParameterFromModel(mdl,names);

%% Initial values
initial = [150 2 200 30 150 20];

%% Parameter limits
lower = [0 0 0 0 0 0];
upper = [10000 10000 10000 10000 10000 10000];

for k = 1:numel(p)
    p(k).Value = initial(k);
    p(k).Minimum = lower(k);
    p(k).Maximum = upper(k);
end

%% Simulation setup
Simulator = sdo.SimulationTest(mdl);
Simulator.Parameters = p;
Simulator = setup(Simulator,FastRestart="on");

%% Optimization
opts = sdo.OptimizeOptions;

try
    [result,info] = sdo.optimize( ...
        @(p)objectiveFunc(p,Simulator),p,opts);

    %% Save optimized parameters to model workspace
    sdo.setValueInModel(mdl,result);

catch ME
    restore(Simulator);
    rethrow(ME);
end

restore(Simulator);

%% Results
fprintf('\n--- OPTIMIZED PARAMETERS ---\n');

for k = 1:numel(result)
    fprintf('%s = %.6f\n', ...
        result(k).Name,result(k).Value);
end

disp(info);

%% Objective function
function vals = objectiveFunc(p,Simulator)

%% Update parameters
Simulator.Parameters = p;

%% Simulate
simOut = sim(Simulator);
logs = simOut.LoggedData.logsout;

%% Position errors
errA = logs.get('KpA_err_pos_log').Values;
errB1 = logs.get('KpB1_err_pos_log').Values;
errB2 = logs.get('KpB2_err_pos_log').Values;

%% Objective function
K_err = 1e3;

JA = trapz(errA.Time,(K_err*errA.Data).^2);
JB1 = trapz(errB1.Time,(K_err*errB1.Data).^2);
JB2 = trapz(errB2.Time,(K_err*errB2.Data).^2);

J = JA + JB1 + JB2;

vals.F = J;

%% Progress
fprintf(['KpA = %.2f | KiA = %.2f | ', ...
    'KpB1 = %.2f | KiB1 = %.2f | ', ...
    'KpB2 = %.2f | KiB2 = %.2f | J = %.6f\n'], ...
    p(1).Value,p(2).Value, ...
    p(3).Value,p(4).Value, ...
    p(5).Value,p(6).Value,J);

end

% 
% clear; clc; close all;
% 
% % Model
% mdl = 'Simscape_model_optimization';
% load_system(mdl);
% 
% set_param(mdl,'SimulationMode','normal');
% set_param(mdl,'SimMechanicsOpenEditorOnUpdate','off');
% 
% % Parameters - Joint A
% p = sdo.getParameterFromModel(mdl, ...
%     {'KpA_pos','KiA_pos'});
% 
% p(1).Value = 150;
% p(1).Minimum = 0;
% p(1).Maximum = 1000;
% 
% p(2).Value = 2;
% p(2).Minimum = 0;
% p(2).Maximum = 100;
% 
% % Simulation setup
% Simulator = sdo.SimulationTest(mdl);
% Simulator.Parameters = p;
% Simulator = setup(Simulator,FastRestart="on");
% 
% % Optimization
% opts = sdo.OptimizeOptions;
% 
% try
%     [result,info] = sdo.optimize( ...
%         @(p)objectiveFunc(p,Simulator),p,opts);
% 
%     % Save optimized parameters
%     sdo.setValueInModel(mdl,result);
% 
% catch ME
%     restore(Simulator);
%     rethrow(ME);
% end
% 
% restore(Simulator);
% 
% % Results
% fprintf('\n--- OPTIMIZED PARAMETERS ---\n');
% 
% for k = 1:numel(result)
%     fprintf('%s = %.6f\n', ...
%         result(k).Name,result(k).Value);
% end
% 
% disp(info);
% 
% % Objective function
% 
% function vals = objectiveFunc(p,Simulator)
% 
%     % Update parameters
%     Simulator.Parameters = p;
% 
%     % Simulate
%     simOut = sim(Simulator);
%     logs = simOut.LoggedData.logsout;
% 
%     % Joint A position error
%     err = logs.get('KpA_err_pos_log').Values;
% 
%     % Objective function
%     K_err = 1e3;
% 
%     J = trapz(err.Time, ...
%         (K_err*err.Data).^2);
% 
%     vals.F = J;
% 
%     % Progress
%     fprintf('KpA = %.4f | KiA = %.4f | J = %.6f\n', ...
%         p(1).Value,p(2).Value,J);
% 
% end
