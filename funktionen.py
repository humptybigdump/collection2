import math


def berechne_hohlraum(a, b):
    if b >= 1:
        return 1 - math.pi / (4 * a)
    elif b < 1:
        return 1 - math.pi / (4 * a * b)


def berechne_log_temp_diff(T_e, T_a, T_r):
    delta_T_e = T_r - T_e
    delta_T_a = T_r - T_a
    return (delta_T_e - delta_T_a)/(math.log(delta_T_e / delta_T_a))


def berechne_reynolds(hohlraum, c_0, rho_0, rho_m, ny_m, l_ch):
    c_m = c_0 * rho_0 / rho_m
    reynolds = c_m * l_ch / (hohlraum * ny_m)
    if 10 < reynolds < pow(10, 6):
        return reynolds
    else:
        return False


def berechne_nusselt_lam(reynolds, Pr):
    return 0.664 * math.sqrt(reynolds) * pow(Pr,3)


def berechne_nusselt_turb(reynolds, Pr):
    return (0.037 * pow(reynolds,0.8) * Pr)/(1 + 2.443 * pow(reynolds,-0.1) * (pow(Pr,2/3) - 1))


def berechne_nusselt_0(nusselt_lam,nusselt_turb, T_m, T_w):
    return (0.3 + math.sqrt(pow(nusselt_lam,2) + pow(nusselt_turb,2))) * pow((T_m / T_w),0.12)


def berechne_f_faktor(b):
    return 1 + 2/(3 * b)


def berechne_nusselt_buendel(f_faktor, nusselt_0):
    return f_faktor * nusselt_0


def berechne_alpha_aussen(nussel_buendel, lambda_m, l_ch):
    return nussel_buendel * lambda_m / l_ch


def berechne_k(alpha_a, alpha_i, lamda_rohr, d_a, d_i):
    return pow(( 1/alpha_a + d_a / (2 * lamda_rohr) * math.log(d_a/d_i) + d_a / (d_i * alpha_i) ),-1)


def berechne_T_w(k, delta_T_log, alpha_a, T_m):
    return k * delta_T_log / alpha_a + T_m




