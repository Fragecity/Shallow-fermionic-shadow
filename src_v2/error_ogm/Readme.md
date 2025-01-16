**Readme**:

The generated meas and pr will be save in ‘CutSet/GBCS_’+‘LiH_12.txt‘ (or others). (or GBCSV2, GBCSV3)

Added procedures for a sampling based on a given P for a given ground state.

> Sample_gstate: return the total measurements Sample_mu after measure all of qubit under P.
>
> pro_perMeas: return the probability to measure 1.
>
> update_gstate: return the updated gstate after one measure.



##Folder:

####*diag_opt*: Optimization of diag_var here.

***Input txt file***: Hamiltonian/molecule + qubits + (jw or bk orparity).txt.

***Output txt file***: Set(or CutSet)/molecule + qubits + (jw or bk orparity).txt. containing 'meas' and 'pr'.

In main.m: we need to execute LBCS(1), CUTGBCS/-V2/-V3(7-9) (cut down the meas with small pro.).

####error: compute error.

***Input txt file***: 

1. Hamiltonian/molecule + qubits + (jw or bk orparity).txt.
2. Set (or CutSet)/molecule + qubits + (jw or bk orparity).txt. containing 'meas' and 'pr'.  (Output of the corresponding file in diag_out  file).

In Smple_main.m:

str_GBCS = 'CutSet/GBCS\_' for GBCSV1, and 'CutSet/GBCSV2\_' for GBCSV2, 'CutSet/GBCSV3\_' for GBCSV3.

Options: (0: GBCS; (no need for this option)1: LBCS; 2: grouping; 3: Derandomized alg for Huang et al; 4: Derandomized alg for GBCS; 5: k-LBCS->GBCS.): 

We need 1,2,3,4. For option 4, we need to change a variable

> str_GBCS = 'CutSet/GBCS_'; %% CutSet/GBCSV2_ or CutSet/GBCSV3_

for different version of GBCS (Only input file are different, the procedure are the same).

***Noted:***Here we only need to execute 1.LBCS, 2.grouping, 3.Derandomized alg for Huang et al and 4.Derandomized alg for GBCS;

If you choose option 4, you need to be careful for the initialization of the variable **str_GBCS** in Sample_main.m, as mentioned before.

For grouping, the probability is obtained by function LDFGroup to get P, here we don't read from a file since it is very fast.

***Noted*** : For option 4 Derandomized alg for GBCS: We also need to output **initial_error**, as follows,

> initial_error = Initial_error(observ, meas, len, phi);

initial_error is the error when Q_j has never come up in any sets.

$$Ini_\varepsilon = \sum_{j:Q_j \not\in\forall set } \alpha_j \text{tr}(\rho Q_j)$$

**Output: error and initial_error for option 4.** 

**Note**: If the error is very large for GBCS/V2/V3, adjust file ***main_CutGBCS (main_CutGBCSV2/ main_CutCBCSV3)*** in diag_opt and update the input file in Cutset.

> How to adjust e.g.: main_CutGBCS
>
> MAX_step = 5;  %%decrease this number can make procedure go faster.

> In line 107-109:  
>
>   [pr, diagonal_var] = OptDiagVar(pr, 10 * step); %% It the error is large, please amplify 10*step, e.g. , let it be 100 (This value respresents the optimization iterations in the optimization function for diag_var).

####variance: compute variance.

***Input txt file***:  

1. ground_state/...

2. Set (or CutSet)/...
3. Hamiltonian/...

Options: 

(1) a number between 0 and 6 to represent the program you wish to execute. (0: GBCS; 1: LBCS; 2: grouping; 4: L1sampling; 5: GBCS version 2, 6: GBCS version 3.

Here we only need to execute 0,1,2,4,5,6. (***Note***: update Set by diag_out.).  (3 cannot work now.)

(2) Input file (E.g.: H2_4jw/H2_8jw/LiH_12jw/BeH2_14jw/NH3_16jw) and ...bk,...parity

**output**: variance.

#### 归档GroundState.zip

Contain all of the groundstate.

The first line of each file is the ground energy, also is the expectation of v.

****

**Please add the data for the error and variance for LBCS procedure but input set is 1/3 for all of p.--> this is called original shadow alg.**

****

