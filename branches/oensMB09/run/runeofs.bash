#!/bin/bash
#help#
#******************************************************************#
#                                                                  #
#     Name:           runeofs.sx6                                  #
#                                                                  #
#     Function:       This script submits the                      #
#                     temperature and wind eof                     #
#                                                                  #
#                     It runs in Korn Shell.                       #
#                                                                  #
#     Date:           June      02th, 2003.                        #
#     Last change:    June      02th, 2003.                        #
#                                                                  #
#     Valid Arguments for runeofs.sx6                              #
#                                                                  #
#     First  :   HELP: help or nothing for getting help            #
#     First  :COMPILE: help, make, clean or run                    #
#     Second :    TRC: three-digit triangular truncation           #
#     Third  :     LV: two-digit number of vertical sigma-layers   #
#     Fourth :  HUMID: YES or NO (humidity will be perturbed)      #
#     Fifth  :    NUM: pertubation number                          #
#     Sixth  : LABELI: initial forecasting label                   #
#     Seventh: NFDAYS: number of forecasting days                  #
#     Eigth  :NUMPERT: number of random perturbations              #
#     hold   :Total  : number of random perturbations              #
#                                                                  #
#              LABELx: yyyymmddhh                                  #
#                      yyyy = four digit year                      #
#                      mm = two digit month                        #
#                      dd = two digit day                          #
#                      hh = two digit hour                         #
#                                                                  #
#******************************************************************#
#help#
#
#       Help:
#
if [ "${1}" = "help" -o -z "${1}" ]
then
cat < $0 | sed -n '/^#help#/,/^#help#/p'
exit 0
fi
#
#       Test of Valid Arguments
#
if [ "${1}" != "run" ]
then
if [ "${1}" != "make" ]
then
if [ "${1}" != "clean" ]
then
echo "First argument: ${1}, is wrong. Must be: make, clean or run"
exit
fi
fi
fi
if [ -z "${2}" ]
then
echo "Second argument is not set (TRC)"
exit
else
export TRC=`echo ${2} | awk '{print $1/1}'`
fi
if [ -z "${3}" ]
then
echo "Third argument is not set (LV)"
exit
else
export LV=`echo ${3} | awk '{print $1/1}'` 
fi
if [ -z "${4}" ]
then
echo "Fourth argument is not set (HUMID)"
exit
else
HUMID=${4}
fi
if [ "${1}" = "run" ]
then
if [ -z "${5}" ]
then
echo "Fifth argument is not set (NUM)"
exit
else
PERR=${5}
fi
if [ -z "${6}" ]
then
echo "Sixth argument is not set (LABELI: yyyymmddhh)"
exit
fi
if [ -z "${7}" ]
then
echo "Seventh argument is not set (NFDAYS)"
exit
else
NFDAYS=${7}
fi
if [ -z "${8}" ]
then
echo "Eigth argument is not set (NUMPERT)"
exit
else
NUMPERT=${8}
fi
fi
if [ "$#" == 9 ]
then 
  export hold=${9}  
else 
  export hold=""
fi
echo $hold
#
#   Set machine, Run time and Extention
#
CASE=`echo ${TRC} ${LV} |awk '{ printf("TQ%4.4dL%3.3d\n",$1,$2)  }' `
HSTMAQ=`hostname`
export MACHINE=bash
#export QUEUE=PNT-EN
RUNTM=`date +'%Y'``date +'%m'``date +'%d'``date +'%H:%M'`
EXT=out
echo ${MACHINE}
echo ${RUNTM}
echo ${EXT}
#
#   Set directories
#
#   OPERM  is the directory for sources, scripts and printouts.
#   SOPERM is the directory for input and output files.
#   ROPERM is the directory for big selected output files.
#   IOPERM is the directory for the input files.
#
PATHA=`pwd`
export FILEENV=`find ${PATHA} -name EnvironmentalVariablesMCGA -print`
export PATHENV=`dirname ${FILEENV}`
export PATHBASE=`cd ${PATHENV};cd ../;pwd`
. ${FILEENV} ${CASE} ${5}R
cd ${HOME_suite}/run
echo ${OPERM}
echo ${SOPERM}
echo ${ROPERM}
echo ${IOPERM}
#
#   Set truncation and layers
#
export RESOL=`echo ${TRC} |awk '{ printf("TQ%4.4d\n",$1)  }' `
export NIVEL=`echo ${LV} |awk '{ printf("L%3.3d\n",$1)  }' `
export TRUNC=`echo ${TRC} |awk '{ printf("TQ%4.4d\n",$1)  }' `
export LEV=`echo ${LV} |awk '{ printf("L%3.3d\n",$1)  }' `

