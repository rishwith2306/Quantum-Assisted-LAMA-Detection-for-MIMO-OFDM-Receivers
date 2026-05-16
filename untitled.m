# Quantum-Assisted Enhanced LAMA MIMO-OFDM MATLAB Project

This project is a research/marks-oriented MATLAB simulation package for extending the paper:
"Large Scale MIMO Analysis Using Enhanced LAMA".

Main honest idea:
- Do not replace Enhanced LAMA blindly.
- Use Enhanced LAMA preprocessing and soft reliability to reduce the search space.
- Refine only uncertain symbols using a reduced QUBO / QAOA block.
- Compare MMSE, Enhanced LAMA, LAMA-guided QUBO refinement, and LAMA-guided QAOA refinement using SER vs SNR.

Run order:
1. Open MATLAB.
2. Set current folder to this project folder.
3. Run:
   run_project

Main outputs saved in ./results:
- Full MIMO-OFDM receiver architecture block diagram
- Enhanced LAMA detector block diagram
- Proposed LAMA-guided QUBO/QAOA detector block diagram
- SER vs SNR comparison plot
- Pauli/QAOA circuit conceptual diagram
- MAT result file

Important honesty:
- QAOA here is a state-vector simulation proof-of-concept, not IBM hardware execution.
- Exact QUBO local refinement is classical exhaustive search over only the uncertain subset.
- QAOA may or may not beat Enhanced LAMA depending on depth, optimizer grid, SNR, and number of qubits.
- The strongest defensible contribution is the architecture: Enhanced LAMA + reliability-guided reduced QUBO/QAOA refinement.

V2 fixes added:
- Uncertain-symbol selection is now truly threshold-based. If all LAMA outputs are confident, QUBO/QAOA is not run.
- QAOA costs are normalized before phase encoding.
- QAOA refinement is accepted only when it lowers the classical ML/QUBO objective.
- SER plots no longer use an artificial 1e-6 floor for zero-error points.
- A search-space-reduction graph is generated as 07_search_space_reduction.png.
