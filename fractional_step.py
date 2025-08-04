import numpy as np
from scipy.sparse import csc_matrix # for sparse matrix
from scipy.sparse.linalg import spsolve # for sparse matrix



A_poisson = 0



def get_star(us, vs, un, vn, pn, m, dt, re):

    # Solve momentum equation
    for ix in range(1,m.nx):  # cycle for x component of p array
        for iy in range(m.ny):  # cycle for y component of p array

            #    WARNING!! ATTENTION!!
            # 
            #    This is the coordinate system for the cell (i,j) in Python
            #
            #    --------------
            #    |            |
            #    |            |
            #    |            |
            #    Ui,j+1 Pi,j  |
            #    |            | 
            #    |            |
            #    |            |
            #    ----Vi+1,j----
            #
            #
            #    and this is the local coordinate system like fig. 21 in § 6.5 of the script
            #
            #    --------------
            #    |            |
            #    |            |
            #    |            |
            #    Uij   Pij    |
            #    |            | 
            #    |            |
            #    |            |
            #    ------Vij-----
            #
            #
            
            # Determining python indices such that they are consistent with the script:
            # ix,iy:        indices of p array
            # ix_u,iy_u:    indices of u array
            # ix_u,iy_u:    indices of v array
            ix_u = ix
            iy_u = iy + 1   # shift due to ghost cell at bottom side of p field in script
            ix_v = ix + 1   # shift due to ghost cell at left side of p field in script
            iy_v = iy

            # fill the discretized u-momentum equation to get u*
            us[ix_u,iy_u]  = (un[ix_u,iy_u+1] + un[ix_u,iy_u]  )*(vn[ix_v,iy_v+1] + vn[ix_v-1,iy_v+1])
            us[ix_u,iy_u] -= (un[ix_u,iy_u]   + un[ix_u,iy_u-1])*(vn[ix_v,iy_v]   + vn[ix_v-1,iy_v]  )
            us[ix_u,iy_u] /=-(4*m.dy) 
            us[ix_u,iy_u] -= ((un[ix_u+1,iy_u] + un[ix_u,iy_u])**2 - (un[ix_u,iy_u] + un[ix_u-1,iy_u])**2)/(4*m.dx)
            us[ix_u,iy_u] -= (pn[ix,iy ] - pn[ix-1,iy])/m.dx
            us[ix_u,iy_u] += (un[ix_u+1,iy_u] - 2*un[ix_u,iy_u] + un[ix_u-1,iy_u])/(m.dx**2*re)
            us[ix_u,iy_u] += (un[ix_u,iy_u+1] - 2*un[ix_u,iy_u] + un[ix_u,iy_u-1])/(m.dy**2*re)
            us[ix_u,iy_u] *= dt
            us[ix_u,iy_u] += un[ix_u,iy_u]

    # zero velocity at wall corners!
    # unnecessary block, because us already gets initialized with zeros and it would be sufficient never to change the entries in order to fulfill impermeability of the wall
    ix = 0
    for iy in range(-1,m.ny+1):
        # Determining python indices such that they are consistent with the script:
        ix_u = ix
        iy_u = iy + 1   # shift due to ghost cell at bottom side of p field in script

        # fill the discretized u-momentum equation to get u*
        us[ix_u,iy_u] = 0

    # unnecessary block, because us already gets initialized with zeros and it would be sufficient never to change the entries in order to fulfill impermeability of the wall
    ix = m.nx
    for iy in range(-1,m.ny+1):
        # Determining python indices such that they are consistent with the script:
        ix_u = ix
        iy_u = iy + 1   # shift due to ghost cell at bottom side of p field in script

        # fill the discretized u-momentum equation to get u*
        us[ix_u,iy_u] = 0

    iy = -1
    for ix in range(1,m.nx):
        # Determining python indices such that they are consistent with the script:
        ix_u = ix
        iy_u = iy + 1   # shift due to ghost cell at bottom side of p field in script

        # fill the discretized u-momentum equation to get u*
        us[ix_u,iy_u] = -us[ix_u,iy_u+1]

    iy = m.ny 
    for ix in range(1,m.nx):
        # Determining python indices such that they are consistent with the script:
        ix_u = ix
        iy_u = iy + 1   # shift due to ghost cell at bottom side of p field in script

        # fill the discretized u-momentum equation to get u*
        us[ix_u,iy_u] = 2 - us[ix_u,iy_u-1]

    for ix in range(m.nx): # cycle for vertical component
        for iy in range(1,m.ny):

            ix_u = ix
            iy_u = iy + 1   # shift due to ghost cell at bottom side of p field in script
            ix_v = ix + 1   # shift due to ghost cell at left side of p field in script
            iy_v = iy
            # fill the discretized u-momentum equation to get v*
            vs[ix_v,iy_v]  = (un[ix_u+1,iy_u] + un[ix_u+1,iy_u-1]  )*(vn[ix_v+1,iy_v] + vn[ix_v,iy_v])
            vs[ix_v,iy_v] -= (un[ix_u,iy_u]   + un[ix_u,iy_u-1]    )*(vn[ix_v-1,iy_v] + vn[ix_v,iy_v]) 
            vs[ix_v,iy_v] /=-(4*m.dx) 
            vs[ix_v,iy_v] -= ((vn[ix_v,iy_v+1] + vn[ix_v,iy_v])**2 - (vn[ix_v,iy_v] + vn[ix_v,iy_v-1])**2)/(4*m.dy)
            vs[ix_v,iy_v] -= (pn[ix,iy] - pn[ix,iy-1])/m.dy
            vs[ix_v,iy_v] += (vn[ix_v+1,iy_v] - 2*vn[ix_v,iy_v] + vn[ix_v-1,iy_v])/(m.dx**2*re)
            vs[ix_v,iy_v] += (vn[ix_v,iy_v+1] - 2*vn[ix_v,iy_v] + vn[ix_v,iy_v-1])/(m.dy**2*re)
            vs[ix_v,iy_v] *= dt
            vs[ix_v,iy_v] += vn[ix_v,iy_v]

    # zero velocity at wall corners!
    # unnecessary block, because us already gets initialized with zeros and it would be sufficient never to change the entries in order to fulfill impermeability of the wall
    iy = 0
    for ix in range(-1,m.nx+1):
        # Determining python indices such that they are consistent with the script:
        ix_v = ix + 1   # shift due to ghost cell at left side of p field in script
        iy_v = iy

        # fill the discretized u-momentum equation to get u*
        vs[ix_v,iy_v] = 0

    # unnecessary block, because us already gets initialized with zeros and it would be sufficient never to change the entries in order to fulfill impermeability of the wall
    iy = m.ny
    for ix in range(-1,m.nx+1):
        # Determining python indices such that they are consistent with the script:
        ix_v = ix + 1   # shift due to ghost cell at left side of p field in script
        iy_v = iy

        # fill the discretized u-momentum equation to get u*
        vs[ix_v,iy_v] = 0

    ix = -1
    for iy in range(1,m.ny):
        # Determining python indices such that they are consistent with the script:
        ix_v = ix + 1   # shift due to ghost cell at left side of p field in script
        iy_v = iy

        # fill the discretized u-momentum equation to get u*
        vs[ix_v,iy_v] = -vs[ix_v+1,iy_v]

    ix = m.nx
    for iy in range(1,m.ny):
        # Determining python indices such that they are consistent with the script:
        ix_v = ix + 1   # shift due to ghost cell at left side of p field in script
        iy_v = iy

        # fill the discretized u-momentum equation to get u*
        vs[ix_v,iy_v] = -vs[ix_v-1,iy_v]

    return us,vs

