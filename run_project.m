clc; clear; close all;

cfg = config_project();
rng(cfg.randomSeed);

fprintf('\n==============================================\n');
fprintf('%s\n', cfg.projectTitle);
fprintf('==============================================\n');
fprintf('Nt = %d, Nr = %d, OFDM subcarriers = %d\n', cfg.Nt, cfg.Nr, cfg.numSubcarriers);
fprintf('Trials/SNR = %d, SNR range = %s dB\n', cfg.numTrials, mat2str(cfg.snrDbVec));
fprintf('Reduced QUBO/QAOA uncertain symbols = %d\n', cfg.maxUncertain);

fprintf('\n[1/5] Creating block diagrams...\n');
make_block_diagrams(cfg);

fprintf('[2/5] Creating Pauli/QAOA conceptual diagram...\n');
demo_pauli_gates(cfg);

fprintf('[3/5] Running MIMO-OFDM SER simulation...\n');
results = simulate_mimo_ofdm(cfg);

fprintf('[4/5] Plotting SER results...\n');
plot_ser_results(results, cfg);

fprintf('[5/5] Saving results...\n');
save(fullfile(cfg.resultsDir, 'simulation_results.mat'), 'results', 'cfg');

fprintf('\nDone. Check the results folder:\n%s\n', cfg.resultsDir);
fprintf('\nMain report claim to use:\n');
fprintf(['Enhanced LAMA is retained as the classical base detector. ', ...
         'The proposed extension uses LAMA reliability to reduce the ML/QUBO search space, ', ...
         'then refines only uncertain symbols using exact QUBO or QAOA.\n']);
