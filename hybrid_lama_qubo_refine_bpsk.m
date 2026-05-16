function [sRefined, U] = hybrid_lama_qubo_refine_bpsk(H, y, sLAMA, reliability, cfg)

% Main idea:
%   1) Enhanced-LAMA-style detector gives sLAMA and reliability.
%   2) Keep confident symbols fixed.
%   3) Build a reduced QUBO/Ising problem only for uncertain symbols.
%   4) Solve the reduced QUBO exactly by enumeration.

Nt = size(H,2);
J = real(H' * H);
b = -2 * real(H' * y);

% Select only symbols below the reliability threshold.
candidates = find(reliability < cfg.reliabilityThreshold);

if isempty(candidates)
    U = [];
    sRefined = sLAMA;
    return;
end

% Among the candidates, keep only the least reliable symbols.
[~, localOrder] = sort(reliability(candidates), 'ascend');
U = candidates(localOrder(1:min(cfg.maxUncertain, numel(candidates))));
U = U(:).';

m = numel(U);
SU = all_bpsk_vectors(m);

bestCost = inf;
sBest = sLAMA;

for row = 1:size(SU,1)
    sTry = sLAMA;
    sTry(U) = SU(row,:).';
    cost = sTry.' * J * sTry + b.' * sTry;
    if cost < bestCost
        bestCost = cost;
        sBest = sTry;
    end
end

% The original LAMA vector is in the search space, so this should not
% increase the ML/QUBO cost.
sRefined = sBest;
end
