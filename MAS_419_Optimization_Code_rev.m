
clear;
close all;

% Model name
mdl = 'Simscape_model_optimization';

% Open model
load_system(mdl);

% Avoid compilation during optimization
set_param(mdl,'FastRestart','on');

% Avoid animation during optimization
set_param(mdl,'SimMechanicsOpenEditorOnUpdate','off');
set_param(mdl,'SimulationMode','normal');

% Get tunable parameters
p = sdo.getParameterFromModel(mdl, ...
    {'KpA_pos','KiA_pos','KdA_pos','KpB1_pos', 'KiB1_pos', 'KdB1_pos', 'KpB2_pos', 'KiB2_pos', 'KdB2_pos','KpG_pos', 'KiG_pos','KdG_pos', 'KpH_pos', 'KiH_pos', 'KdH_pos', 'KpI_pos', 'KiI_pos', 'KdI_pos'})
%,'KpB1_pos', 'KiB1_pos', 'KdB1_pos', 'KpB2_pos', 'KiB2_pos', 'KdB2_pos','KpG_pos', 'KiG_pos','KdG_pos', 'KpH_pos', 'KiH_pos', 'KdH_pos', 'KpI_pos', 'KiI_pos', 'KdI_pos'}
%%%%%%%%%%%%%
% First actuator
%%%%%%%%%%%%%

% Kp limits
i = 1;
p(i).Value = 100;
p(i).Minimum = 1;
p(i).Maximum = 10000000;

% Ki limits
i = i + 1;
p(i).Value = 10;
p(i).Minimum = 1;
p(i).Maximum = 10000000;

% Kd limits
i = i + 1;
p(i).Value = 100;
p(i).Minimum = 1;
p(i).Maximum = 10000000;

% Do optimization
opts = sdo.OptimizeOptions;
result = sdo.optimize(@(x)objectiveFunc(x,mdl),p,opts);

% Display solution
disp('Optimal values:')
for k = 1:length(result)
    fprintf('%s = %g\n',result(k).Name,result(k).Value);
end

% Return to normal
set_param(mdl,'FastRestart','off');
set_param(mdl,'SimMechanicsOpenEditorOnUpdate','on');

% Apply optimized parameters
sdo.setValueInModel(mdl,result);

%%%%%%%%%%%%%
% Optimization function
%%%%%%%%%%%%%

function vals = objectiveFunc(p,mdl)

sdo.setValueInModel(mdl,p);

simOut = sim(mdl);

K_err = 1e3;

err_1 = simOut.logsout.get('KpA_err_pos_log').Values;
err_2 = simOut.logsout.get('KpB1_err_pos_log').Values;
err_3 = simOut.logsout.get('KpB2_err_pos_log').Values;
err_4 = simOut.logsout.get('KpG_err_pos_log').Values;
err_5 = simOut.logsout.get('KpH_err_pos_log').Values;
err_6 = simOut.logsout.get('KpI_err_pos_log').Values;



vals.F = trapz(err_1.Time, ...
        (K_err*err_1.Data).^2 + (K_err*err_2.Data).^2 + ...
        (K_err*err_3.Data).^2 + (K_err*err_4.Data).^2 + (K_err*err_5.Data).^2 + (K_err*err_6.Data).^2);
     
%(K_err*err_2.Data).^2 + ...
%(K_err*err_3.Data).^2 + (K_err*err_4.Data).^2 + (K_err*err_5.Data).^2 + (K_err*err_6.Data).^2);
end
