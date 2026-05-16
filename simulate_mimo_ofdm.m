function results = simulate_mimo_ofdm(cfg)

% Detectors compared:
%   1) MMSE
%   2) Enhanced-LAMA-style AMP detector
%   3) Full exact ML/QUBO benchmark, if Nt is small enough
%   4) Proposed LAMA-guided reduced QUBO refinement
%   5) Proposed LAMA-guided reduced QAOA refinement

Nt = cfg.Nt;
Nr = cfg.Nr;
K = cfg.numSubcarriers;
SNRs = cfg.snrDbVec;

numMethods = 5;
methodNames = {'MMSE', 'Enhanced LAMA style', 'Full exact ML/QUBO', ...
               'Proposed LAMA-guided QUBO', 'Proposed LAMA-guided QAOA'};
err = zeros(numMethods, numel(SNRs));
tot = zeros(numMethods, numel(SNRs));
avgUncertain = zeros(1, numel(SNRs));

for si = 1:numel(SNRs)
    snrDb = SNRs(si);
    fprintf('  SNR = %4.1f dB ', snrDb);
    uncertainCounter = 0;
    uncertainCases = 0;

    for tr = 1:cfg.numTrials
        for k = 1:K
            % BPSK symbols: +1 or -1 for each user/antenna.
            sTrue = 2*randi([0 1], Nt, 1) - 1;

            % Rayleigh fading channel normalized similarly to large-scale MIMO papers.
            H = (randn(Nr,Nt) + 1i*randn(Nr,Nt)) / sqrt(2*Nr);

            clean = H * sTrue;
            sigPow = mean(abs(clean).^2);
            noiseVar = sigPow / (10^(snrDb/10));
            w = sqrt(noiseVar/2) * (randn(Nr,1) + 1i*randn(Nr,1));
            y = clean + w;

            % 1) MMSE baseline.
            sMMSE = mmse_detect_bpsk(H, y, noiseVar);

            % 2) Enhanced-LAMA-style detector.
            [sLAMA, softLAMA, relLAMA] = enhanced_lama_bpsk(H, y, noiseVar, cfg);

            % 3) Full exact ML/QUBO benchmark.
            if cfg.runFullExactML && Nt <= cfg.fullMLMaxNt
                sML = exact_ml_qubo_bpsk(H, y);
            else
                sML = nan(Nt,1);
            end

            % 4) Proposed: use LAMA reliability to reduce QUBO dimension.
            [sHybridQUBO, U] = hybrid_lama_qubo_refine_bpsk(H, y, sLAMA, relLAMA, cfg);
            uncertainCounter = uncertainCounter + numel(U);
            uncertainCases = uncertainCases + 1;

            % 5) Proposed: same reduced problem solved by QAOA state-vector simulation.
            if cfg.runQAOA
                [sHybridQAOA, ~] = hybrid_lama_qaoa_refine_bpsk(H, y, sLAMA, relLAMA, cfg);
            else
                sHybridQAOA = nan(Nt,1);
            end

            estimates = {sMMSE, sLAMA, sML, sHybridQUBO, sHybridQAOA};
            for mi = 1:numMethods
                est = estimates{mi};
                if any(isnan(est))
                    continue;
                end
                err(mi,si) = err(mi,si) + sum(est ~= sTrue);
                tot(mi,si) = tot(mi,si) + Nt;
            end
        end
    end

    avgUncertain(si) = uncertainCounter / max(1, uncertainCases);
    serNow = err(:,si) ./ max(1, tot(:,si));
    fprintf('| SER LAMA %.3g | Hybrid-QUBO %.3g | Hybrid-QAOA %.3g\n', ...
        serNow(2), serNow(4), serNow(5));
end

SER = err ./ max(1, tot);

results.SER = SER;
results.err = err;
results.tot = tot;
results.snrDbVec = SNRs;
results.methodNames = methodNames;
results.avgUncertain = avgUncertain;
end
