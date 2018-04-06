close all; clear all; clc;
% initialize full model
arInit;
arLoadModel('MIPr');
 
%the error model is used and estimated together with the dynamics
ar.config.fiterrors = 1;
 
arCompileAll;
 
%set up the initial condition to the steady state of the network.
model = 1;
sourceCondition = 1;
targetCondition = [1];
arSteadyState(model, sourceCondition, targetCondition, -1e7);
 
%print out the values of the parameters
arPrint;
 
 
%plot the states and observables
arPlot;
 
 
%identifiability test
arIdentifiablityTest;
return;





% initialize model
arInit
arLoadModel('TwoStepSynthesisWithGlu');
arLoadData('20131208_indC_native_sfp_rep4_siData_1', 1,'csv');
arLoadData('20131208_synT1_sfp_siData_1', 1,'csv');
arLoadData('20131208_synT3_sfp_siData_1', 1,'csv');
arLoadData('20131208_synT5_sfp_siData_1', 1,'csv');
arCompileAll;

% set parameters for parameter estimation and optimization
ar.lb(:)   = -5;
ar.ub(:)   = 5;
ar.config.atol = 1e-8;
ar.config.rtol = 1e-8;
ar.config.optim.TolFun = 1e-8;
ar.config.optim.TolX = 1e-8;
ar.config.maxsteps = 1e5;

% set initial Bacteria density 
arSetPars('init_Bac', 0.2, 1, 1, -20, 5);
%arSetPars('tau', 0, 1, 0, 0, 2000);
%arSetPars('ksyn', -10, 1, 1, 0, 1);
%arSetPars('init_Glu', 0.9, 1, 0, 0.5, 100);
%arSetPars('init_cGlu', -0.15, 1, 0, -1, 1);
%arSetPars('init_Ind', -0.15, 1, 0, -1, 1); 

% load parameters from best fit of LHS(1000)
arLoadPars('20150603T111456_Post1000LHSFit')

% plot data sets shown in publication
ar.model.qPlotYs([1, 2, 8, 14]) = 1; 

arPlot
