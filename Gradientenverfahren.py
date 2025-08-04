import scipy.optimize as opt
import sympy
import numpy

def fct(expr, x_arg, y_arg):
    return expr.subs({x: x_arg, y: y_arg})

def grad(expr, x_arg, y_arg):
    grad = sympy.tensor.array.derive_by_array(expr, [x, y])
    return [float(grad[i].subs({x: x_arg, y: y_arg})) for i in range(0, len(grad))]

x, y, t = sympy.symbols("x, y, t")
f = -4*x - 2*y - x**2 + x**4 + 2*x*y +y**2

epsilon = 0.001
[x_arg, y_arg] = [1, 1]
currentGrad = grad(f, x_arg, y_arg)

while abs(numpy.linalg.norm(currentGrad)) > epsilon:
    currentGrad = grad(f, x_arg, y_arg)
    d = [-currentGrad[i] for i in range(0, len(currentGrad))]
    f_line = f.subs({x: x_arg + d[0] * t, y: y_arg + d[1] * t})
    lam_f_line = sympy.lambdify(t, f_line)
    t_opt = opt.minimize_scalar(lam_f_line, method='golden', bounds=(0, float("inf"))).x
    [x_arg, y_arg] = [x_arg + t_opt * d[0], y_arg + t_opt * d[1]]
    print(x_arg, y_arg)