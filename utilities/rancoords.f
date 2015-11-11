      PROGRAM RANCOORD
      IMPLICIT NONE
      INTEGER NATOMS, J1, SEED
      DOUBLE PRECISION RADIUS, X, Y, Z, SR3, RANDOM, RAN1
      EXTERNAL RAN1
      LOGICAL TEST
      
      SR3=DSQRT(3.0D0)
      INQUIRE(FILE='randata',EXIST=TEST)
      IF (TEST) THEN
         OPEN(UNIT=8,FILE='randata',STATUS='OLD')
         READ(8,*) NATOMS, RADIUS, SEED
      ELSE
         PRINT*,'Number of atoms?'
         READ(*,*) NATOMS
         PRINT*,'Container radius?'
         READ(*,*) RADIUS
         PRINT*,'Seed?'
         READ(*,*) SEED
      ENDIF
      IF (SEED.GT.0) SEED=-SEED
      RANDOM=RAN1(SEED)

      OPEN(UNIT=7,FILE='newcoords',STATUS='UNKNOWN')
      DO J1=1,NATOMS
         RANDOM=RAN1(SEED)
         X=RANDOM*RADIUS/SR3
         RANDOM=RAN1(SEED)
         Y=RANDOM*RADIUS/SR3
         RANDOM=RAN1(SEED)
         Z=RANDOM*RADIUS/SR3
         WRITE(7,10) X, Y, Z
10       FORMAT(3F20.10)
      ENDDO

      STOP
      END

      FUNCTION ran1(idum)
      INTEGER idum,IA,IM,IQ,IR,NTAB,NDIV
      DOUBLE PRECISION ran1,AM,EPS,RNMX
      PARAMETER (IA=16807,IM=2147483647,AM=1.d0/IM,IQ=127773,IR=2836,
     *NTAB=32,NDIV=1+(IM-1)/NTAB,EPS=1.2d-7,RNMX=1.d0-EPS)
      INTEGER j,k,iv(NTAB),iy
      SAVE iv,iy
      DATA iv /NTAB*0/, iy /0/
      if (idum.le.0.or.iy.eq.0) then
        idum=max(-idum,1)
        do 11 j=NTAB+8,1,-1
          k=idum/IQ
          idum=IA*(idum-k*IQ)-IR*k
          if (idum.lt.0) idum=idum+IM
          if (j.le.NTAB) iv(j)=idum
11      continue
        iy=iv(1)
      endif
      k=idum/IQ
      idum=IA*(idum-k*IQ)-IR*k
      if (idum.lt.0) idum=idum+IM
      j=1+iy/NDIV
      iy=iv(j)
      iv(j)=idum
      ran1=2.0D0*min(AM*iy,RNMX)-1.0D0
      return
      END
C  (C) Copr. 1986-92 Numerical Recipes Software 1(-V%'2150)-3.
