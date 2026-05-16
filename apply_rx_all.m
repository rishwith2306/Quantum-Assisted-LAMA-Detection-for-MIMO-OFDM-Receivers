function psi = apply_rx_all(psi, beta, nQubits)

Rx = [cos(beta), -1i*sin(beta); -1i*sin(beta), cos(beta)];

for q = 1:nQubits
    psi = apply_single_qubit_gate(psi, Rx, q, nQubits);
end
end