def get_star_slice(us, vs, un, vn, pn, m, dt, re):

    # Solve momentum equation
    ix = np.arange(1,m.nx)  # cycle for x component of p array
    iy = np.arange(m.ny)  # cycle for y component of p array

    #    WARNING!! ATTENTION!!
    # 
    #    This is the coordinate system for the cell (i,j) in Python
    #
    #    --------------
    #    |            |
    #    |            |
    #    |            |
    #    Ui,j+1 Pi,j  |
    #    |            | 
    #    |            |
    #    |            |
    #    ----Vi+1,j----
    #
    #
    #    and this is the local coordinate system like fig. 21 in § 6.5 of the script
    #
    #    --------------
    #    |            |
    #    |            |
    #    |            |
    #    Uij   Pij    |
    #    |            | 
    #    |            |
    #    |            |
    #    ------Vij-----
    #
    #
    
    # Determining python indices such that they are consistent with the script:
    # ix,iy:        indices of p array
    # ix_u,iy_u:    indices of u array
    # ix_u,iy_u:    indices of v array
    ix_u = ix
    iy_u = iy + 1   # shift due to ghost cell at bottom side of p field in script
    ix_v = ix + 1   # shift due to ghost cell at left side of p field in script
    iy_v = iy

    # fill the discretized u-momentum equation to get u*
    us[np.ix_(ix_u,iy_u)]  = (un[np.ix_(ix_u,iy_u+1)] + un[np.ix_(ix_u,iy_u)]  )*(vn[np.ix_(ix_v,iy_v+1)] + vn[np.ix_(ix_v-1,iy_v+1)])
    us[np.ix_(ix_u,iy_u)] -= (un[np.ix_(ix_u,iy_u)]   + un[np.ix_(ix_u,iy_u-1)])*(vn[np.ix_(ix_v,iy_v)]   + vn[np.ix_(ix_v-1,iy_v)]  )
    us[np.ix_(ix_u,iy_u)] /=-(4*m.dy) 
    us[np.ix_(ix_u,iy_u)] -= ((un[np.ix_(ix_u+1,iy_u)] + un[np.ix_(ix_u,iy_u)])**2 - (un[np.ix_(ix_u,iy_u)] + un[np.ix_(ix_u-1,iy_u)])**2)/(4*m.dx)
    us[np.ix_(ix_u,iy_u)] -= (pn[np.ix_(ix,iy )] - pn[np.ix_(ix-1,iy)])/m.dx
    us[np.ix_(ix_u,iy_u)] += (un[np.ix_(ix_u+1,iy_u)] - 2*un[np.ix_(ix_u,iy_u)] + un[np.ix_(ix_u-1,iy_u)])/(m.dx**2*re)
    us[np.ix_(ix_u,iy_u)] += (un[np.ix_(ix_u,iy_u+1)] - 2*un[np.ix_(ix_u,iy_u)] + un[np.ix_(ix_u,iy_u-1)])/(m.dy**2*re)
    us[np.ix_(ix_u,iy_u)] *= dt
    us[np.ix_(ix_u,iy_u)] += un[np.ix_(ix_u,iy_u)]

    # zero velocity at wall corners!
    # unnecessary block, because us already gets initialized with zeros and it would be sufficient never to change the entries in order to fulfill impermeability of the wall
    ix = np.array([0])
    iy = np.arange(-1,m.ny+1)
    # Determining python indices such that they are consistent with the script:
    ix_u = ix
    iy_u = iy + 1   # shift due to ghost cell at bottom side of p field in script

    # fill the discretized u-momentum equation to get u*
    us[np.ix_(ix_u,iy_u)] = 0

    # unnecessary block, because us already gets initialized with zeros and it would be sufficient never to change the entries in order to fulfill impermeability of the wall
    ix = np.array([m.nx])
    iy = np.arange(-1,m.ny+1)
    # Determining python indices such that they are consistent with the script:
    ix_u = ix
    iy_u = iy + 1   # shift due to ghost cell at bottom side of p field in script

    # fill the discretized u-momentum equation to get u*
    us[np.ix_(ix_u,iy_u)] = 0

    iy = np.array([-1])
    ix = np.arange(1,m.nx)
    # Determining python indices such that they are consistent with the script:
    ix_u = ix
    iy_u = iy + 1   # shift due to ghost cell at bottom side of p field in script

    # fill the discretized u-momentum equation to get u*
    us[np.ix_(ix_u,iy_u)] = -us[np.ix_(ix_u,iy_u+1)]

    iy = np.array([m.ny])
    ix = np.arange(1,m.nx)
    # Determining python indices such that they are consistent with the script:
    ix_u = ix
    iy_u = iy + 1   # shift due to ghost cell at bottom side of p field in script

    # fill the discretized u-momentum equation to get u*
    us[np.ix_(ix_u,iy_u)] = 2 - us[np.ix_(ix_u,iy_u-1)]

    ix = np.arange(m.nx) # cycle for vertical component
    iy = np.arange(1,m.ny)

    ix_u = ix
    iy_u = iy + 1   # shift due to ghost cell at bottom side of p field in script
    ix_v = ix + 1   # shift due to ghost cell at left side of p field in script
    iy_v = iy
    # fill the discretized u-momentum equation to get v*
    vs[np.ix_(ix_v,iy_v)]  = (un[np.ix_(ix_u+1,iy_u)] + un[np.ix_(ix_u+1,iy_u-1)]  )*(vn[np.ix_(ix_v+1,iy_v)] + vn[np.ix_(ix_v,iy_v)])
    vs[np.ix_(ix_v,iy_v)] -= (un[np.ix_(ix_u,iy_u)]   + un[np.ix_(ix_u,iy_u-1)]    )*(vn[np.ix_(ix_v-1,iy_v)] + vn[np.ix_(ix_v,iy_v)]) 
    vs[np.ix_(ix_v,iy_v)] /=-(4*m.dx) 
    vs[np.ix_(ix_v,iy_v)] -= ((vn[np.ix_(ix_v,iy_v+1)] + vn[np.ix_(ix_v,iy_v)])**2 - (vn[np.ix_(ix_v,iy_v)] + vn[np.ix_(ix_v,iy_v-1)])**2)/(4*m.dy)
    vs[np.ix_(ix_v,iy_v)] -= (pn[np.ix_(ix,iy)] - pn[np.ix_(ix,iy-1)])/m.dy
    vs[np.ix_(ix_v,iy_v)] += (vn[np.ix_(ix_v+1,iy_v)] - 2*vn[np.ix_(ix_v,iy_v)] + vn[np.ix_(ix_v-1,iy_v)])/(m.dx**2*re)
    vs[np.ix_(ix_v,iy_v)] += (vn[np.ix_(ix_v,iy_v+1)] - 2*vn[np.ix_(ix_v,iy_v)] + vn[np.ix_(ix_v,iy_v-1)])/(m.dy**2*re)
    vs[np.ix_(ix_v,iy_v)] *= dt
    vs[np.ix_(ix_v,iy_v)] += vn[np.ix_(ix_v,iy_v)]

    # zero velocity at wall corners!
    # unnecessary block, because us already gets initialized with zeros and it would be sufficient never to change the entries in order to fulfill impermeability of the wall
    iy = np.array([0])
    ix = np.arange(-1,m.nx+1)
    # Determining python indices such that they are consistent with the script:
    ix_v = ix + 1   # shift due to ghost cell at left side of p field in script
    iy_v = iy

    # fill the discretized u-momentum equation to get u*
    vs[np.ix_(ix_v,iy_v)] = 0

    # unnecessary block, because us already gets initialized with zeros and it would be sufficient never to change the entries in order to fulfill impermeability of the wall
    iy = np.array([m.ny])
    ix = np.arange(-1,m.nx+1)
    # Determining python indices such that they are consistent with the script:
    ix_v = ix + 1   # shift due to ghost cell at left side of p field in script
    iy_v = iy

    # fill the discretized u-momentum equation to get u*
    vs[np.ix_(ix_v,iy_v)] = 0

    ix = np.array([-1])
    iy = np.arange(1,m.ny)
    # Determining python indices such that they are consistent with the script:
    ix_v = ix + 1   # shift due to ghost cell at left side of p field in script
    iy_v = iy

    # fill the discretized u-momentum equation to get u*
    vs[np.ix_(ix_v,iy_v)] = -vs[np.ix_(ix_v+1,iy_v)]

    ix = np.array([m.nx])
    iy = np.arange(1,m.ny)
    # Determining python indices such that they are consistent with the script:
    ix_v = ix + 1   # shift due to ghost cell at left side of p field in script
    iy_v = iy

    # fill the discretized u-momentum equation to get u*
    vs[np.ix_(ix_v,iy_v)] = -vs[np.ix_(ix_v-1,iy_v)]

    return us,vs

