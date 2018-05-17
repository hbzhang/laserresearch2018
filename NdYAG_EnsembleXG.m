%
% Program to run multiple iterations of NdYAG relaxation oscillation function
% with distributed pump noise and lumped cavity loss noise.  Uses MATLAB'S 
% parallel computing capabilities.
%

% Set parameter values for integration.
% RNX = input('Enter the relative noise in the pump rate:  ');
% RNG = input('Enter the relative noise for the cavity losses:  ');
% dt = 0.005; % integration time step in microseconds.
% tmax = input('Enter maximum integration time in MICROSECONDS:  ');
% t = 0:dt:tmax;
% N = input('Enter the number of iterations (realizations):  ');
% 

RNX = 5e-5;
RNG = 0.01;
tmax = 150;
N = 20;
dt = 0.005;
t = 0:dt:tmax;


% Run parfor loop and time it.
tic
parfor i=1:N
    P=NdYAG_SRKIIXG(RNX,RNG,dt,tmax);
    PEnsemble(:,i)=P;
end
toc

% Analyze and plot data.
Jitter = EnsembleAnalysis(PEnsemble,dt,t);