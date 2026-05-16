function plot_ser_results(results, cfg)


fig = figure('Color','w','Position',[120 120 950 650]);
hold on; grid on;
set(gca, 'YScale', 'log');

markers = {'o-','s-','^-','d-','x-'};
for mi = 1:numel(results.methodNames)
    serPlot = results.SER(mi,:);
    floorSer = 1 ./ max(1, results.tot(mi,:));
    zeroIdx = serPlot == 0;
    serPlot(zeroIdx) = floorSer(zeroIdx);
    semilogy(results.snrDbVec, serPlot, markers{mi}, ...
        'LineWidth', 1.8, 'MarkerSize', 7);
end

xlabel('Average SNR (dB)', 'FontSize', 12, 'FontWeight','bold');
ylabel('Symbol Error Rate (SER)', 'FontSize', 12, 'FontWeight','bold');
title(sprintf('SER Comparison: Nt=%d, Nr=%d, OFDM subcarriers=%d', ...
    cfg.Nt, cfg.Nr, cfg.numSubcarriers), 'FontSize', 13, 'FontWeight','bold');
legend(results.methodNames, 'Location', 'southwest');
ylim([1e-5 1]);

noteText = sprintf('Zero-error points are plotted at Monte-Carlo floor 1/N. Trials=%d.', cfg.numTrials);
text(results.snrDbVec(1), 1.8e-5, noteText, 'FontSize', 8);

saveas(fig, fullfile(cfg.resultsDir, '05_SER_vs_SNR_comparison.png'));

fig2 = figure('Color','w','Position',[120 120 800 450]);
plot(results.snrDbVec, results.avgUncertain, 'o-', 'LineWidth', 1.8, 'MarkerSize', 7);
grid on;
xlabel('Average SNR (dB)', 'FontSize', 12, 'FontWeight','bold');
ylabel('Average uncertain symbols refined', 'FontSize', 12, 'FontWeight','bold');
title('Adaptive Reduced QUBO/QAOA Size Selected by LAMA Reliability', 'FontSize', 13, 'FontWeight','bold');
ylim([0 cfg.maxUncertain + 0.5]);
saveas(fig2, fullfile(cfg.resultsDir, '06_average_reduced_qubo_size.png'));

fig3 = figure('Color','w','Position',[120 120 800 450]);
fullStates = 2^cfg.Nt;
reducedStates = 2 .^ results.avgUncertain;
reductionPct = 100 * (1 - reducedStates / fullStates);
plot(results.snrDbVec, reductionPct, 'o-', 'LineWidth', 1.8, 'MarkerSize', 7);
grid on;
xlabel('Average SNR (dB)', 'FontSize', 12, 'FontWeight','bold');
ylabel('Average search-space reduction (%)', 'FontSize', 12, 'FontWeight','bold');
title('Reduced QUBO Search-Space Reduction Compared with Full ML/QUBO', 'FontSize', 13, 'FontWeight','bold');
ylim([0 100]);
saveas(fig3, fullfile(cfg.resultsDir, '07_search_space_reduction.png'));
end
