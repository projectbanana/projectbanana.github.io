!----------------------------------------------------------------------------
! M A R I T I M E  R E S E A R C H  I N S T I T U T E  N E T H E R L A N D S
!----------------------------------------------------------------------------
! Copyright (C) 2016 - MARIN - All rights reserved - http://www.marin.nl
!----------------------------------------------------------------------------
! File       : laplace.F90
! Author     : Christiaan M. Klaij
! Date       : July 2012
!              October 2016
! ----------------------------------------------------------------------------
!
! Program to test weak and strong scalability of PETSc solvers for the
! Poisson equation with homogeneous Dirichlet boundary conditions.
!
!----------------------------------------------------------------------------

! examples
! mpiexec -n 1 ./laplace -ksp_view -pc_type hypre -pc_hypre_type boomeramg -ksp_max_it 0
! mpiexec -n 4 ./laplace -nx 500 -ny 200 -nz 100 -pc_type ml -log_summary
!-pc_hypre_boomeramg_relax_type_coarse symmetric-SOR/Jacobi

module laplace

  use petscksp
  use petscdmda
  implicit none
#include "petsc/finclude/petsckspdef.h"
#include "petsc/finclude/petscdmdadef.h"
  private

  PetscErrorCode, public :: ierr
  PetscBool,      public :: flg
  PetscInt,       public :: nx=2, ny=3, nz=4 ! default number of cells in x-, y- and z-direction

  DM  :: dm
  Mat :: A
  Vec :: x, b
  KSP :: ksp
  PC  :: pc 

  PetscScalar :: hx,hy,hz

  ! public routines
  public solveLaplace

contains



  ! solve laplace equation
  subroutine solveLaplace()

    PetscInt          :: its
    character(len=32) :: nb_of_its

    ! grid sizes
    hx=1.0d0/nx; hy=1.0d0/ny; hz=1.0d0/nz

    ! setup matrix and vectors
    call setMatrix()
    call setVectors()

    ! Krylov subspace method
    call KSPCreate(PETSC_COMM_WORLD,ksp,ierr); CHKERRQ(ierr)
    call KSPSetType(ksp,KSPCG,ierr); CHKERRQ(ierr)
    call KSPSetOperators(ksp,A,A,ierr); CHKERRQ(ierr)

    ! Preconditioner
    call KSPGetPC(ksp,pc,ierr); CHKERRQ(ierr)
    call PCSetType(pc,PCBJACOBI,ierr); CHKERRQ(ierr)

    ! solve
    call KSPSetFromOptions(ksp,ierr); CHKERRQ(ierr)
    call KSPSolve(ksp,b,x,ierr); CHKERRQ(ierr)
