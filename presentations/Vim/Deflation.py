# imagine that the cursor is in the constructor method
# of the Deflated operator class and you want to include a missing package
# at the top of the file
# possible solution
# IyBebW15eTNnZ3A6bGVmdF5NYG1kJAo=
import time
from numpy import result_type
from scipy.linalg import inv
from scipy.sparse.linalg import LinearOperator

__all__ = ['DeflationOperator', 'DeflatedOperator']

class DeflationOperator(LinearOperator):
    def __init__(self, A, Z):
        super().__init__(shape = A.shape, dtype = result_type(A.dtype, Z.dtype))
        self.Z = Z
        self.A = lambda x : A.dot(x)
        self.Ei = inv(self.Z.T.dot(A.dot(Z)))
        self.Q = lambda x : self.Z.dot(self.Ei.dot(self.Z.T.dot(x)))
        self.PT = lambda x : x - self.Q(self.A(x))

    def _matvec(self, x):
        return (x - self.A(self.Q(x)))

    def projectback(self, b, x):
        return self.Q(b) + self.PT(x)

class DeflatedOperator(LinearOperator):
    def __init__(self, A, Z):
        super().__init__(shape = A.shape, dtype = result_type(A.dtype, Z.dtype))
        self.P = DeflationOperator(A, Z)
        self.A = A


    def _matvec(self, x):
        return self.P.matvec(self.A.dot(x))
