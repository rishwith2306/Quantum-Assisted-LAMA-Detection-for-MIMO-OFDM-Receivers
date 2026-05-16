# Equations for the Report

## 1. MIMO-OFDM subcarrier model

After cyclic-prefix removal and FFT, every OFDM subcarrier becomes a narrowband MIMO problem:

\[
\mathbf{y}[k] = \mathbf{H}[k]\mathbf{s}[k] + \mathbf{w}[k]
\]

where \(k\) is the subcarrier index, \(\mathbf{H}[k]\) is the channel matrix, \(\mathbf{s}[k]\) is the transmitted symbol vector, and \(\mathbf{w}[k]\) is AWGN.

## 2. Enhanced LAMA preprocessing

\[
\mathbf{G}[k] = \mathbf{H}[k]^H\mathbf{H}[k]
\]

\[
\mathbf{y}^{MF}[k] = \mathbf{H}[k]^H\mathbf{y}[k]
\]

This is the same preprocessing idea used by Enhanced LAMA to reduce repeated per-iteration operations.

## 3. Classical ML detection objective

\[
\hat{\mathbf{s}} = \arg\min_{\mathbf{s}\in\mathcal{A}^{N_t}} \|\mathbf{y}-\mathbf{H}\mathbf{s}\|^2
\]

For BPSK, \(s_i\in\{+1,-1\}\). Expanding and dropping the constant \(\mathbf{y}^H\mathbf{y}\):

\[
C(\mathbf{s}) = \mathbf{s}^T\Re\{\mathbf{G}\}\mathbf{s} - 2\Re\{\mathbf{y}^{MF}\}^T\mathbf{s}
\]

Let:

\[
\mathbf{J}=\Re\{\mathbf{G}\}, \quad \mathbf{b}=-2\Re\{\mathbf{y}^{MF}\}
\]

Then:

\[
C(\mathbf{s})=\mathbf{s}^T\mathbf{J}\mathbf{s}+\mathbf{b}^T\mathbf{s}
\]

## 4. LAMA-guided reduced QUBO refinement

Enhanced LAMA gives soft symbol estimates \(\tilde{s}_i\). Define reliability:

\[
r_i = |\tilde{s}_i|
\]

Select the uncertain set:

\[
\mathcal{U}=\{i: r_i \text{ is among the lowest values}\}
\]

Keep confident symbols fixed in \(\mathcal{C}\). Partition the cost:

\[
C_{red}(\mathbf{s}_{\mathcal{U}})=
\mathbf{s}_{\mathcal{U}}^T\mathbf{J}_{\mathcal{U}\mathcal{U}}\mathbf{s}_{\mathcal{U}}
+
\mathbf{h}_{\mathcal{U}}^T\mathbf{s}_{\mathcal{U}}
+\text{constant}
\]

where:

\[
\mathbf{h}_{\mathcal{U}}=\mathbf{b}_{\mathcal{U}}+2\mathbf{J}_{\mathcal{U}\mathcal{C}}\mathbf{s}_{\mathcal{C}}
\]

This reduces the QUBO/QAOA size from \(N_t\) variables to only \(|\mathcal{U}|\) variables.

## 5. Pauli-Z Ising Hamiltonian

Map BPSK symbols to Pauli-Z eigenvalues:

\[
s_i \rightarrow Z_i, \quad Z_i|0\rangle=+|0\rangle, \quad Z_i|1\rangle=-|1\rangle
\]

The reduced cost Hamiltonian is:

\[
H_C = \sum_i h_i Z_i + \sum_{i<j} 2J_{ij}Z_iZ_j
\]

## 6. QAOA circuit

Initial state:

\[
|\psi_0\rangle = H^{\otimes m}|0\rangle^{\otimes m}
\]

Cost unitary:

\[
U_C(\gamma)=e^{-j\gamma H_C}
\]

Mixer Hamiltonian:

\[
H_M=\sum_i X_i
\]

Mixer unitary:

\[
U_M(\beta)=e^{-j\beta H_M}
\]

One-layer QAOA state:

\[
|\psi(\gamma,\beta)\rangle = U_M(\beta)U_C(\gamma)|\psi_0\rangle
\]

Optimization objective:

\[
(\gamma^*,\beta^*) = \arg\min_{\gamma,\beta}
\langle\psi(\gamma,\beta)|H_C|\psi(\gamma,\beta)\rangle
\]

## 7. Main research contribution statement

The proposed method does not replace Enhanced LAMA. It uses Enhanced LAMA as a first-stage detector and reliability estimator. Then, it solves a reduced QUBO/QAOA problem only for uncertain symbols, improving detection reliability while avoiding a full exponential ML search.
