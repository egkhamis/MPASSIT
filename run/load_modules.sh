#!/bin/bash
module purge
module load ohpc
module swap gnu9 intel/2021.4.0
module swap openmpi4/4.1.1 impi/2021.4.0
module load hwloc
module load python-3.9.10-gcc-11.2.0-cf2iam6
module load cmake/3.21.3

module list

. /mnt/beegfs/eduardo.khamis/usr/local/spack/github/spack_v0.19.2_oneapi_esmf/share/spack/setup-env.sh
export SPACK_USER_CONFIG_PATH=/mnt/beegfs/eduardo.khamis/.spack/spack_v0.19.2_oneapi_esmf
export SPACK_USER_CACHE_PATH=${SPACK_USER_CONFIG_PATH}/tmp
export TMP=${SPACK_USER_CACHE_PATH}
export TMPDIR=${SPACK_USER_CACHE_PATH}

compiler=intel@2021.4.0

#spack load --only dependencies esmf@8.3.1%${compiler}
spack load esmf@8.3.1%${compiler}
spack unload xerces-c@3.2.3%${compiler}
spack load --list

module load pnetcdf/1.12.2 
#module load xerces-c-3.2.3-intel-2021.4.0-ak7nxew
#module load xerces-c-3.2.3-gcc-11.2.0-roa2c2e
module load xerces-c-3.2.3-gcc-9.4.0-7kmsh66
module list

export ESMF_APPSDIR=`spack location -i esmf@8.3.1%${compiler}`/bin
export ESMF_LIBSDIR=`spack location -i esmf@8.3.1%${compiler}`/lib
export ESMFMKFILE=`spack location -i esmf@8.3.1%${compiler}`/lib/esmf.mk
export NETCDF=`spack location -i netcdf-c@4.9.0%${compiler}`
export NETCDF_FORTRAN=`spack location -i netcdf-fortran@4.6.0%${compiler}`
#export PNETCDF=`spack location -i parallel-netcdf@1.12.3%${compiler}`
#export XERCES=`spack location -i xerces-c@3.2.3%${compiler}`
export CMAKE_FLAGS="-DCMAKE_INSTALL_PREFIX=../ -DEMC_EXEC_DIR=ON -DBUILD_TESTING=OFF -DCMAKE_C_COMPILER=mpiicc -DCMAKE_CXX_COMPILER=mpiicpc -DCMAKE_Fortran_COMPILER=mpiifort"

echo "ESMFMKFILE=$ESMFMKFILE" 
echo "NETCDF=$NETCDF"
echo "NETCDF_FORTRAN=$NETCDF_FORTRAN" 
echo "PNETCDF=$PNETCDF"
echo "PNETCDF_INC=$PNETCDF_INC"
echo "PNETCDF_LIB=$PNETCDF_LIB"
echo "PNETCDF_DIR=$PNETCDF_DIR"
echo "XERCES=$XERCES"

#rm -fr ./build
#mkdir ./build && cd ./build
#
#cmake .. ${CMAKE_FLAGS}
#
#make -j 8 VERBOSE=1
##make install
#
##make test
##ctest -I 4,5F

#cd ..

