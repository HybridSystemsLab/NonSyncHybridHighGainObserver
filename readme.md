This repository contains Matlab/Simulink code to implement a semiglobal hybrid observer for any hybrid dynamical system with :
    1. strongly differentially observable flow/jump maps,
    2. solutions of interest evolving in a compact set and exhibiting a dwell-time,
    3. unknown jump times,
as described in
*Semi-Global High-Gain Hybrid Observer for a Class of Hybrid Dynamical Systems with Unknown Jump Times*, Pauline Bernard and Ricardo G. Sanfelice, Submitted to TAC.

The main idea is to:
    1. run a preliminary continuous-time high-gain observer over an interval of time smaller than the dwell-time of the system, depending on a well-chosen logic described in the paper,
    2. a local high-gain hybrid observer.
The time at which we switch from 1. to 2. needs to ensure that the estimation error is sufficiently small for the second observer to work. This time must be determined based on the high-gain estimate only, and in spite of any jump the system may have done in the meantime (see paper)
The second observer consists in implementing a high-gain observer during flow and ``disconnecting'' it when the estimate comes close to the jump set, in order to avoid any counterproductive use of the system output around its jump time. When the high-gain observer is disconnected, the observer is just an open-loop predictor based on the system dynamics.

Two examples are given:
    - a bouncing ball with linear flows/jump times : a regularization of the jump set needs to be done to encode in the observer the absence of Zeno/discrete trajectories;
    - a spiking neuron with nonlinear flows/jump times.
Those examples are documented in the above paper.

In order to run the code, you must have the Hybrid Systems Simulation Toolbox installed in your Matlab path. Then, just run main_global.m.
