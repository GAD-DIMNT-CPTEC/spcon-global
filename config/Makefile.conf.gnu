# spectral resolution
TRUNC=TQ0126
LEV=L028

# simultaneous parallel jobs & load average limit
MAXJOBS = 1
MAXLOAD = 1

# standard
SHELL     = sh
MAKE      = make
MAKEFILE  = Makefile
MAKEFLAGS = -r -j$(MAXJOBS) -l$(MAXLOAD)

# utils
ECHO    = echo
RM      = rm
CP      = cp
MV      = mv
CD      = cd
MKDIR   = mkdir
TAR     = tar
GZIP    = gzip
INSTALL = install

# dirs
HOME=$(PWD)
WORKDIR=$(HOME)

CPTECDIR=$(WORKDIR)
CPTECINC=$(CPTECDIR)/include

FFTPLN=$(CPTECDIR)/fftpln/source
EOFTEMP=$(CPTECDIR)/eoftemp/source  
EOFHUMI=$(CPTECDIR)/eofhumi/source
EOFWIND=$(CPTECDIR)/eofwind/source
DECEOF=$(CPTECDIR)/deceof/source
RECANL=$(CPTECDIR)/recanl/source
RDPERT=$(CPTECDIR)/rdpert/source
DECANL=$(CPTECDIR)/decanl/source
RECFCT=$(CPTECDIR)/recfct/source
EOFPRES=$(CPTECDIR)/eofpres/source

# preprocessor, compilers, linker & archiver
F90 = mpif90
FC  = mpif90
F77 = mpif90
LD  = mpif90
AR  = ar

# default flags
ARFLAGS  = -r