###########################################
###############   Task 2.   ###############
###########################################
def get_l_M(nx,ny,x_lft,x_rgt,y_btm,y_top):
    
    dst_t_lft_wll = ??
    dst_t_rgt_wll = ??
    dst_t_btm_wll = ??
    dst_t_top_wll = ??
    kappa = 0.4
    l_M = kappa*??

    return l_M

def get_star_RANS_slice(us, vs, un, vn, pn, m, dt, re):

    ###########################################
    ###############   Task 3.   ###############
    ###########################################
    # Get suqare of mixing length:
    l_M_sq = np.power(get_l_M(??,??,??,??,??,??),2)

    # Solve momentum equation
    ix = np.arange(1,m.nx)  # cycle for x component of p array
    iy = np.arange(m.ny)  # cycle for y component of p array

    #    WARNING!! ATTENTION!!
    # 
    #    This is the coordinate system for the cell (i,j) in Python
    #
    #    --------------
    #    |            |
    #    |            |
    #    |            |
    #    Ui,j+1 Pi,j  |
    #    |            | 
    #    |            |
    #    |            |
    #    ----Vi+1,j----
    #
    #
    #    and this is the local coordinate system like fig. 21 in § 6.5 of the script
    #
    #    --------------
    #    |            |
    #    |            |
    #    |            |
    #    Uij   Pij    |
    #    |            | 
    #    |            |
    #    |            |
    #    ------Vij-----
    #
    #
    
    # Determining python indices such that they are consistent with the script:
    # ix,iy:        indices of p array
    # ix_u,iy_u:    indices of u array
    # ix_u,iy_u:    indices of v array
    # ix_y,iy_y:    indices of l_M_sq array
    ix_u = ix
    iy_u = iy + 1   # shift due to ghost cell at bottom side of p field in script
    ix_v = ix + 1   # shift due to ghost cell at left side of p field in script
    iy_v = iy
    ###########################################
    ###############   Task 3.   ###############
    ###########################################
    ix_l = ??
    iy_l = ??
    # Determine squares of mixing lengths at cell boundaries:
    l_M_sq_e = l_M_sq[np.ix_(??,??)]
    l_M_sq_w = l_M_sq[np.ix_(??,??)]
    l_M_sq_n = l_M_sq[np.ix_(??,??)]
    l_M_sq_s = l_M_sq[np.ix_(??,??)]
    # Determine velocity gradients at cell boundaries:
    du_dx_e = ??
    du_dx_w = ??
    du_dy_n = ??
    dv_dx_n = ??
    du_dy_s = ??
    dv_dx_s = ??
    # fill the discretized u-momentum equation to get u*
    us[np.ix_(ix_u,iy_u)]  = (un[np.ix_(ix_u,iy_u+1)] + un[np.ix_(ix_u,iy_u)]  )*(vn[np.ix_(ix_v,iy_v+1)] + vn[np.ix_(ix_v-1,iy_v+1)])
    us[np.ix_(ix_u,iy_u)] -= (un[np.ix_(ix_u,iy_u)]   + un[np.ix_(ix_u,iy_u-1)])*(vn[np.ix_(ix_v,iy_v)]   + vn[np.ix_(ix_v-1,iy_v)]  )
    us[np.ix_(ix_u,iy_u)] /=-(4*m.dy) 
    us[np.ix_(ix_u,iy_u)] -= ((un[np.ix_(ix_u+1,iy_u)] + un[np.ix_(ix_u,iy_u)])**2 - (un[np.ix_(ix_u,iy_u)] + un[np.ix_(ix_u-1,iy_u)])**2)/(4*m.dx)
    us[np.ix_(ix_u,iy_u)] -= (pn[np.ix_(ix,iy )] - pn[np.ix_(ix-1,iy)])/m.dx
    us[np.ix_(ix_u,iy_u)] += (un[np.ix_(ix_u+1,iy_u)] - 2*un[np.ix_(ix_u,iy_u)] + un[np.ix_(ix_u-1,iy_u)])/(m.dx**2*re)
    us[np.ix_(ix_u,iy_u)] += (un[np.ix_(ix_u,iy_u+1)] - 2*un[np.ix_(ix_u,iy_u)] + un[np.ix_(ix_u,iy_u-1)])/(m.dy**2*re)
    ###########################################
    ###############   Task 4.   ###############
    ###########################################
    us[np.ix_(ix_u,iy_u)] += ??
    us[np.ix_(ix_u,iy_u)] -= ??
    us[np.ix_(ix_u,iy_u)] += ??
    us[np.ix_(ix_u,iy_u)] -= ??
    us[np.ix_(ix_u,iy_u)] *= dt
    us[np.ix_(ix_u,iy_u)] += un[np.ix_(ix_u,iy_u)]

    # zero velocity at wall corners!
    # unnecessary block, because us already gets initialized with zeros and it would be sufficient never to change the entries in order to fulfill impermeability of the wall
    ix = np.array([0])
    iy = np.arange(-1,m.ny+1)
    # Determining python indices such that they are consistent with the script:
    ix_u = ix
    iy_u = iy + 1   # shift due to ghost cell at bottom side of p field in script

    # fill the discretized u-momentum equation to get u*
    us[np.ix_(ix_u,iy_u)] = 0

    # unnecessary block, because us already gets initialized with zeros and it would be sufficient never to change the entries in order to fulfill impermeability of the wall
    ix = np.array([m.nx])
    iy = np.arange(-1,m.ny+1)
    # Determining python indices such that they are consistent with the script:
    ix_u = ix
    iy_u = iy + 1   # shift due to ghost cell at bottom side of p field in script

    # fill the discretized u-momentum equation to get u*
    us[np.ix_(ix_u,iy_u)] = 0

    iy = np.array([-1])
    ix = np.arange(1,m.nx)
    # Determining python indices such that they are consistent with the script:
    ix_u = ix
    iy_u = iy + 1   # shift due to ghost cell at bottom side of p field in script

    # fill the discretized u-momentum equation to get u*
    us[np.ix_(ix_u,iy_u)] = -us[np.ix_(ix_u,iy_u+1)]

    iy = np.array([m.ny])
    ix = np.arange(1,m.nx)
    # Determining python indices such that they are consistent with the script:
    ix_u = ix
    iy_u = iy + 1   # shift due to ghost cell at bottom side of p field in script

    # fill the discretized u-momentum equation to get u*
    us[np.ix_(ix_u,iy_u)] = 2 - us[np.ix_(ix_u,iy_u-1)]

    ix = np.arange(m.nx) # cycle for vertical component
    iy = np.arange(1,m.ny)

    ix_u = ix
    iy_u = iy + 1   # shift due to ghost cell at bottom side of p field in script
    ix_v = ix + 1   # shift due to ghost cell at left side of p field in script
    iy_v = iy
    ###########################################
    ###############   Task 3.   ###############
    ###########################################
    ix_l = ??
    iy_l = ??
    # Determine squares of mixing lengths at cell boundaries:
    l_M_sq_e = l_M_sq[np.ix_(??,??)]
    l_M_sq_w = l_M_sq[np.ix_(??,??)]
    l_M_sq_n = l_M_sq[np.ix_(??,??)]
    l_M_sq_s = l_M_sq[np.ix_(??,??)]
    # Determine velocity gradients at cell boundaries:
    du_dy_e = ??
    dv_dx_e = ??
    du_dy_w = ??
    dv_dx_w = ??
    dv_dy_n = ??
    dv_dy_s = ??
    # fill the discretized u-momentum equation to get v*
    vs[np.ix_(ix_v,iy_v)]  = (un[np.ix_(ix_u+1,iy_u)] + un[np.ix_(ix_u+1,iy_u-1)]  )*(vn[np.ix_(ix_v+1,iy_v)] + vn[np.ix_(ix_v,iy_v)])
    vs[np.ix_(ix_v,iy_v)] -= (un[np.ix_(ix_u,iy_u)]   + un[np.ix_(ix_u,iy_u-1)]    )*(vn[np.ix_(ix_v-1,iy_v)] + vn[np.ix_(ix_v,iy_v)]) 
    vs[np.ix_(ix_v,iy_v)] /=-(4*m.dx) 
    vs[np.ix_(ix_v,iy_v)] -= ((vn[np.ix_(ix_v,iy_v+1)] + vn[np.ix_(ix_v,iy_v)])**2 - (vn[np.ix_(ix_v,iy_v)] + vn[np.ix_(ix_v,iy_v-1)])**2)/(4*m.dy)
    vs[np.ix_(ix_v,iy_v)] -= (pn[np.ix_(ix,iy)] - pn[np.ix_(ix,iy-1)])/m.dy
    vs[np.ix_(ix_v,iy_v)] += (vn[np.ix_(ix_v+1,iy_v)] - 2*vn[np.ix_(ix_v,iy_v)] + vn[np.ix_(ix_v-1,iy_v)])/(m.dx**2*re)
    vs[np.ix_(ix_v,iy_v)] += (vn[np.ix_(ix_v,iy_v+1)] - 2*vn[np.ix_(ix_v,iy_v)] + vn[np.ix_(ix_v,iy_v-1)])/(m.dy**2*re)
    ###########################################
    ###############   Task 4.   ###############
    ###########################################
    vs[np.ix_(ix_v,iy_v)] += ??
    vs[np.ix_(ix_v,iy_v)] -= ??
    vs[np.ix_(ix_v,iy_v)] += ??
    vs[np.ix_(ix_v,iy_v)] -= ??
    vs[np.ix_(ix_v,iy_v)] *= dt
    vs[np.ix_(ix_v,iy_v)] += vn[np.ix_(ix_v,iy_v)]

    # zero velocity at wall corners!
    # unnecessary block, because us already gets initialized with zeros and it would be sufficient never to change the entries in order to fulfill impermeability of the wall
    iy = np.array([0])
    ix = np.arange(-1,m.nx+1)
    # Determining python indices such that they are consistent with the script:
    ix_v = ix + 1   # shift due to ghost cell at left side of p field in script
    iy_v = iy

    # fill the discretized u-momentum equation to get u*
    vs[np.ix_(ix_v,iy_v)] = 0

    # unnecessary block, because us already gets initialized with zeros and it would be sufficient never to change the entries in order to fulfill impermeability of the wall
    iy = np.array([m.ny])
    ix = np.arange(-1,m.nx+1)
    # Determining python indices such that they are consistent with the script:
    ix_v = ix + 1   # shift due to ghost cell at left side of p field in script
    iy_v = iy

    # fill the discretized u-momentum equation to get u*
    vs[np.ix_(ix_v,iy_v)] = 0

    ix = np.array([-1])
    iy = np.arange(1,m.ny)
    # Determining python indices such that they are consistent with the script:
    ix_v = ix + 1   # shift due to ghost cell at left side of p field in script
    iy_v = iy

    # fill the discretized u-momentum equation to get u*
    vs[np.ix_(ix_v,iy_v)] = -vs[np.ix_(ix_v+1,iy_v)]

    ix = np.array([m.nx])
    iy = np.arange(1,m.ny)
    # Determining python indices such that they are consistent with the script:
    ix_v = ix + 1   # shift due to ghost cell at left side of p field in script
    iy_v = iy

    # fill the discretized u-momentum equation to get u*
    vs[np.ix_(ix_v,iy_v)] = -vs[np.ix_(ix_v-1,iy_v)]

    return us,vs