!    call VecView(x,PETSC_VIEWER_STDOUT_WORLD,ierr); CHKERRQ(ierr)

    ! number of iterations
    call KSPGetIterationNumber(ksp,its,ierr); CHKERRQ(ierr)
    write(nb_of_its,"(A7,I5,A2)") " #its = ", its, "\n"
    call PetscPrintf(PETSC_COMM_WORLD,nb_of_its,ierr); CHKERRQ(ierr)

    ! cleanup
    call cleanup()

  end subroutine solveLaplace



  ! setup N-by-N matrix with N=nx*ny*nz
  subroutine setMatrix()

    PetscInt    :: xs,ys,zs,xm,ym,zm,i,j,k
    PetscScalar :: vals(7)
    MatStencil  :: row(4),cols(4,7)

    call DMDACreate3d(PETSC_COMM_WORLD,DM_BOUNDARY_NONE,DM_BOUNDARY_NONE,DM_BOUNDARY_NONE,DMDA_STENCIL_STAR,nx,ny,nz,PETSC_DECIDE,PETSC_DECIDE,PETSC_DECIDE,1,1,PETSC_NULL_INTEGER,PETSC_NULL_INTEGER,PETSC_NULL_INTEGER,dm,ierr);CHKERRQ(ierr)

    call DMCreateMatrix(dm,A,ierr); CHKERRQ(ierr)

    call DMDAGetCorners(dm,xs,ys,zs,xm,ym,zm,ierr); CHKERRQ(ierr)

    do k=zs,zs+zm-1
       do j=ys,ys+ym-1
          do i=xs,xs+xm-1

             row(MatStencil_i)=i
             row(MatStencil_j)=j
             row(MatStencil_k)=k

             ! set (i-1, i, i+1) part
             if (i.eq.0) then
                cols(MatStencil_i,1)=i;   cols(MatStencil_j,1)=j;   cols(MatStencil_k,1)=k;   vals(1)=+3.0d0*hy*hz/hx
                cols(MatStencil_i,2)=i+1; cols(MatStencil_j,2)=j;   cols(MatStencil_k,2)=k;   vals(2)=      -hy*hz/hx
                call MatSetValuesStencil(A,1,row,2,cols,vals,ADD_VALUES,ierr); CHKERRQ(ierr)
             else if (i.eq.nx-1) then
                cols(MatStencil_i,1)=i-1; cols(MatStencil_j,1)=j;   cols(MatStencil_k,1)=k;   vals(1)=      -hy*hz/hx
                cols(MatStencil_i,2)=i;   cols(MatStencil_j,2)=j;   cols(MatStencil_k,2)=k;   vals(2)=+3.0d0*hy*hz/hx
                call MatSetValuesStencil(A,1,row,2,cols,vals,ADD_VALUES,ierr); CHKERRQ(ierr)
             else
                cols(MatStencil_i,1)=i-1; cols(MatStencil_j,1)=j;   cols(MatStencil_k,1)=k;   vals(1)=      -hy*hz/hx
                cols(MatStencil_i,2)=i;   cols(MatStencil_j,2)=j;   cols(MatStencil_k,2)=k;   vals(2)=+2.0d0*hy*hz/hx
                cols(MatStencil_i,3)=i+1; cols(MatStencil_j,3)=j;   cols(MatStencil_k,3)=k;   vals(3)=      -hy*hz/hx
                call MatSetValuesStencil(A,1,row,3,cols,vals,ADD_VALUES,ierr); CHKERRQ(ierr)
             end if

             ! set (j-1, j, j+1) part
             if (j.eq.0) then
                cols(MatStencil_i,1)=i;   cols(MatStencil_j,1)=j;   cols(MatStencil_k,1)=k;   vals(1)=+3.0d0*hx*hz/hy
                cols(MatStencil_i,2)=i;   cols(MatStencil_j,2)=j+1; cols(MatStencil_k,2)=k;   vals(2)=      -hx*hz/hy
                call MatSetValuesStencil(A,1,row,2,cols,vals,ADD_VALUES,ierr); CHKERRQ(ierr)
             else if (j.eq.ny-1) then
                cols(MatStencil_i,1)=i;   cols(MatStencil_j,1)=j-1; cols(MatStencil_k,1)=k;   vals(1)=      -hx*hz/hy
                cols(MatStencil_i,2)=i;   cols(MatStencil_j,2)=j;   cols(MatStencil_k,2)=k;   vals(2)=+3.0d0*hx*hz/hy
                call MatSetValuesStencil(A,1,row,2,cols,vals,ADD_VALUES,ierr); CHKERRQ(ierr)
             else
                cols(MatStencil_i,1)=i;   cols(MatStencil_j,1)=j-1;  cols(MatStencil_k,1)=k;   vals(1)=      -hx*hz/hy
                cols(MatStencil_i,2)=i;   cols(MatStencil_j,2)=j;    cols(MatStencil_k,2)=k;   vals(2)=+2.0d0*hx*hz/hy
                cols(MatStencil_i,3)=i;   cols(MatStencil_j,3)=j+1;  cols(MatStencil_k,3)=k;   vals(3)=      -hx*hz/hy
                call MatSetValuesStencil(A,1,row,3,cols,vals,ADD_VALUES,ierr); CHKERRQ(ierr)
             end if

             ! set (k-1, k, k+1) part
             if (k.eq.0) then
                cols(MatStencil_i,1)=i;   cols(MatStencil_j,1)=j;   cols(MatStencil_k,1)=k;   vals(1)=+3.0d0*hx*hy/hz
                cols(MatStencil_i,2)=i;   cols(MatStencil_j,2)=j;   cols(MatStencil_k,2)=k+1; vals(2)=      -hx*hy/hz
                call MatSetValuesStencil(A,1,row,2,cols,vals,ADD_VALUES,ierr); CHKERRQ(ierr)
             else if (k.eq.nz-1) then
                cols(MatStencil_i,1)=i;   cols(MatStencil_j,1)=j;   cols(MatStencil_k,1)=k-1; vals(1)=      -hx*hy/hz
                cols(MatStencil_i,2)=i;   cols(MatStencil_j,2)=j;   cols(MatStencil_k,2)=k;   vals(2)=+3.0d0*hx*hy/hz
                call MatSetValuesStencil(A,1,row,2,cols,vals,ADD_VALUES,ierr); CHKERRQ(ierr)
             else
                cols(MatStencil_i,1)=i;   cols(MatStencil_j,1)=j;   cols(MatStencil_k,1)=k-1; vals(1)=      -hx*hy/hz
                cols(MatStencil_i,2)=i;   cols(MatStencil_j,2)=j;   cols(MatStencil_k,2)=k;   vals(2)=+2.0d0*hx*hy/hz
                cols(MatStencil_i,3)=i;   cols(MatStencil_j,3)=j;   cols(MatStencil_k,3)=k+1; vals(3)=      -hx*hy/hz
                call MatSetValuesStencil(A,1,row,3,cols,vals,ADD_VALUES,ierr); CHKERRQ(ierr)
             end if

          end do
       end do
    end do

    call MatAssemblyBegin(A,MAT_FINAL_ASSEMBLY,ierr); CHKERRQ(ierr)
    call MatAssemblyEnd(A,MAT_FINAL_ASSEMBLY,ierr); CHKERRQ(ierr)
