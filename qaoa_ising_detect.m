function sBest = qaoa_ising_detect(J, h, cfg)
%QAOA_ISING_DETECT p=1 QAOA state-vector simulator for Ising/BPSK detection.
%
% Cost minimized:
%       C(s) = s' J s + h' s,  s_i in {-1,+1}
%
% Pauli mapping:
%       s_i -> Z_i eigenvalue
%       cost Hamiltonian H_C = sum_i h_i Z_i + sum_ij J_ij Z_i Z_j
%
% Mixer:
%       H_M = sum_i X_i
%
% v2 fix:
%       Costs are normalized before phase encoding. This does not change the
%       minimizer, but it avoids phase wrapping that can make shallow QAOA
%       look artificially bad.

m = numel(h);
if m == 0
    sBest = [];
    return;
end

S = all_bpsk_vectors(m);
numStates = size(S,1);
costs = zeros(numStates,1);
for r = 1:numStates
    s = S(r,:).';
    costs(r) = s.' * J * s + h.' * s;
end

% Normalize energy for stable QAOA phases.
energyScale = max(1, max(abs(costs)));
costsScaled = costs / energyScale;

psi0 = ones(numStates,1) / sqrt(numStates);  % Hadamard on all qubits

gammas = linspace(cfg.qaoaGammaRange(1), cfg.qaoaGammaRange(2), cfg.qaoaGridSize);
betas  = linspace(cfg.qaoaBetaRange(1),  cfg.qaoaBetaRange(2),  cfg.qaoaGridSize);

bestExpectation = inf;
bestPsi = psi0;

for gi = 1:numel(gammas)
    gamma = gammas(gi);
    costPhase = exp(-1i * gamma * costsScaled);
    for bi = 1:numel(betas)
        beta = betas(bi);
        psi = costPhase .* psi0;
        psi = apply_rx_all(psi, beta, m);
        probs = abs(psi).^2;
        expectation = real(sum(probs .* costsScaled));
        if expectation < bestExpectation
            bestExpectation = expectation;
            bestPsi = psi;
        end
    end
end

[~, idx] = max(abs(bestPsi).^2);
sBest = S(idx,:).';
end
