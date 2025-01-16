import pickle
import matplotlib.pyplot as plt
import numpy as np

with open("data_FCS_n=8_d=1.pkl", "rb") as f:
    FCS_means, FCS_vars = pickle.load(f)

with open("data_n=8_d=1.pkl", "rb") as f:
    means, vars, thm_mean = pickle.load(f)

samples = [100, 200, 350, 500, 1000, 2000, 4000]


def distance_thm(data):
    res = []
    for y in data:
        res.append(abs(y - thm_mean))
    return res


# samples = range(16)
# plt.fill_between(
#     samples,
#     np.array(means) - np.array(vars),
#     np.array(means) + np.array(vars),
#     alpha=0.2,
# )
# plt.fill_between(
#     samples,
#     np.array(FCS_means) - np.array(FCS_vars),
#     np.array(FCS_means) + np.array(FCS_vars),
#     alpha=0.2,
# )
# plt.yscale("log", base=2)
plt.xscale("log", base=2)
plt.plot(samples, distance_thm(means), "-o", label="Our Method")
plt.plot(samples, distance_thm(FCS_means), "-o", label="FCS Method")
# plt.axhline(y=thm_mean, color="r", linestyle="--")
plt.legend()
plt.show()
