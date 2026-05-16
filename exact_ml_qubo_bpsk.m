function sBest = exact_ml_qubo_bpsk(H, y)

Nt = size(H,2);
S = all_bpsk_vectors(Nt);       % rows are candidate vectors
YS = H * S.';                   % Nr x 2^Nt
res = YS - y;
metric = sum(abs(res).^2, 1);
[~, idx] = min(metric);
sBest = S(idx,:).';
end
