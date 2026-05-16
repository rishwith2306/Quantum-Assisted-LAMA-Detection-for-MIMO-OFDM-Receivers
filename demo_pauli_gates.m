function demo_pauli_gates(cfg)
%DEMO_PAULI_GATES Save Pauli matrices and a conceptual QAOA circuit diagram.

I = [1 0; 0 1];
X = [0 1; 1 0];
Y = [0 -1i; 1i 0];
Z = [1 0; 0 -1];

fid = fopen(fullfile(cfg.resultsDir, 'pauli_matrices.txt'), 'w');
fprintf(fid, 'Pauli matrices used in the proposed detector\n\n');
fprintf(fid, 'I = [1 0; 0 1]\n');
fprintf(fid, 'X = [0 1; 1 0]  -> mixer gate in QAOA\n');
fprintf(fid, 'Y = [0 -i; i 0] -> not required for BPSK Ising cost, useful in general quantum operations\n');
fprintf(fid, 'Z = [1 0; 0 -1] -> maps BPSK symbol +1/-1 to qubit eigenvalues\n\n');
fprintf(fid, 'Cost Hamiltonian for reduced uncertain set U:\n');
fprintf(fid, 'H_C = sum_i h_i Z_i + sum_{i<j} J_ij Z_i Z_j\n\n');
fprintf(fid, 'Mixer Hamiltonian:\n');
fprintf(fid, 'H_M = sum_i X_i\n');
fclose(fid);

fig = figure('Color','w','Position',[100 100 1050 560]);
axis off;
title('Conceptual QAOA Circuit for Reduced BPSK MIMO Detection', ...
    'FontSize',14,'FontWeight','bold');

n = 4;
y0 = linspace(0.75, 0.30, n);
for q = 1:n
    annotation('line',[0.06 0.94],[y0(q) y0(q)],'LineWidth',1.2);
    annotation('textbox',[0.01 y0(q)-0.025 0.05 0.05], 'String',sprintf('q_%d',q), ...
        'EdgeColor','none','HorizontalAlignment','center','FontSize',10);
end

xBlocks = [0.12 0.28 0.50 0.70 0.86];
labels = {'H', 'Cost U_C(\gamma)\nZ_i, Z_iZ_j', 'Mixer U_M(\beta)\nX rotations', 'Measure', 's detected'};
widths = [0.06 0.16 0.15 0.10 0.10];
for bi = 1:numel(xBlocks)
    annotation('rectangle',[xBlocks(bi) 0.22 widths(bi) 0.60],'LineWidth',1.5);
    annotation('textbox',[xBlocks(bi) 0.22 widths(bi) 0.60],'String',labels{bi}, ...
        'Interpreter','tex','EdgeColor','none','HorizontalAlignment','center', ...
        'VerticalAlignment','middle','FontSize',10,'FontWeight','bold');
end

annotation('textbox',[0.08 0.06 0.84 0.08], 'String', ...
    'QAOA loop: classical optimizer changes gamma and beta to minimize expected MIMO detection cost.', ...
    'EdgeColor','none','HorizontalAlignment','center','FontSize',11,'FontWeight','bold');

saveas(fig, fullfile(cfg.resultsDir, '04_qaoa_conceptual_circuit.png'));
end
