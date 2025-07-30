#!/bin/bash

# Download and extract blas source
curl -LO https://www.netlib.org/blas/blas-3.12.0.tgz
tar zxf blas-3.12.0.tgz

# Configure and build blas
cd BLAS-3.12.0
cat <<EOF > make.inc
####################################################################
#  BLAS make include file.                                         #
#  March 2007                                                      #
####################################################################
#
SHELL = /bin/sh
#
#  The machine (platform) identifier to append to the library names
#
PLAT = _LINUX
#
#  Modify the FORTRAN and OPTS definitions to refer to the
#  compiler and desired compiler options for your machine.  NOOPT
#  refers to the compiler options desired when NO OPTIMIZATION is
#  selected.  Define LOADER and LOADOPTS to refer to the loader and
#  desired load options for your machine.
#
FC  = /opt/flang/host/bin/flang
FFLAGS = -O2
FFLAGS_DRV = \$(FFLAGS)
FFLAGS_NOOPT = -O0
#  Define LDFLAGS to the desired linker options for your machine.
#
LDFLAGS =

#  The archiver and the flag(s) to use when building an archive
#  (library).  If your system has no ranlib, set RANLIB = echo.
#
AR = /opt/emsdk/upstream/emscripten/emar
ARFLAGS = cr
RANLIB = /opt/emsdk/upstream/emscripten/emranlib
#
#  The location and name of the Reference BLAS library.
#
BLASLIB      = blas\$(PLAT).a
EOF
make -j$(nproc)

# Copy libblas.a
cp blas_LINUX.a ${LIBDIR}/libblas.a
echo "Successfully built libblas.a"
