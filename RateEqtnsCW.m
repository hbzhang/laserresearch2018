function slopes = RateEqtnsCW(n,P,X,nCoeff,PCoeff1,PCoeff2,Ts,CavityLoss)
slopes = zeros(2,1); % set up slopes as a column vector.
slopes(1) = X*CavityLoss/Ts - nCoeff*n*P - n/Ts; % inversion equation.
slopes(2) = PCoeff1*(n - CavityLoss)*P + PCoeff2*n; % power equation.
