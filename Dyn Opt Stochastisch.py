q = {}
q[300] = 0.2
q[350] = 0.3
q[400] = 0.4
q[450] = 0.1
N = 3
S = {}
for n in range(0, N+1):
    S[n] = {300, 350, 400, 450, "accepted"}
A = {}
for n in range(0, N+1):
    for s in S[n]:
        A[n, s] = {0, 1}
p = {}
for n in range(0, N):
    for s in S[n]:
        for s_prime in S[n+1]:
            for a in A[n, s]:
                if a == 0:
                    if s != "accepted" and s_prime != "accepted":
                        p[n, s, a, s_prime] = q[s_prime]
                    else:
                        p[n, s, a, s_prime] = 0
                else:
                    if s_prime != "accepted":
                        p[n, s, a, s_prime] = 0
                    if s_prime == "accepted":
                        p[n, s, a, s_prime] = 1
r = {}
for n in range(0, N):
    for s in S[n]:
        for a in A[n, s]:
            if s != "accepted":
                r[n, s, a] = s * a
            else:
                r[n, s, a] = 0
V = {}
for s in S[N]:
    V[N, s] = 0
a_opt = {}
for n in range(N - 1,-1,-1):
    for s in S[n]:
        V[n, s] = -9999
        a_opt[n, s] = "X"
        for a in A[n, s]:
            v_test = r[n, s, a] 
            for s_prime in S[n+1]:
                v_test = v_test + p[n, s, a, s_prime] * V[n + 1, s_prime]
            if v_test > V[n, s]:
                V[n, s] = v_test
                a_opt[n, s] = a
        print("V_", n, s, ": ", V[n, s], ", a*: ", a_opt[n, s])
    print()