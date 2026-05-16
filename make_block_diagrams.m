function make_block_diagrams(cfg)


make_full_architecture(cfg);
make_lama_block(cfg);
make_proposed_block(cfg);
end

function make_full_architecture(cfg)
fig = figure('Color','w','Position',[100 100 1300 720]);
axis off;
title('Full MIMO-OFDM Receiver Architecture with Proposed Detector Placement', ...
    'FontSize',15,'FontWeight','bold');

blocks = {
    'Input Bits', 0.04, 0.78, 0.11, 0.08;
    'Channel\nEncoder', 0.19, 0.78, 0.12, 0.08;
    'BPSK/QPSK/QAM\nModulator', 0.35, 0.78, 0.14, 0.08;
    'OFDM Mapper', 0.54, 0.78, 0.12, 0.08;
    'IFFT', 0.71, 0.78, 0.08, 0.08;
    'Cyclic Prefix\nAddition', 0.84, 0.78, 0.12, 0.08;
    'MIMO Channel\n+ AWGN', 0.42, 0.58, 0.16, 0.08;
    'CP Removal', 0.06, 0.38, 0.11, 0.08;
    'FFT', 0.22, 0.38, 0.08, 0.08;
    'Channel\nEstimation', 0.35, 0.38, 0.13, 0.08;
    'MIMO Detector / Equalizer\nYOUR PROPOSED BLOCK', 0.54, 0.36, 0.21, 0.12;
    'LLR\nGenerator', 0.80, 0.38, 0.10, 0.08;
    'LDPC / Polar\nDecoder', 0.78, 0.18, 0.13, 0.08;
    'Recovered Bits', 0.78, 0.04, 0.13, 0.08;
};

draw_blocks(blocks);
arr = @(x1,y1,x2,y2) annotation('arrow',[x1 x2],[y1 y2],'LineWidth',1.4);
arr(0.15,0.82,0.19,0.82); arr(0.31,0.82,0.35,0.82); arr(0.49,0.82,0.54,0.82);
arr(0.66,0.82,0.71,0.82); arr(0.79,0.82,0.84,0.82);
arr(0.90,0.78,0.50,0.66);
arr(0.50,0.58,0.12,0.46); arr(0.17,0.42,0.22,0.42); arr(0.30,0.42,0.35,0.42);
arr(0.48,0.42,0.54,0.42); arr(0.75,0.42,0.80,0.42); arr(0.85,0.38,0.85,0.26); arr(0.85,0.18,0.85,0.12);

annotation('textbox',[0.50 0.28 0.30 0.05], 'String', ...
    'Detector input per subcarrier: y[k], H[k]. Output: detected symbols / soft LLRs.', ...
    'EdgeColor','none','FontSize',10,'FontWeight','bold','HorizontalAlignment','center');

saveas(fig, fullfile(cfg.resultsDir, '01_full_mimo_ofdm_architecture.png'));
end

function make_lama_block(cfg)
fig = figure('Color','w','Position',[100 100 950 650]);
axis off;
title('Enhanced LAMA Detector Block Based on Gram Matrix and Damping', ...
    'FontSize',14,'FontWeight','bold');

blocks = {
    'Input\nH, y, N0', 0.08, 0.76, 0.14, 0.09;
    'Preprocessing\nG = H^H H', 0.32, 0.76, 0.17, 0.09;
    'Matched Filter\ny^{MF} = H^H y', 0.58, 0.76, 0.18, 0.09;
    'Initialize\nz, rho, tau', 0.34, 0.56, 0.16, 0.09;
    'Posterior Mean\nE[s|z,rho]', 0.12, 0.36, 0.17, 0.09;
    'Posterior Variance\nVar[s|z,rho]', 0.40, 0.36, 0.18, 0.09;
    'Message Damping\ntheta_tau, theta_rho', 0.68, 0.36, 0.18, 0.09;
    'Signal Update\nz^{t+1}', 0.40, 0.16, 0.18, 0.09;
    'Output\nSymbols / LLRs', 0.68, 0.16, 0.18, 0.09;
};

