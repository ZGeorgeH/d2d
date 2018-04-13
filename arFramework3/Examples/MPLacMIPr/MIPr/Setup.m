close all; clear all; clc;
% initialize full model
arInit;
arLoadModel('MIPr');
arLoadData('MIPrExp1');

%the error model is used and estimated together with the dynamics
ar.config.fiterrors = 1;
arCompileAll;

%interpolateLinear

%set up the initial condition to the steady state of the network.
model = 1;
sourceCondition = 1;
targetCondition = [1];
arSteadyState(model, sourceCondition, targetCondition, -1e7);

% IPTG[next]=1*IPTG+500
%arAddEvent(1, 1, 300,'Cit_fluo',1,500);

% Cit_fluo[next]=1*Cit_fluo+500
%arAddEvent(1, 1, 300,'Cit_fluo',1,500);

%plot the states and observables
arPlot;

%print out the values of the parameters
arPrint;


%identifiability test
arIdentifiablityTest(false,0.5,100,true);
return;