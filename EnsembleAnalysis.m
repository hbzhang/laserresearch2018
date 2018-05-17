function SpikeJitter = EnsembleAnalysis(PEnsemble,dt,t)
% Find the timing jitter for a user specified number of relaxation
% oscillation intensity spikes.  Use a peak trapping algorithm designed to 
% work with noisy data.  First find the indices bracketing each spike and 
% then find the actual maximum intensity of the spike and the index at which
% it occurs. Convert these indices to times in microseconds.
%
% Output:  SpikeJitter = array of standard deviations of spike peak times.
%
% Inputs:  PEnsemble = ensemble of relaxation oscillation waveforms.
%          dt = time step between adjacent points of waveforms in MICROSECONDS.
%          t = time array for the waveforms.
%

% Initialize variables for peak trapping algorithm and then find peaks.
NumSpikes = 3; % number of intensity spikes to find maximum and time of maximum.
MaxHeight = max(PEnsemble(:,1)); % find absolute maximum of first waveform for setting thresholds.
Thresh1 = 0.50; % leading edge threshold should be LARGER to successfully trap noisy peaks.
Thresh2 = 0.30; % two thresholds should differ significantly to avoid being fooled by smaller noise spikes.
Peaks=[];
Times=[];
N = size(PEnsemble,2); % number of waveforms in ensemble.
LowBound(NumSpikes,N)=0;
UpBound(NumSpikes,N)=0;
for i=1:N % cycle through all the waveforms.
	k=1; % initialize array index for ith waveform.
	for j=1:NumSpikes % search for specified number of intensity spikes.
		while(PEnsemble(k,i) < Thresh1*MaxHeight) % find lower bound where intensity exceeds first threshold.
			k=k+1;
		end
		LowBound(j,i)=k-1; % lower bound for jth intensity spike of ith waveform.
		while(PEnsemble(k,i) > Thresh2*MaxHeight) % find upper bound where intensity drops below second threshold
			k=k+1;
		end
		UpBound(j,i)=k-1; % upper bound for jth intensity spike of ith waveform.
        %
        % note that index associated with a peak is relative to beginning of
        % the searched section of the waveform in question.  This must be
        % corrected to get the absolute index of the peak.
        %
		[Peaks(j,i),Times(j,i)]=max(PEnsemble(LowBound(j,i):UpBound(j,i),i));
		Times(j,i)=(Times(j,i)+LowBound(j,i)-1)*dt; % obtain absolute index and convert to time in microseconds
	end
end

% Find timing jitter of intensity spikes in microseconds.  Times for each
% spike are arranged in rows so averaging should be along rows.
SpikeJitter = std(Times,0,2);

% Plot ensemble of waveforms.
h1 = figure('Name','Waveform Ensemble'); % Create first graphics window.
figure(h1),plot(t,PEnsemble)
xlabel('t (\mus)'); ylabel('Power (Watts)');
title(['Relaxation Oscillation Ensemble, N = ',num2str(N),' waveforms.']);