!    call viewMatrix() ! *warning* only do this for small matrices
    
  end subroutine setMatrix



  ! save matrix and draw sparsity pattern
  subroutine viewMatrix()

    PetscViewer :: viewer

    ! save matrix
    call PetscViewerASCIIOpen(PETSC_COMM_WORLD,"matrix.m",viewer,ierr); CHKERRQ(ierr)
    call PetscViewerSetFormat(viewer,PETSC_VIEWER_ASCII_MATLAB,ierr); CHKERRQ(ierr)
    call MatView(A,viewer,ierr); CHKERRQ(ierr)

    ! view sparsity pattern (use command line option -draw_pause 10)
    call PetscViewerDrawOpen(PETSC_COMM_WORLD,PETSC_NULL_CHARACTER,PETSC_NULL_CHARACTER,0,0,300,300,viewer,ierr)
    call MatView(A,PETSC_VIEWER_DRAW_WORLD,ierr); CHKERRQ(ierr)
    call PetscViewerDestroy(viewer,ierr); CHKERRQ(ierr)

  end subroutine viewMatrix



  ! setup solution and rhs vectors
  subroutine setVectors()

    PetscInt             :: xs,ys,zs,xm,ym,zm,i,j,k
    PetscScalar          :: xc,yc,zc
    PetscScalar, pointer :: x3(:,:,:)

    call DMCreateGlobalVector(dm,x,ierr); CHKERRQ(IERR)

    call DMDAGetCorners(dm,xs,ys,zs,xm,ym,zm,ierr); CHKERRQ(ierr)

    call DMDAVecGetArrayF90(dm,x,x3,ierr); CHKERRQ(ierr)
    do k=zs,zs+zm-1
       do j=ys,ys+ym-1
          do i=xs,xs+xm-1

             xc=(i+0.5d0)*hx; yc=(j+0.5d0)*hy; zc=(k+0.5d0)*hz
             x3(i,j,k)=sin(xc*yc*zc)

          end do
       end do
    end do
    call DMDAVecRestoreArrayF90(dm,x,x3,ierr); CHKERRQ(ierr)
!    call VecView(x,PETSC_VIEWER_STDOUT_WORLD,ierr); CHKERRQ(ierr)

    ! rhs vector b
    call VecDuplicate(x,b,ierr); CHKERRQ(ierr)
    call MatMult(A,x,b,ierr); CHKERRQ(ierr)
!    call VecView(b,PETSC_VIEWER_STDOUT_WORLD,ierr); CHKERRQ(ierr);

  end subroutine setVectors



  subroutine cleanup()
    call VecDestroy(x,ierr); CHKERRQ(ierr)
    call VecDestroy(b,ierr); CHKERRQ(ierr)
    call MatDestroy(A,ierr); CHKERRQ(ierr)
    call KSPDestroy(ksp,ierr); CHKERRQ(ierr)
    call DMDestroy(dm,ierr); CHKERRQ(ierr)
  end subroutine cleanup




end module laplace



program testLaplace

  use laplace
  use petscksp
  implicit none
#include "petsc/finclude/petsckspdef.h"

  character(len=32) :: gridsize

  call PetscInitialize(PETSC_NULL_CHARACTER,ierr); CHKERRQ(ierr)

  ! overrule default number of cells by command line options 
  call PetscOptionsGetInt(PETSC_NULL_OBJECT,PETSC_NULL_CHARACTER,'-nx',nx,flg,ierr); CHKERRQ(ierr)
  call PetscOptionsGetInt(PETSC_NULL_OBJECT,PETSC_NULL_CHARACTER,'-ny',ny,flg,ierr); CHKERRQ(ierr)
  call PetscOptionsGetInt(PETSC_NULL_OBJECT,PETSC_NULL_CHARACTER,'-nz',nz,flg,ierr); CHKERRQ(ierr)
  write(gridsize,"(3(A6,I4),A2)") " nx = ", nx, ", ny = ", ny, ", nz = ", nz, "\n"
  call PetscPrintf(PETSC_COMM_WORLD,gridsize,ierr); CHKERRQ(ierr)

  call solveLaplace()

  call PetscFinalize(ierr);CHKERRQ(ierr)

end program testLaplace
