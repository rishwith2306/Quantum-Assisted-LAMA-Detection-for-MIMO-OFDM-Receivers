function psiOut = apply_single_qubit_gate(psi, U, q, nQubits)
%APPLY_SINGLE_QUBIT_GATE Apply a 2x2 gate U to qubit q.
% Qubit indexing: q=1 is the left-most bit in dec2bin ordering.
% This loop implementation is slower than tensor methods but is very clear
% and robust for the small reduced-QUBO circuits used here.

dim = 2^nQubits;
psiOut = psi;
bitPos = nQubits - q + 1;  

for basis = 0:dim-1
    if bitget(basis, bitPos) == 0
        basis0 = basis;
        basis1 = bitset(basis, bitPos, 1);
        idx0 = basis0 + 1;
        idx1 = basis1 + 1;
        a0 = psi(idx0);
        a1 = psi(idx1);
        psiOut(idx0) = U(1,1)*a0 + U(1,2)*a1;
        psiOut(idx1) = U(2,1)*a0 + U(2,2)*a1;
    end
end
end
