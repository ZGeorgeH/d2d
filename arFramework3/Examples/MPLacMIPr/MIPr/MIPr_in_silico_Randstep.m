%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Script to simulate the MIP model in response to a random stepwise in IPTG
% concentration specified in Run_MIP_in_silico_experiment
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear model exps sim inputs data;

inputs.pathd.results_folder = strcat('MIP_rep',datestr(now,'yyyy-mm-dd-HHMMSS'));
inputs.pathd.short_name     = 'MIP';

% Read the model into the model variable
%M3D_load_model;
MIP_with_scaling_factor;

% Compile the model
inputs.model = model;
clear model;
y0=M3D_steady_state2(inputs.model.par, 0);

inputs.pathd.runident       = 'initial_setup';

AMIGO_Prep(inputs);

% Fixed parts of the experiment
duration = 3000;     % Duration of the experiment in minutes
inputs.exps.n_exp=10;
step=150;
sample=5;
ITPGmax=10;


for iexp=1:inputs.exps.n_exp
    inputs.exps.n_obs{iexp}=1;                                     % Number of observables per experiment
    inputs.exps.obs_names{iexp}=char('Fluorescence');                 % Name of the observables
    inputs.exps.obs{iexp}=char('Fluorescence=Cit_AU');          % Observation function
    %inputs.exps.obs{iexp}=char('Fluorescence=Cit_fluo');          % Observation function
    inputs.exps.exp_y0{iexp}=y0;
    
    inputs.exps.t_f{iexp}=duration;                % Experiment duration
    
    inputs.exps.t_s{iexp}=0:sample:duration;
    inputs.exps.n_s{iexp}=length(inputs.exps.t_s{iexp});
    inputs.exps.u_interp{iexp} = 'step';
    inputs.exps.n_steps{iexp}=ceil(duration/step);
    inputs.exps.u{iexp}=ITPGmax*rand(1,inputs.exps.n_steps{iexp});
    inputs.exps.t_con{iexp} = 0:step:duration;
    
    inputs.exps.data_type = 'pseudo';
    inputs.exps.noise_type = 'homo_var';
    inputs.exps.std_dev{iexp} = 0.05;
end




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Mock an experiment
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%inputs.plotd.plotlevel='noplot';

inputs.pathd.runident       = strcat('sim-',int2str(i));

% SIMULATION
inputs.ivpsol.ivpsolver='cvodes';
inputs.ivpsol.senssolver='cvodes';
inputs.ivpsol.rtol=1.0D-7;
inputs.ivpsol.atol=1.0D-7;

results = AMIGO_SData(inputs);
data.input=inputs.exps.u;
data.sampleTimes=results.sim.tsim;
data.st=results.sim.tsim;
data.obsNoE=results.sim.obs;
data.expResult=results.sim.exp_data;
save('M3DrandomStep.mat','data');
%fid = fopen(resultFileName,'a');
%fprintf(fid, '%f %f %f\n',IPTGe,sim.sim.states{1,1}(end,10),sim.sim.states{1,1}(end,10)/492); % IPTG and Citrine (AU)
%fclose(fid);
