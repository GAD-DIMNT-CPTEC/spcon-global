      SUBROUTINE PERTUR(RPP,RPT,RPU,RPV,RPQ,IMAX,JMAX,KMAX,IDUM,
     *STDP,STDT,STDU,STDV,STDQ)
C*
      INTEGER IMAX,JMAX,KMAX,IDUM
      REAL RPP(IMAX,JMAX),RPT(IMAX,JMAX,KMAX),RPU(IMAX,JMAX,KMAX),
     *     RPV(IMAX,JMAX,KMAX),RPQ(IMAX,JMAX,KMAX),
     *     STDP,STDT(KMAX),STDU(KMAX),STDV(KMAX),STDQ(KMAX)
C*
      INTEGER I,J,K
      REAL GASDEV,TMEAN,TMIN,TMAX,TMN,TSIG,
     *            UMEAN,UMIN,UMAX,UMN,USIG,
     *            VMEAN,VMIN,VMAX,VMN,VSIG,
     *            QMEAN,QMIN,QMAX,QMN,QSIG
     *            PMEAN,PMIN,PMAX,PMN,PSIG
C*
      WRITE(66,'(/,A,I6)')' IDUM=',IDUM
      WRITE(66,'(/,A5,4A12)')'  LEV',' MIN    ',' MAX    ',
     *                       ' MEAN    ',' ST.DEV    '
C*
C*    GENERATE A SEQUENCE OF GAUSSIAN-TYPED
C*    RANDOM PERTURBATIONS
C*
      PMEAN=0.0
      TMEAN=0.0
      UMEAN=0.0
      VMEAN=0.0
      QMEAN=0.0
      DO K=1,KMAX
      DO J=1,JMAX
      DO I=1,IMAX
      IF (K .EQ. 1) THEN
      RPP(I,J)=PMEAN+SQRT(STDP)*GASDEV(IDUM)
      ENDIF
      RPT(I,J,K)=TMEAN+SQRT(STDT(K))*GASDEV(IDUM)
      RPU(I,J,K)=UMEAN+SQRT(STDU(K))*GASDEV(IDUM)
      RPV(I,J,K)=VMEAN+SQRT(STDV(K))*GASDEV(IDUM)
      RPQ(I,J,K)=QMEAN+STDQ(K)*GASDEV(IDUM)/1000
      ENDDO
      ENDDO
      ENDDO
C*
      CALL VARAVE(RPP(1,1),IMAX*JMAX,TMIN,TMAX,TMN,TSIG)
      WRITE(66,'(1P4G12.5)') TMIN,TMAX,TMN,TSIG
      DO K=1,KMAX
      CALL VARAVE(RPT(1,1,K),IMAX*JMAX,TMIN,TMAX,TMN,TSIG)
      CALL VARAVE(RPU(1,1,K),IMAX*JMAX,UMIN,UMAX,UMN,USIG)
      CALL VARAVE(RPV(1,1,K),IMAX*JMAX,VMIN,VMAX,VMN,VSIG)
      CALL VARAVE(RPQ(1,1,K),IMAX*JMAX,QMIN,QMAX,QMN,QSIG)
      WRITE(66,'(I5,1P4G12.5)') K,TMIN,TMAX,TMN,TSIG
      WRITE(66,'(I5,1P4G12.5)') K,UMIN,UMAX,UMN,USIG
      WRITE(66,'(I5,1P4G12.5)') K,VMIN,VMAX,VMN,VSIG
      WRITE(66,'(I5,1P4G12.5)') K,QMIN,QMAX,QMN,QSIG
      ENDDO
C*
      RETURN
      END
