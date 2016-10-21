#
# makefile
#
# NB: you may need to export some of the following
#
# export PETSC_ARCH=linux_64bit_debug
# export PETSC_ARCH=linux_64bit_opt
# export PETSC_DIR=/home/cklaij/ReFRESCO/Dev/trunk/Libs/build/petsc/3.7.3-dbg
#
include ${PETSC_DIR}/lib/petsc/conf/variables
include ${PETSC_DIR}/lib/petsc/conf/rules

laplace: laplace.o   chkopts
	-${FLINKER} -o laplace laplace.o  ${PETSC_KSP_LIB}
	rm laplace.o
