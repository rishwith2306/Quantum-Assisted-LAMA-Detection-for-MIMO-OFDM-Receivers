function [sRefined, U] = hybrid_lama_qaoa_refine_bpsk(H, y, sLAMA, reliability, cfg)


Nt = size(H,2);
J = real(H' * H);
b = -2 * real(H' * y);

candidates = find(reliability < cfg.reliabilityThreshold);
if isempty(candidates)
    U = [];
    sRefined = sLAMA;
    return;
end

[~, localOrder] = sort(reliability(candidates), 'ascend');
U = candidates(localOrder(1:min(cfg.maxUncertain, numel(candidates))));
U = U(:).';

C = setdiff(1:Nt, U);
sC = sLAMA(C);

% Reduced Ising cost over uncertain symbols:
% C(sU) = sU' J_UU sU + hU' sU + const
% hU = bU + 2 J_UC sC
JUU = J(U,U);
hU = b(U);
if ~isempty(C)
    hU = hU + 2 * J(U,C) * sC;
end

sU = qaoa_ising_detect(JUU, hU, cfg);

sCandidate = sLAMA;
sCandidate(U) = sU;

% Safety check: QAOA is approximate. Do not accept a refinement that makes
% the actual classical ML/QUBO objective worse.
costBefore = sLAMA.' * J * sLAMA + b.' * sLAMA;
costAfter  = sCandidate.' * J * sCandidate + b.' * sCandidate;

if costAfter <= costBefore
    sRefined = sCandidate;
else
    sRefined = sLAMA;
end
end
