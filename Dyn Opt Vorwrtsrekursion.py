N = 3
S = {
     0: {"A"},
     1: {"B","C","D"},
     2: {"E","F"},
     3: {"G"},
}
U = {
    (1, "B"): {"A"},
    (1, "C"): {"A"},
    (1, "D"): {"A"},
    (2, "E"): {"B", "C", "D"},
    (2, "F"): {"C", "D"},
    (3, "G"): {"E", "F"}
}
prec = {
    (1, "B", "A"): "A",
    (1, "C", "A"): "A",
    (1, "D", "A"): "A",
    (2, "E", "B"): "B",
    (2, "E", "C"): "C",
    (2, "F", "C"): "C",
    (2, "E", "D"): "D",
    (2, "F", "D"): "D",
    (3, "G", "E"): "E",
    (3, "G", "F"): "F",
}
r = {
    (1, "B", "A"): -7,
    (1, "C", "A"): -8,
    (1, "D", "A"): -5,
    (2, "E", "B"): -12,
    (2, "E", "C"): -8,
    (2, "F", "C"): -9,
    (2, "E", "D"): -7,
    (2, "F", "D"): -13,
    (3, "G", "E"): -9,
    (3, "G", "F"): -6,
}
V = {
    (0, "A"): 0
}
s_N = "G"

u_opt = {}
for n in range(1, N+1):
    for s in S[n]:
        V[n, s] = -9999
        u_opt[n, s] = ""
        for u in U[n, s]:
            v_test = r[n, s, u] + V[n - 1, prec[n, s, u]]
            if v_test > V[n, s]:
                V[n, s] = v_test
                u_opt[n, s] = u
        print("V_", n, s, ": ", V[n, s], ", u*: ", u_opt[n, s])

u_opt_s_N = {}
s = s_N
for n in range(N, 0, -1):
    u_opt_s_N[n, s] = u_opt[n, s]
    s = prec[n, s, u_opt[n, s]]
print(*u_opt_s_N,sep="\n")