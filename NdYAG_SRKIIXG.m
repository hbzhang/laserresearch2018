function [P,t] = NdYAG_SRKIIXG(RNX,RNG,dt,tmax)
% This code solves the CW rate equations for a single-mode Nd:YAG laser
% with additive white pump noise using a stochastic RKII algorithm developed 
% by R. Honeycutt in a 1992 PRA article. The cavity loss noise is specified
% so that random variations in its trial-to-trial value can be incorporated
% in addition to the distributed pump noise.
%
% Outputs:  P = Array of laser power in Watts.
%           t = time in microseconds.
%
% Inputs:   RNX = relative noise for the pump rate.
%           RNG = relative noise for the loss rate.
%           dt = step size for integration, in MICROSECONDS.
%           tmax = duration of integration, in MICROSECONDS.

% set up time array for laser power.
t = 0:dt:tmax; % time array for laser power in microseconds.
Num_elements = length(t);

% Set values of fundamental and cavity parameters.
XSectn = 2.8e-19; % Stimulated emission cross-section in cm^2.
Aeff = 0.000699; % Cross-sectional area of beam in cm^2.
h = 6.63e-34; % Plank's constant in J-s.
f = 282e12; % Frequency of light in Hz.
Le = 11.25; % optical length of cavity in cm.
c = 3e10; % speed of light in cm/s.
B = XSectn*c/(Aeff*Le); % stimulated emission rate coefficient in s-1.
Ts = 230e-6; % upper state lifetime in s.
R2 = 0.95; % mirror power reflectivity.
MirrorLoss = -log(R2)/2; % Single pass loss due to output coupling.
Toc = Le/(MirrorLoss*c); % output coupling lifetime in s.
X_Avg = 3.0; % mean normalized pump rate.
CavityLoss = 0.06; % mean value of net single-pass logarithmic losses.
nCoeff = Toc*B/(h*f); % coefficient for inversion rate equation.
PCoeff1 = c/Le;% set coefficients for power rate equation.
PCoeff2 = c*h*f/(Le*Toc);

% Incorporate trial-to-trial fluctuations in loss rate.
CavityLoss = CavityLoss*(1 + RNG*randn);

% Preallocate inversion and output power arrays, initial values are zero.
n = zeros(1,Num_elements);
P = zeros(1,Num_elements); 

% Initialize quantities needed for additive Gaussian white pump noise.
dt = dt*1e-6; % convert step size to seconds for SRKII integration.
Q = randn(1,Num_elements); % generate zero-mean, unit standard deviation random numbers.
delX = X_Avg*RNX*sqrt(dt)*Q;

% Enter loop to implement stochastic Runge-Kutta algorithm.
for i = 2:Num_elements	% The initial values are known so start at i=2.
    Slope1 = RateEqtnsCW(n(i-1),P(i-1),X_Avg,nCoeff,PCoeff1,PCoeff2,Ts,CavityLoss);
    F1 = Slope1(1);
    G1 = Slope1(2);
    Slope2 = RateEqtnsCW(n(i-1)+dt*F1+CavityLoss*delX(i-1)/Ts,P(i-1)+dt*G1,X_Avg,nCoeff,PCoeff1,PCoeff2,Ts,CavityLoss);
    F2 = Slope2(1);
    G2 = Slope2(2);
    n(i) = n(i-1) + 0.5*dt*(F1 + F2) + CavityLoss*delX(i-1)/Ts;
    P(i) = P(i-1) + 0.5*dt*(G1 + G2);
end