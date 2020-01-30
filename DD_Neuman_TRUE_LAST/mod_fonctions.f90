!---------------------------------------------
!    CE MODULE CONTIENT LES FONCTIONS
!     DES TERMES SOURCES DE L'EQUATION
!---------------------------------------------

Module mod_fonctions
!---modules-------------------
  use mod_parametres
!-----------------------------
  Implicit None

Contains

!---fonction f premier exemple(terme source)---
Function f1(CT,x,y,t)
  Integer, Intent(In) :: CT
  Real(PR), Intent(In) :: x,y,t
  Real(PR) :: f1
  If (CT==1) Then
    f1=2._PR*(y*(1._PR-y)+x*(1._PR-x))
  Else IF (CT==2) Then
    f1=sin(x)+cos(y)
  Else If (CT==3) Then
    f1=exp(-((x-(Lx/2._PR))**2._PR))*exp(-((y-(Ly/2._PR))**2._PR))&
                                            *cos((pi/2._PR)*t)                                          
  End If

End Function f1
!----------------------------------------------

!---fonction g premier exemple( bords haut/bas)-
Function g1(CT,x,y,t)
  Integer, Intent(In) :: CT
  Real(PR), Intent(In) :: x,y,t
  Real(PR) :: g1
  If (CT==1) Then
    g1=0._PR
  Else IF (CT==2) Then
    g1=sin(x)+cos(y)
  Else If (CT==3) Then
    g1=0._PR
  End If
End Function g1
!----------------------------------------------

!---function h premier exemple(bord gauche/droite)
Function h1(CT,x,y,t)
  Integer, Intent(In) :: CT
  Real(PR), Intent(In) :: x,y,t
  Real(PR) :: h1
  If (CT==1) Then
    h1=0._PR
  Else IF (CT==2) Then
    h1=sin(x)+cos(y)
  Else If (CT==3) Then
    h1=1._PR
  End If
End Function h1
!---Fonctions donnant les vecteurs Xi,Yj,Tn---------------


Subroutine param(X,Y,T)
  Implicit None
  !---variables------------------------- 
  real(PR), Dimension(:), Allocatable, Intent(InOut)  :: X
  real(PR), Dimension(:), Allocatable, Intent(InOut)  :: Y
  real(PR), Dimension(:), Allocatable, Intent(InOut)  :: T
  Integer :: i
  !-------------------------------------
  ALLOCATE(Y(0:Ny_g+1),T(0:Nt+1),X(0:Nx_g+1))
  Do i=0,Ny_g+1
     Y(i)=i*dy
  End Do
  Do i=0,Nt+1
     T(i)=i*nt
  End Do
  DO i=0,Nx_g+1
     X(i)=i*dx
  END DO

  !SET VARIABLES SIZE USED MANY TIMES
  !FOR x VECTOR:
  LBX = lbound(X,1)     ;  UBX = ubound(X,1)
  !FOR UD AND UG VECTORS TO RECV:
  LBUD =  itN+1-2*Ny_g  ;  UBUD = itN
  LBUG =  it1           ;  UBUG = it1-1+2*Ny_g
  !FOR VECTOR SIZE TO SEND:
  A = (itN - 2*overlap*Ny_g) +1; B = A + 2*Ny_g -1
  DD = (it1 + 2*overlap*Ny_g) -1; C = DD - 2*Ny_g +1 

 
End Subroutine param

Subroutine param_para(rang,Np,S1,S2,Ny_l,X,Y,T)
  Implicit None
  !---variables-------------------------
  Integer, Intent(IN)  :: rang, Np, S1, S2, Ny_l 
  real(PR), Dimension(:), Allocatable, Intent(InOut)  :: X
  real(PR), Dimension(:), Allocatable, Intent(InOut)  :: Y
  real(PR), Dimension(:), Allocatable, Intent(InOut) :: T
  Integer :: i
  !-------------------------------------
  ALLOCATE(Y(0:Ny_l+1),T(0:Nt+1))
  Do i=0,Ny_l+1
     Y(i)=i*dy
  End Do
  Do i=0,Nt+1
     T(i)=i*nt
  End Do
  IF(rang == 0)THEN
     ALLOCATE(X(S1-1:S2))
     Do i=S1-1,S2
        X(i)=i*dx
     End Do
  ELSE IF(rang == Np-1)THEN
     ALLOCATE(X(S1:S2+1))
     DO i=S1,S2+1
        X(i)=i*dx
     END DO
  ELSE
     ALLOCATE(X(S1:S2))
     DO i=S1,S2
        X(i)=i*dx
     END DO
  END IF
  !SET VARIABLES SIZE USED MANY TIMES
  !FOR x VECTOR:
  LBX = lbound(X,1)     ;  UBX = ubound(X,1)
  !FOR UD AND UG VECTORS TO RECV:
  LBUD =  itN+1-2*Ny_g  ;  UBUD = itN
  LBUG =  it1           ;  UBUG = it1-1+2*Ny_g
  !FOR VECTOR SIZE TO SEND:
  A = (itN - 2*overlap*Ny_g) +1; B = A + 2*Ny_g -1
  DD = (it1 + 2*overlap*Ny_g) -1; C = DD - 2*Ny_g +1 
End Subroutine param_para
!-------------------------------------------------------------

















End Module mod_fonctions