def get_poisson_matrix(m):

    global A_poisson

    # allocation
    A = np.zeros((m.nx*m.ny,m.nx*m.ny))

    for ii in range(m.nx*m.ny): # cycle over rows of A

        north, south, west, east = m.get_compass(ii) # get indices of neighbouring points
        boundary, _, _, _ = m.is_boundary(ii) # assess whether you are on a boundary

        A[ii, ii] =-2/m.dx**2 - 2/m.dy**2
        # write coefficients corresponding to central differences
        if not boundary:    # entry is somewhere in the center of the field
            A[ii, north] = 1/m.dy**2
            A[ii, south] = 1/m.dy**2
            A[ii, west ] = 1/m.dx**2
            A[ii, east ] = 1/m.dx**2

        else:               # entry is somewhere on a boundary of the field

            if 'n' in boundary: # correct the center part of the stencil
                A[ii, ii] += 1/m.dy**2
            else:    # set the side part of the stencil that has not been set yet
                A[ii, north] = 1/m.dy**2

            if 's' in boundary:
                A[ii, ii] += 1/m.dy**2
            else:
                A[ii, south] = 1/m.dy**2

            if 'w' in boundary:
                A[ii, ii] += 1/m.dx**2
            else:
                A[ii, west] = 1/m.dx**2

            if 'e' in boundary:
                A[ii, ii] += 1/m.dx**2
            else:
                A[ii, east] = 1/m.dx**2
                
    # BC condition for pressure correction:
    ii = 1
    A[ii,:] = 0
    A[ii,ii] = -2/m.dx**2 - 2/m.dy**2

    A_poisson = csc_matrix(A) # update global variable