draw_blocks(blocks);
arr = @(x1,y1,x2,y2) annotation('arrow',[x1 x2],[y1 y2],'LineWidth',1.4);
arr(0.22,0.80,0.32,0.80); arr(0.49,0.80,0.58,0.80);
arr(0.67,0.76,0.42,0.65);
arr(0.42,0.56,0.20,0.45); arr(0.42,0.56,0.49,0.45); arr(0.58,0.40,0.68,0.40);
arr(0.77,0.36,0.49,0.25); arr(0.49,0.16,0.49,0.36); arr(0.58,0.20,0.68,0.20);

annotation('textbox',[0.10 0.04 0.78 0.06], 'String', ...
    'Purpose: reduce per-iteration complexity using the Gram matrix and stabilize finite-dimensional channels using damping.', ...
    'EdgeColor','none','FontSize',10,'FontWeight','bold','HorizontalAlignment','center');

saveas(fig, fullfile(cfg.resultsDir, '02_enhanced_lama_detector_block.png'));
end

function make_proposed_block(cfg)
fig = figure('Color','w','Position',[100 100 1100 720]);
axis off;
title('Proposed Extension: LAMA-Guided Reduced QUBO/QAOA Detector', ...
    'FontSize',14,'FontWeight','bold');

blocks = {
    'Input per OFDM subcarrier\nH[k], y[k]', 0.05, 0.78, 0.17, 0.09;
    'Enhanced LAMA\nGram preprocessing', 0.30, 0.78, 0.18, 0.09;
    'Soft output + reliability\nr_i = |s_i|', 0.58, 0.78, 0.18, 0.09;
    'Select uncertain set U\nlowest reliability', 0.33, 0.58, 0.18, 0.09;
    'Reduced QUBO / Ising\nonly m = |U| variables', 0.58, 0.58, 0.20, 0.09;
    'Pauli-Z mapping\ns_i -> Z_i', 0.09, 0.36, 0.17, 0.09;
    'Cost Hamiltonian\nH_C = sum h_i Z_i + sum J_ij Z_iZ_j', 0.35, 0.34, 0.26, 0.11;
    'QAOA Circuit\nH + Cost + Mixer X + Measure', 0.70, 0.34, 0.22, 0.11;
    'Refined detected symbols\ns_hat', 0.43, 0.14, 0.20, 0.09;
};

draw_blocks(blocks);
arr = @(x1,y1,x2,y2) annotation('arrow',[x1 x2],[y1 y2],'LineWidth',1.4);
arr(0.22,0.82,0.30,0.82); arr(0.48,0.82,0.58,0.82);
arr(0.67,0.78,0.42,0.67); arr(0.51,0.62,0.58,0.62);
arr(0.58,0.58,0.18,0.45); arr(0.26,0.40,0.35,0.40);
arr(0.61,0.40,0.70,0.40); arr(0.80,0.34,0.54,0.23);

annotation('textbox',[0.09 0.04 0.82 0.06], 'String', ...
    'Key defense: this does not reinvent LAMA; it uses LAMA to reduce the quantum/QUBO problem size and refine only uncertain symbols.', ...
    'EdgeColor','none','FontSize',10,'FontWeight','bold','HorizontalAlignment','center');

saveas(fig, fullfile(cfg.resultsDir, '03_proposed_lama_guided_qubo_qaoa_block.png'));
end

function draw_blocks(blocks)
for i = 1:size(blocks,1)
    annotation('rectangle',[blocks{i,2}, blocks{i,3}, blocks{i,4}, blocks{i,5}], ...
        'LineWidth',1.5);
    annotation('textbox',[blocks{i,2}, blocks{i,3}, blocks{i,4}, blocks{i,5}], ...
        'String',blocks{i,1}, 'Interpreter','tex', ...
        'HorizontalAlignment','center', 'VerticalAlignment','middle', ...
        'FontSize',9, 'EdgeColor','none');
end
end
