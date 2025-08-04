from typing import List, Optional

import numpy as np

from .mesh import Mesh, LinearMeshElement, QuadMeshElement, MeshElement
from .bcs import *


def __effective_bc(
    bc, direction_index, periodic_pos, periodic_otherel, nonperioric_otherel, otherface
):
    if direction_index == periodic_pos:
        if isinstance(bc, DummyPeriodicBoundaryCondition):
            bc = PeriodicBoundaryCondition(periodic_otherel, otherface)
    else:
        bc = InternalBoundaryCondition(nonperioric_otherel, otherface)
    return bc


def __make_1dbox(bcs: List[BoundaryCondition], xp: np.ndarray):
    nel = xp.size - 1
    elements: List[MeshElement] = [
        LinearMeshElement(
            xp[i],
            xp[i + 1],
            bcs=(
                __effective_bc(bcs[0], i, 0, nel - 1, i - 1, 1),
                __effective_bc(bcs[1], i, nel - 1, 0, i + 1, 0),
            ),
        )
        for i, _ in enumerate(xp[:-1])
    ]
    return Mesh(elements)


def __make_2dbox(bcs: List[BoundaryCondition], xp: np.ndarray, yp: np.ndarray):
    # Order of BCs: left, right, bottom, top
    nx = xp.size - 1
    ny = yp.size - 1
    elements: List[MeshElement] = [
        QuadMeshElement(
            complex(xp[ix], yp[iy]),
            complex(xp[ix + 1], yp[iy]),
            complex(xp[ix + 1], yp[iy + 1]),
            complex(xp[ix], yp[iy + 1]),
            bcs=(
                # Bottom
                __effective_bc(bcs[2], iy, 0, (ix + 1) * ny - 1, ix * ny + iy - 1, 2),
                # Right
                __effective_bc(bcs[1], ix, nx - 1, iy, (ix + 1) * ny + iy, 3),
                # Top
                __effective_bc(bcs[3], iy, ny - 1, ix * ny, ix * ny + iy + 1, 0),
                # Left
                __effective_bc(
                    bcs[0], ix, 0, (nx - 1) * ny + iy, (ix - 1) * ny + iy, 1
                ),
            ),
        )
        for ix, _ in enumerate(xp[:-1])
        for iy, _ in enumerate(yp[:-1])
    ]
    return Mesh(elements)


def __make_3dbox(
    bcs: List[BoundaryCondition], xp: np.ndarray, yp: np.ndarray, zp: np.ndarray
):
    # Order of BCs: left, right, bottom, top, back, front (back being min(zp) = zp[0])
    raise NotImplemented


def makebox(
    bcs: List[BoundaryCondition],
    xpts: np.ndarray,
    ypts: Optional[np.ndarray] = None,
    zpts: Optional[np.ndarray] = None,
):
    if zpts is None:
        if ypts is None:
            return __make_1dbox(bcs, xpts)
        else:
            return __make_2dbox(bcs, xpts, ypts)
    if ypts is not None:
        return __make_3dbox(bcs, xpts, ypts, zpts)
    raise ValueError("Bad parameters")
