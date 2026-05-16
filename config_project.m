function cfg = config_project()

cfg.projectTitle = 'LAMA-Guided QUBO/QAOA MIMO-OFDM Detector';

% MIMO dimensions for the main simulation.
cfg.Nt = 8;                 % transmit antennas / users
cfg.Nr = 32;                % base-station receive antennas
cfg.numSubcarriers = 8;     % frequency-domain OFDM subcarriers after FFT

% SNR sweep and Monte Carlo trials.
cfg.snrDbVec = 0:2:14;
cfg.numTrials = 120;        % increase to 500 or 1000 for paper-quality curves

% Detector settings.
cfg.lamaIterations = 10;    % original paper uses 10 iterations
cfg.thetaTau = 0.5;         % damping factor used in Enhanced-LAMA-style update
cfg.thetaRho = 0.5;

% Local refinement settings.
cfg.maxUncertain = 4;       % reduced QUBO/QAOA qubit count; keep <= 6 for speed
cfg.reliabilityThreshold = 0.85;

% QAOA settings. This is a simple MATLAB state-vector proof-of-concept.
cfg.runQAOA = true;
cfg.qaoaGridSize = 17;      % gamma/beta grid search; increase for better QAOA
cfg.qaoaGammaRange = [0, pi];
cfg.qaoaBetaRange = [0, pi/2];

% Full exact ML/QUBO benchmark is expensive: 2^Nt. Nt=8 is okay.
cfg.runFullExactML = true;
cfg.fullMLMaxNt = 10;

% Output folder.
cfg.resultsDir = fullfile(pwd, 'results');
if ~exist(cfg.resultsDir, 'dir')
    mkdir(cfg.resultsDir);
end

% Random seed for repeatable plots.
cfg.randomSeed = 7;
end