def solve_poisson(m, us, vs, pc, dt):

    b = np.zeros(m.nx*m.ny)

    for ii in range(len(b)):
        ix, iy = m.get_mat_pos(ii) # get actual indices

        ix_u = ix
        iy_u = iy + 1   # shift due to ghost cell at bottom side of p field in script
        ix_v = ix + 1   # shift due to ghost cell at left side of p field in script
        iy_v = iy
        
        b[ii]  = ((us[ix_u+1,iy_u] - us[ix_u,iy_u])/m.dx)
        b[ii] += ((vs[ix_v,iy_v+1] - vs[ix_v,iy_v])/m.dy)
        b[ii]  /= dt
        
    # BC condition for pressure correction:
    ii = 1
    b[ii] = 0

    # then solve system
    pc1d = spsolve(A_poisson, b)
    
    # make pc 2D again
    pc = pc1d.reshape(m.nx,m.ny)

    return pc
    
def solve_poisson_slice(m, us, vs, pc, dt):

    b = np.zeros(m.nx*m.ny)

    ii = np.arange(len(b))
    ix, iy = m.get_mat_pos(ii) # get actual indices

    ix_u = ix
    iy_u = iy + 1   # shift due to ghost cell at bottom side of p field in script
    ix_v = ix + 1   # shift due to ghost cell at left side of p field in script
    iy_v = iy
    
    b[ii]  = ((us[ix_u+1,iy_u] - us[ix_u,iy_u])/m.dx)
    b[ii] += ((vs[ix_v,iy_v+1] - vs[ix_v,iy_v])/m.dy)
    b[ii]  /= dt
    
    # BC condition for pressure correction:
    ii = 1
    b[ii] = 0

    # then solve system
    pc1d = spsolve(A_poisson, b)
    
    # make pc 2D again
    pc = pc1d.reshape(m.nx,m.ny)

    return pc