export RESOL NIVEL
export NFDAYS

for arq in \`ls ${ROPERM}/model/datain/GFCT[0C]?R${LABELI}*\`
do
      ln -sf \$arq ${ROPERM}/recfct/dataout/${TRUNC}${LEV}/
done

#
case ${TRC} in
21) MR=21 ; IR=64 ; JR=32 ; JI=11 ; JS=24 ; NJ=14 ;
     case ${LV} in
     09) KR=09 ; LR=11 ;;
     18) KR=18 ; LR=11 ;;
     28) KR=28 ; LR=17 ;;
     42) KR=42 ; LR=18 ;;
     *) echo "Wrong request for vertical resolution: ${LV}" ; exit 1 ;;
     esac
;;
30) MR=30 ; IR=96 ; JR=48 ; JI=16 ; JS=36 ; NJ=21 ;
     case ${LV} in
     09) KR=09 ; LR=11 ;;
     18) KR=18 ; LR=13 ;;
     28) KR=28 ; LR=17 ;;
     42) KR=42 ; LR=18 ;;
     *) echo "Wrong request for vertical resolution: ${LV}" ; exit 1 ;;
     esac
;;
42) MR=42 ; IR=128 ; JR=64 ; JI=22 ; JS=48 ; NJ=27 ;
     case ${LV} in
     09) KR=09 ; LR=11 ;;
     18) KR=18 ; LR=11 ;;
     28) KR=28 ; LR=11 ;;
     42) KR=42 ; LR=18 ;;
     *) echo "Wrong request for vertical resolution: ${LV}" ; exit 1 ;;
     esac
;;
47) MR=47 ; IR=144 ; JR=72 ; JI=24 ; JS=54 ; NJ=31 ;
     case ${LV} in
     09) KR=09 ; LR=11 ;;
     18) KR=18 ; LR=13 ;;
     28) KR=28 ; LR=17 ;;
     42) KR=42 ; LR=18 ;;
     *) echo "Wrong request for vertical resolution: ${LV}" ; exit 1 ;;
     esac
;;
62) MR=62 ; IR=192 ; JR=96 ; JI=32 ; JS=72 ; NJ=41 ;
     case ${LV} in
     09) KR=09 ; LR=11 ;;
     18) KR=18 ; LR=11 ;;
     28) KR=28 ; LR=11 ;;
     42) KR=42 ; LR=18 ;;
     *) echo "Wrong request for vertical resolution: ${LV}" ; exit 1 ;;
     esac
;;
79) MR=79 ; IR=240 ; JR=120 ; JI=40 ; JS=90 ; NJ=51 ;
     case ${LV} in
     09) KR=09 ; LR=11 ;;
     18) KR=18 ; LR=13 ;;
     28) KR=28 ; LR=17 ;;
     42) KR=42 ; LR=18 ;;
     *) echo "Wrong request for vertical resolution: ${LV}" ; exit 1 ;;
     esac
;;
95) MR=95 ; IR=288 ; JR=144 ; JI=48 ; JS=108 ; NJ=61 ;
     case ${LV} in
     09) KR=09 ; LR=11 ;;
     18) KR=18 ; LR=13 ;;
     28) KR=28 ; LR=17 ;;
     42) KR=42 ; LR=18 ;;
     *) echo "Wrong request for vertical resolution: ${LV}" ; exit 1 ;;
     esac
;;
106) MR=106 ; IR=320 ; JR=160 ; JI=54 ; JS=120 ; NJ=67 ;
     case ${LV} in
     09) KR=09 ; LR=11 ;;
     18) KR=18 ; LR=13 ;;
     28) KR=28 ; LR=17 ;;
     42) KR=42 ; LR=18 ;;
     *) echo "Wrong request for vertical resolution: ${LV}" ; exit 1 ;;
     esac
;;
126) MR=126 ; IR=384 ; JR=192 ; JI=64 ; JS=145 ; NJ=82 ;
     case ${LV} in
     09) KR=09 ; LR=11 ;;
     18) KR=18 ; LR=11 ;;
     28) KR=28 ; LR=11 ;;
     42) KR=42 ; LR=11 ;;
     *) echo "Wrong request for vertical resolution: ${LV}" ; exit 1 ;;
     esac
;;
159) MR=159 ; IR=480 ; JR=240 ; JI=80 ; JS=180 ; NJ=101 ;
     case ${LV} in
     09) KR=09 ; LR=11 ;;
     18) KR=18 ; LR=13 ;;
     28) KR=28 ; LR=17 ;;
     42) KR=42 ; LR=18 ;;
     *) echo "Wrong request for vertical resolution: ${LV}" ; exit 1 ;;
     esac
;;
170) MR=170 ; IR=512 ; JR=256 ; JI=86 ; JS=192 ; NJ=107
     case ${LV} in
     09) KR=09 ; LR=11 ;;
     18) KR=18 ; LR=13 ;;
     28) KR=28 ; LR=17 ;;
     42) KR=42 ; LR=18 ;;
     *) echo "Wrong request for vertical resolution: ${LV}" ; exit 1 ;;
     esac
;;
213) MR=213 ; IR=640 ; JR=320 ; JI=107 ; JS=240 ; NJ=134 ;
     case ${LV} in
     09) KR=09 ; LR=11 ;;
     18) KR=18 ; LR=13 ;;
     28) KR=28 ; LR=17 ;;
     42) KR=42 ; LR=18 ;;
     *) echo "Wrong request for vertical resolution: ${LV}" ; exit 1 ;;
     esac
;;
319) MR=319 ; IR=960 ; JR=480 ; JI=160 ; JS=360 ; NJ=201 ;
     case ${LV} in
     09) KR=09 ; LR=11 ;;
     18) KR=18 ; LR=13 ;;
     28) KR=28 ; LR=17 ;;
     42) KR=42 ; LR=18 ;;
     *) echo "Wrong request for vertical resolution: ${LV}" ; exit 1 ;;
     esac
;;
*) echo "Wrong request for horizontal resolution: ${TRC}" ; exit 1;
esac
#
#
cd ${OPERM}/run
#
mkdir -p ${ROPERM}/eof/output
SCRIPTNAME=seteofs.1.${PERR}${RESOL}${NIVEL}.${LABELI}.${MACHINE}
cat <<EOT0 > ${OPERM}/run/${SCRIPTNAME}
#!/bin/bash -x
#
#************************************************************#
#                                                            #
#     Name:        seteofs${PERR}${RESOL}${NIVEL}.${MACHINE} #
#                                                            #
#************************************************************#
#
#PBS -o ${HSTMAQ}:${ROPERM}/eof/output/seteofs.${PERR}.${LABELI}.${RUNTM}.${EXT}
#PBS -j oe
#PBS -l walltime=4:00:00
######PBS -l mppwidth=1
#PBS -l mppnppn=1
#PBS -A CPTEC
#PBS -V
#PBS -S /bin/bash
#PBS -N ENSEOFS${NUM}
#PBS -q ${AUX_QUEUE}

export PBS_SERVER=aux20-eth4

#
#
#   Set date (year,month,day) and hour (hour:minute) 
#
#   DATE=yyyymmdd
#   HOUR=hh:mn
#
#
#ulimit -d 524288
#
#  Set number of perturbation
#

export PATH=".:/usr/local/sxbin:~/bin:/usr/local/nec/tools:/usr/psuite:/SX/usr/bin:$PATH"

NUM=${5}
echo \${NUM}
export NUM
TRUNC=${RESOL}
LEV=${NIVEL}
export TRUNC LEV
#
#
#  Set labels (date, UTC hour, ...)
#
DATE=`date +'%Y'``date +'%m'``date +'%d'`
HOUR=`date +'%H:%M'`
echo 'Date: '\$DATE
echo 'Hour: '\$HOUR
export DATE HOUR
#
#   LABELI = yyyymmddhh
#   LABELI = input file start label
LABELI=${6}
echo \${LABELI}
export LABELI
#
#   Set directories
#
#   OPERMOD  is the directory for sources, scripts and
#            printouts files.
#   SOPERMOD is the directory for input and output data
#            and bin files.
#   ROPERMOD is the directory for big selected output files.
#   IOPERMOD is the directory for input file.
#
OPERMOD=${OPERM}
SOPERMOD=${SOPERM}
ROPERMOD=${ROPERM}
IOPERMOD=${IOPERM}
ANLDATAPREFIX=${PREFIXANLDATA}
export OPERMOD SOPERMOD ROPERMOD IOPERMOD
echo \${OPERMOD}
echo \${SOPERMOD}
echo \${ROPERMOD}
echo \${IOPERMOD}
echo \${ANLDATAPREFIX}
#
cd ${HOME_suite}/run
#
#   Set Horizontal Truncation and Vertical Layers
#
#   Set machine
MACH=${MACHINE}
export MACH
#
#   Set option for compiling or not the source codes.
#
#   If COMPILE=make then only the modified sources will be compiled.
#   If COMPILE=clean then the touch files will be removed and 
#              all sources will be compiled.
#             =run for run with no compilation
#
#   If COMPILE is make or clean then the script generates the binary file 
#              and exits;
#              if it is run then the script runs the existent binary file.
#
echo ${1}
export COMPILE=${1}
echo \${COMPILE}
export COMPILE
#
#   Set FORTRAN compilation flags
#
#   -integer_size 64 sets the integer basic numeric size to 8 bytes
#   -real_size 64    sets the real basic numeric size to 8 bytes
#
#
#FTNFLAG='-C vsafe -float0 -ew -Wf" -pvctl noaltcode nomatmul -O nodiv nomove " '
#CHWFLAG='-C vsafe -float0 -ew -Wf" -pvctl noaltcode nomatmul -O nodiv nomove " '
#FTNFLAG='  -h byteswapio -s real64  -s integer64 '
#CHWFLAG='  -h byteswapio -s real64  -s integer64 '
FTNFLAG='  -byteswapio -i8 -r8 '
CHWFLAG='  -byteswapio -i8 -r8 '

export FTNFLAG CHWFLAG
#
#   Set C pre-processing flags
#
INC=\${OPERMOD}/include/${RESOL}${NIVEL}
CPP=" -I\${INC}"
export INC CPP
#
#   Set FORTRAN compiler name
#
#F77="sxf90 -V -float0 -ew "
F77="ftn  "
export F77
#
#   Set FORTRAN environment file name
#
#   $FFFn is associated with FORTRAN file unit = n
#
#FFF=FORT
#export FFF
#
#   Set environmental variables to binary conversion
#
#FORT_CONVERT10=BIG_ENDIAN
#FORT_CONVERT20=BIG_ENDIAN
#export FORT_CONVERT10 FORT_CONVERT20
#
F_UFMTIEEE=10,11,20,62,64,68,69,72,74
#AMM F_UFMTADJUST=TYPE2
#AMM export F_UFMTIEEE F_UFMTADJUST
export F_UFMTIEEE
#  Now, build the necessary INCLUDE for the choosen truncation and 
#       vertical resolution.. 
#
  if [ "\${COMPILE}" != "run" ]
  then
#
cd \${INC}
#
cat <<EOT > recanl.n
      INTEGER IMAX,JMAX,MEND,KMAX,LMAX
      PARAMETER (IMAX=${IR},JMAX=${JR},MEND=${MR},KMAX=${KR},LMAX=${LR})
EOT
if (diff recanl.n recanl.h > /dev/null)
then
    echo "recanl.n and recanl.h are the same"
    rm -f recanl.n
else
    echo "recanl.n and recanl.h are different"
    mv recanl.n recanl.h
fi
cat <<EOT > reseofes.n
      INTEGER IMAX,JMAX,MEND,KMAX,LMAX,JINF,JSUP,JMAX0
      PARAMETER (IMAX=${IR},JINF=${JI},JSUP=${JS},JMAX=${JR})
      PARAMETER (JMAX0=${NJ},MEND=${MR},KMAX=${KR},LMAX=${LR})
EOT
if (diff reseofes.n reseofes.inc > /dev/null)
then
    echo "reseofes.n and reseofes.inc are the same"
    rm -f reseofes.n
else
    echo "reseofes.n and reseofes.inc are different"
    mv reseofes.n reseofes.inc
fi
cat <<EOT > nvector.n
      INTEGER LMAX
      PARAMETER (LMAX=${LR})
EOT
if (diff nvector.n nvector.inc > /dev/null)
then
    echo "nvector.n and nvector.inc are the same"
    rm -f nvector.n
else
    echo "nvector.n and nvector.inc are different"
    mv nvector.n nvector.inc
fi
#
#  End of includes
#
fi
#
#  Now, build the necessary NAMELIST input:
# 
#
cd \${SOPERMOD}/eof/datain
ext=R.unf
cat <<EOT1 > \${SOPERMOD}/eof/datain/eoftem\${NUM}.nml
 &DATAIN
  DIRI='\${SOPERMOD}/eof/datain/ '
  DIRA='\${IOPERMOD}/ '
  DIRO='\${ROPERMOD}/eof/dataout/${RESOL}${NIVEL}/ '
  NAMEL='templ\${NUM}\${LABELI}'
  ANAME='GANL${PREFIXANLDATA}\${LABELI}\${ext}.${RESOL}${NIVEL} '
  TEMOUT='temout\${NUM}\${LABELI} '
  TEMPCM='tempcm\${NUM}\${LABELI} '
  TEMPER1='tempe1\${NUM}\${LABELI} '
  TEMPEN1='tempn1\${NUM}\${LABELI} '
 &END
 &STTEMP
  STDT( 1)=1.50,STDT( 2)=1.50,STDT( 3)=1.50,STDT( 4)=1.50,STDT( 5)=1.50,
  STDT( 6)=1.50,STDT( 7)=1.50,STDT( 8)=1.50,STDT( 9)=1.50,STDT(10)=1.50,
  STDT(11)=1.50,STDT(12)=1.50,STDT(13)=1.50,STDT(14)=1.50,STDT(15)=1.50,
  STDT(16)=1.50,STDT(17)=1.50,STDT(18)=1.50,STDT(19)=1.50,STDT(20)=1.50,
  STDT(21)=1.50,STDT(22)=1.50,STDT(23)=1.50,STDT(24)=1.50,STDT(25)=1.50,
  STDT(26)=1.50,STDT(27)=1.50,STDT(28)=1.50
 &END
EOT1
#
echo 'Vai chamar eoft'
#
\${OPERMOD}/eoftemp/scripts/eoftem.scr
#
#
if [ "${HUMID}" = "YES" ] 
then
#  Now, build the necessary NAMELIST input:
#
#
cd \${SOPERMOD}/eof/datain
ext=R.unf
cat <<EOT1 > \${SOPERMOD}/eof/datain/eofhum\${NUM}.nml
 &DATAIN
  DIRI='\${SOPERMOD}/eof/datain/ '
  DIRA='\${IOPERMOD}/ '
  DIRO='\${ROPERMOD}/eof/dataout/${RESOL}${NIVEL}/ '
  NAMEL='templ\${NUM}\${LABELI}'
  ANAME='GANL${PREFIXANLDATA}\${LABELI}\${ext}.${RESOL}${NIVEL} '
  HUMOUT='humout\${NUM}\${LABELI} '
  HUMPCM='humpcm\${NUM}\${LABELI} '
  HUMPER1='humpe1\${NUM}\${LABELI} '
  HUMPEN1='humpn1\${NUM}\${LABELI} '
 &END
 &STHUMI
  STDQ( 1)= 1.019,STDQ( 2)= 0.926,STDQ( 3)= 0.872,STDQ( 4)= 0.797,
  STDQ( 5)= 0.703,STDQ( 6)= 0.641,STDQ( 7)= 0.629,STDQ( 8)= 0.571,
  STDQ( 9)= 0.595,STDQ(10)= 0.546,STDQ(11)= 0.434,STDQ(12)= 0.345,
  STDQ(13)= 0.276,STDQ(14)= 0.204,STDQ(15)= 0.142,STDQ(16)= 0.081,
  STDQ(17)= 0.049,STDQ(18)= 0.024,STDQ(19)= 0.008,STDQ(20)= 0.002,
  STDQ(21)= 0.001,STDQ(22)= 0.000,STDQ(23)= 0.000,STDQ(24)= 0.000,
  STDQ(25)= 0.000,STDQ(26)= 0.000,STDQ(27)= 0.000,STDQ(28)= 0.000
 &END
EOT1
#
echo 'Vai chamar eofh'
#
\${OPERMOD}/eofhumi/scripts/eofhum.scr
#
fi
#
#  Now, build the necessary NAMELIST input:
#
#
cd \${SOPERMOD}/eof/datain
ext=R.unf
cat <<EOT1 > \${SOPERMOD}/eof/datain/eofwin\${NUM}.nml
 &DATAIN
  DIRI='\${SOPERMOD}/eof/datain/ '
  DIRA='\${IOPERMOD}/ '
  DIRO='\${ROPERMOD}/eof/dataout/${RESOL}${NIVEL}/ '
  NAMEL='templ\${NUM}\${LABELI} '
  ANAME='GANL${PREFIXANLDATA}\${LABELI}\${ext}.${RESOL}${NIVEL} '
  WINOUT='winout\${NUM}\${LABELI} '
  WINPCM='winpcm\${NUM}\${LABELI} '
  WINPER1='winpe1\${NUM}\${LABELI} '
  WINPEN1='winpn1\${NUM}\${LABELI} '
  TEMPER1='tempe1\${NUM}\${LABELI} '
  TEMPEN1='tempn1\${NUM}\${LABELI} '
  HUMPER1='humpe1\${NUM}\${LABELI} '
  HUMPEN1='humpn1\${NUM}\${LABELI} '
 &END
 &STZWIN
  STDU( 1)=5.00,STDU( 2)=5.00,STDU( 3)=5.00,STDU( 4)=5.00,STDU( 5)=5.00,
  STDU( 6)=5.00,STDU( 7)=5.00,STDU( 8)=5.00,STDU( 9)=5.00,STDU(10)=5.00,
  STDU(11)=5.00,STDU(12)=5.00,STDU(13)=5.00,STDU(14)=5.00,STDU(15)=5.00,
  STDU(16)=5.00,STDU(17)=5.00,STDU(18)=5.00,STDU(19)=5.00,STDU(20)=5.00,
  STDU(21)=5.00,STDU(22)=5.00,STDU(23)=5.00,STDU(24)=5.00,STDU(25)=5.00,
  STDU(26)=5.00,STDU(27)=5.00,STDU(28)=5.00
 &END
 &STMWIN
  STDV( 1)=5.00,STDV( 2)=5.00,STDV( 3)=5.00,STDV( 4)=5.00,STDV( 5)=5.00,
  STDV( 6)=5.00,STDV( 7)=5.00,STDV( 8)=5.00,STDV( 9)=5.00,STDV(10)=5.00,
  STDV(11)=5.00,STDV(12)=5.00,STDV(13)=5.00,STDV(14)=5.00,STDV(15)=5.00,
  STDV(16)=5.00,STDV(17)=5.00,STDV(18)=5.00,STDV(19)=5.00,STDV(20)=5.00,
  STDV(21)=5.00,STDV(22)=5.00,STDV(23)=5.00,STDV(24)=5.00,STDV(25)=5.00,
  STDV(26)=5.00,STDV(27)=5.00,STDV(28)=5.00
 &END
 &HUMIDI
  HUM='${HUMID}'
 &END
EOT1
#
echo 'Vai chamar eofw'
#
\${OPERMOD}/eofwind/scripts/eofwin.scr

#
cd ${OPERM}/run
EXTs=S.unf.${RESOL}${NIVEL}
# Decomposicao das analises obtidas
cd ${OPERM}/run
\${OPERM}/run/rundeco.${MACHINE} \${COMPILE} ${TRC} ${LV} \${NUM} \${LABELI} ${NFDAYS} ${HUMID} ${NUMPERT}
#
# Script runpntg.${MACHINE} roda o modelo completo:
#
# FICA ESPERTO ABAIXO!!! RODA O MODELO PARA CADA MEMBRO!


# AGORA SERAH CHAMADO PELO SMS!
  
#${OPERM}/run/runpntg1.una ${TRC} ${LV} \${LABELI} ${NFDAYS} \${NUM}P ${NUMPERT} sstwkl
#${OPERM}/run/runpntg1.una ${TRC} ${LV} \${LABELI} ${NFDAYS} \${NUM}N ${NUMPERT} sstwkl

#
EOT0
#
#   Change mode to be executable
#
chmod 744 ${OPERM}/run/${SCRIPTNAME}
#
#
#AMM echo "qsub -x -s /bin/ksh -q ${QUEUE} ${OPERM}/run/seteofs.1.${PERR}${RESOL}${NIVEL}.${MACHINE}"
#AMM qsub -x -s /bin/ksh -q ${QUEUE} ${OPERM}/run/seteofs.1.${PERR}${RESOL}${NIVEL}.${MACHINE}



if [[ ${it} -eq 1 ]];then
FIRST=`qsub  ${OPERM}/run/${SCRIPTNAME}`
export FIRST
echo $FIRST
else
SECOND=`qsub -W depend=afterok:$FIRST ${OPERM}/run/${SCRIPTNAME}`
echo $SECOND
fi

if [ "$hold" == "" ]
then
echo "$hold = NO"
else 
echo "$hold = YES"
itt=2
while [ ${itt} -gt 0 ];do
itt=`qstat @aux20 |grep ${USER}|grep ENSEOFS${NUM}| wc -l`
itt2=`qstat @sdb|grep ${USER}|grep ENSEOFS${NUM}| wc -l`
let itt=${itt}+${itt2}
sleep 5
done
fi
