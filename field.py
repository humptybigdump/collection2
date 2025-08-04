import numpy as np
import pyfftw
import multiprocessing
from copy import deepcopy

class Field(object):
    def __init__(self, cpx_field, shape, ndim=6, notation='voigt'):

        self.shape = shape
        self.size = np.prod(shape)
        self.cpx_field = cpx_field
        Nx, Ny, Nz = self.shape
        # self.real_field is just a real-valued "view" onto the complex data for easier handling
        # Dimension of the basic field quantity - 6 for symmetric 3x3 matrices such as strains and stresses, 3 for vectors, such as temp gradient and heat flux
        self.real_field = np.ndarray(shape=(ndim, Nx, Ny, Nz), dtype=np.float64, buffer=cpx_field.data)

        self.ndim = ndim
        # Save the notation type ('voigt' or 'mandel') for switching
        self.notation = notation
        self.notation_factor = 1 if notation == 'voigt' else 2
        # Number of used threads
        threadCount = multiprocessing.cpu_count()

        # FFTW creates an optimal 'plan' for the FFT
        self.fftPlans = pyfftw.FFTW(self.real_field, self.cpx_field,
                                    axes=(1, 2, 3),
                                    threads=threadCount)

        # Same for the inverse FFT
        self.ifftPlans = pyfftw.FFTW(self.cpx_field, self.real_field,
                                     direction='FFTW_BACKWARD',
                                     axes=(1, 2, 3),
                                     threads=threadCount)
        self.status = 'real'

    @classmethod
    def empty_from_shape(cls, shape, ndim=6, notation='voigt'):

        Nx, Ny, Nz = shape
        # Initialization of the complex field
        # FFTW (our chosen FFT package) is able to work 'inplace'
        # Hence we put the (slightly smaller) real field in the same memory as the complex field
        # Effectively the same memory can be read/written as real or complex numbers

        # The arrays are 4-dimensional. The first dimension gives you the component of the field quantity (e.g., the strain)
        # The remaining quantities are associated with the coordinates of the voxel (real field) or the frequency (complex field)
        # Example: real_field[:,2,3,4] gives you the 6 components at (2,3,4)

        # self.cpx_field is where the data is actually stored
        cpx_field = pyfftw.zeros_aligned((ndim, Nx, Ny, Nz // 2 + 1),
                                         dtype=np.complex128)

        return cls(cpx_field, shape, ndim=ndim, notation=notation)

    @classmethod
    def from_colors(cls, colors, ndim=6, notation='voigt'):

        # Dimensions of the microstructure
        return cls.empty_from_shape(colors.shape, ndim=ndim, notation=notation)

    @classmethod
    def copy(cls, field):
        return cls(deepcopy(field.cpx_field), field.shape, ndim=field.ndim, notation=field.notation)

    def __mul__(self, multiplier):
        assert isinstance(multiplier, (int, float, complex))
        # Out of place!
        return Field(multiplier*self.cpx_field, shape=self.shape, ndim=self.ndim, notation=self.notation)

    def __rmul__(self, multiplier):
        return self.__mul__(multiplier)

    def __add__(self, other):
        # Out of place!
        assert isinstance(other, Field)
        assert self.shape == other.shape
        assert self.notation == other.notation
        return Field(self.cpx_field+other.cpx_field, shape=self.shape, ndim=self.ndim, notation=self.notation)

    def __sub__(self, other):
        # Out of place!
        return self.__add__(-1*other)

    def __getitem__(self, key):
        if self.status == 'real':
            return self.real_field[key]
        else:
            return self.cpx_field[key]

    def __setitem__(self, key, data):
        if self.status == 'real':
            self.real_field[key] = data
        else:
            self.cpx_field[key] = data

    def l2_norm_strain(self, factor=1):
        direct = np.linalg.norm(self.real_field[:3,...])**2
        shear = np.linalg.norm(1/self.notation_factor*self.real_field[3:,...])**2
        return np.sqrt(factor/self.size*(direct+shear))


    def initialize(self, strain):
        for i in range(self.ndim):
            self.real_field[i, ...] = strain[i]

    # Methods to apply the FFT and IFFT
    # In Fourier space the cpx_field should be accessed (e.g., for applying the Gamma^0 operator)
    # In real space the real_field should be accessed -> see self.status for current status

    def fft(self):
        assert self.status == 'real'
        self.fftPlans()
        self.status = 'fourier'

    def ifft(self):
        assert self.status == 'fourier'
        self.ifftPlans()
        self.status = 'real'
