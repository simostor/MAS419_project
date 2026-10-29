
function J = MAS_419_Optimization_Code(x)

%% Parameters to optimize
KpA_pos  = x(1);
KiA_pos  = x(2);
KpB1_pos = x(3);
KiB1_pos = x(4);

%% Simulink model
model = 'Simscape_model_optimization';

simIn = Simulink.SimulationInput(model);

simIn = simIn.setVariable('KpA_pos',KpA_pos, ...
    'Workspace',model);

simIn = simIn.setVariable('KiA_pos',KiA_pos, ...
    'Workspace',model);

simIn = simIn.setVariable('KpB1_pos',KpB1_pos, ...
    'Workspace',model);

simIn = simIn.setVariable('KiB1_pos',KiB1_pos, ...
    'Workspace',model);
simIn = simIn.setModelParameter('StopTime','8');

%% Run simulation
simOut = sim(simIn);

%% Logged position errors
logs = simOut.logsout;

names = {
    'KpA_err_pos_log'
    'KpB1_err_pos_log'
    'KpB2_err_pos_log'
    'KpG_err_pos_log'
    'KpH_err_pos_log'
    'KpI_err_pos_log'
    };

%% Objective function
J = 0;

for i = 1:length(names)

    signal = logs.get(names{i}).Values;

    t = signal.Time;
    e = signal.Data;

    J = J + trapz(t,e.^2);

end

end
