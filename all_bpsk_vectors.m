function S = all_bpsk_vectors(N)
%ALL_BPSK_VECTORS Return all BPSK vectors as rows, values in {-1,+1}.
M = 2^N;
S = ones(M,N);
for idx = 0:M-1
    bits = dec2bin(idx, N) - '0';
    % bit 0 -> +1, bit 1 -> -1, matching Pauli-Z eigenvalue convention.
    S(idx+1,:) = 1 - 2*bits;
end
end
