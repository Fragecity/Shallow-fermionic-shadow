from qiskit.quantum_info import Clifford
from qiskit import *
# from qiskit.providers import job_monitor
import numpy as np
from qiskit.visualization import plot_histogram
from qiskit_aer import AerSimulator

shots1toN = 500
# backend_sim = Aer.get_backend('qasm_simulator')
# backend_sim = Aer.get_backend('qasm_simulator',
#                             backend_options={'method': 'extended_stabilizer'})
extended_stabilizer_simulator = AerSimulator(method='extended_stabilizer')

def generate_cir(a,b):
    n = a * b
    qr = range(n)
    cr = range(n)
    circuit = QuantumCircuit(n,n)
    circuit.h(range(n))
    
    for row_ite in range(a-1): #[1,a-2]
        for col_ite in range(b-1): #[1,b-2]
            cur = row_ite * b + col_ite
            circuit.cz(cur,cur + 1)
            circuit.cz(cur, cur + b)
    
    cur_col = b-1
    for ite in range(a-1):
        cur = ite * b + cur_col
        circuit.cz(cur, cur + b)
    cur_row = a-1
    for ite in range(b-1):
        cur = cur_row * b + ite
        circuit.cz(cur, cur + 1)
    return circuit


def NumOnes(meas, key):
    n = len(key)
    count = 0
    for j in range(n):
        if meas[j+1] != 0 and key[n - j - 1]=='1':  ##inverse order for key
            count += 1
    return count  

def sample_circuit(measure, a, b, prob_1, prob_2, prob_ro):
    n = a * b
    ite_max = len(measure)
    print('Number of measurements: %d'%ite_max)
    circs = []
    for cur in range(ite_max):
        circ = generate_cir(a,b)
        for cur_qb in range(n):
            if measure[cur][cur_qb + 1] == 1:
                circ.h(cur_qb)
            elif measure[cur][cur_qb + 1] == 2:
                circ.sdg(cur_qb)
                circ.h(cur_qb)


        # Depolarizing quantum errors
        # error_1 = noise.depolarizing_error(prob_1, 1)
        # error_2 = noise.depolarizing_error(prob_2, 2)

        # Add errors to noise model
        # noise_model = noise.NoiseModel()
        # noise_model.add_all_qubit_quantum_error(error_1, ['u1', 'u2', 'u3']) #all single-qubit gates
        # noise_model.add_all_qubit_quantum_error(error_2, ['cz']) #depolarizing for two-qubit gates
        
        # for qi in range(n):
        #     read_err = noise.errors.readout_error.ReadoutError([[1-prob_ro, prob_ro],[prob_ro, 1-prob_ro]])
        #     noise_model.add_readout_error(read_err, [qi])
        # # Get basis gates from noise model
        # basis_gates = noise_model.basis_gates
        
        circ.measure(range(n), range(n))
        circs.append(circ)
        circs = transpile(circs, extended_stabilizer_simulator)
        job = extended_stabilizer_simulator.run(circs, shots = shots1toN)
        result = job.result()
        hit_basis = result.get_counts() 
        return hit_basis
    
def estimation(measure, str_basis, val_basis, d_basis):
    len_key = len(str_basis)
    expect = 0 
    sum = 0
    count_basis = 0
    count_d = 0
    for j in range(len_key):
        ones = NumOnes(measure[count_basis], str_basis[j])
        count_d += 1
        parity = ones % 2
        outcome = 1 - 2 * parity
        outcome = outcome * measure[count_basis][0]* val_basis[j]
#         outcome = outcome * val_basis[j]
        sum = sum + val_basis[j]
#         print(measure[count_basis])
#         print(str_basis[j])
        expect = expect + outcome
#         print('---%d-th, count_basis = %d, and outcome = %d, expect = %d ' %(j,count_basis,outcome, expect))
        if count_d >= d_basis[count_basis]:
            count_d = 0
            count_basis += 1
    print('Summation of expect: %d'%expect)
    expect = float(expect)/sum
    print('With %d copies of state, the expectation value is %f' %(sum, expect))


# start = time.time()
a = 7
b = 7
n = a * b
# Error probabilities
prob_1 = 0.0016 # 1-qubit gate
prob_2 = 0.0062 # 2-qubit gate
prob_ro = 0.0038 # readoutError
fileName = 'observables_' + str(n) + '.txt'
print(fileName)
fileObj = open(fileName, "r") #opens the file in read mode
measure = [[int(x) for x in line.split()] for line in fileObj]
fileObj.close()
hit_basis = sample_circuit(measure, a,b, prob_1, prob_2, prob_ro)
arr = np.array(hit_basis)
# str_basis = [key for p in arr for key in p.keys()]
# val_basis = [p[key] for p in arr for key in p.keys()]
# d_basis = [len(p) for p in arr]
estimation(measure, str_basis, val_basis,d_basis) #str_basis is a string array
# print(d_basis)
# end = time.time()
# print('Time cost: %.4f' %(end - start))