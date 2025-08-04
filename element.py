from .utils import gll_pointsandweights, gll_derivative
from .mesh import MeshElement, LinearMeshElement, QuadMeshElement
from abc import ABC

import numpy as np


class Element(ABC):
    """Abstract base class for all SEM elements"""

    degree: int
    """Polynomial degree of GLL points (there are degree+1 points per direction)"""

    weights: np.ndarray
    """Integration weights corresponding to the GLL point"""

    jac: np.ndarray
    """Jacobian matrix dx/dxi"""

    pts: np.ndarray
    """Array of GLL points in physical space"""

    def __init__(self, me: MeshElement, degree: int, **kwargs):
        self.degree = degree
        self.me = me
        if "mu" not in kwargs:
            kwargs["mu"] = 1
        for k, v in kwargs.items():
            if callable(v):
                setattr(self, k, v)
            else:
                setattr(self, k, lambda *_: v)


class LinearElement(Element):
    r: np.ndarray
    """Position of GLL points in this element"""

    x: np.ndarray
    """Position of GLL points in physical space"""

    @property
    def pts(self):
        return self.x

    def __init__(self, me: LinearMeshElement, degree: int, **kwargs):
        super().__init__(me, degree, **kwargs)

        self.r, self.weights = gll_pointsandweights(degree)

        self.x = me.trans(self.r)
        self.jac = np.ones((degree + 1)) * (me.end - me.start) / 2

        self.stiffness = self.compute_stiffness()

    def compute_stiffness(self) -> np.ndarray:
        deriv_mat = gll_derivative(self.degree)

        # TODO: Your code here
        # Return the local stiffness matrix of this element.


class QuadElement(Element):
    def __init__(self, me: MeshElement, degree: int, **kwargs):
        super().__init__(me, degree, **kwargs)
        r, weights = gll_pointsandweights(degree)
        tmp1, tmp2 = np.meshgrid(r, r)
        self.r = np.ravel(tmp1)
        self.s = np.ravel(tmp2)
        tmp1, tmp2 = np.meshgrid(weights, weights)
        self.weights = np.ravel(tmp1) * np.ravel(tmp2)

        self.pts = me.trans(self.r, self.s)
        self.x = np.real(self.pts)
        self.y = np.imag(self.pts)

        self.compute_geometric_factors()
        self.stiffness = self.compute_stiffness()

    def compute_geometric_factors(self):
        self.dptdr = (
            1
            / 4
            * (
                -(1 - self.s) * self.me.pts[0]
                + (1 - self.s) * self.me.pts[1]
                + (1 + self.s) * self.me.pts[2]
                - (1 + self.s) * self.me.pts[3]
            )
        )
        self.dptds = (
            1
            / 4
            * (
                -(1 - self.r) * self.me.pts[0]
                - (1 + self.r) * self.me.pts[1]
                + (1 + self.r) * self.me.pts[2]
                + (1 - self.r) * self.me.pts[3]
            )
        )
        self.jac = np.real(self.dptdr) * np.imag(self.dptds) - np.imag(
            self.dptdr
        ) * np.real(self.dptds)

        self.vgeom = []
        self.drdx = 1 / self.jac * np.imag(self.dptds)
        self.drdy = -1 / self.jac * np.real(self.dptds)
        self.dsdx = -1 / self.jac * np.imag(self.dptdr)
        self.dsdy = 1 / self.jac * np.real(self.dptdr)

        self.vgeom += [(self.drdx * self.drdx + self.drdy * self.drdy) * self.jac]
        self.vgeom += [(self.dsdx * self.drdx + self.dsdy * self.drdy) * self.jac]
        self.vgeom += [(self.dsdx * self.dsdx + self.dsdy * self.dsdy) * self.jac]

    def compute_stiffness(self):
        deriv = gll_derivative(self.degree)

        # Options:
        # 1) - apply the derivative operator 2 (N+1)^2 * d
        #    - apply the geometric factors: 18 (N+1)^(d+1)
        #    - apply the derivative operator: 2 (N+1)^2 * d
        # 2) - apply the matrix directly: 2 (N+1)^(2d) operations (implemented here)
        # For d=2, the break-even would be around N=8. For d=3 the break-even is at N=2.

        # TODO: Your code here. Have a look at test_2d_integration_stiffness_matrix
        # for inspiration.


element_map = {LinearMeshElement: LinearElement, QuadMeshElement: QuadElement}


def ElementFactory(me: MeshElement, degree: int, **kwargs) -> Element:
    """Factory method to create Elements from MeshElements
    Kwargs are passed to constructor of element"""
    return element_map[me.__class__](me, degree, **kwargs)
