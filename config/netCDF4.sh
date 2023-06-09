MODULE_BUILD_DEPS="openmpi hdf5-mpi netcdf-mpi mpi4py"
MODULE_RUNTIME_DEPS="openmpi mpi4py"
PRE_DOWNLOAD_COMMANDS='export HDF5_DIR=$EBROOTHDF5; export NETCDF4_DIR=$EBROOTNETCDF'
RPATH_TO_ADD='$EBROOTOPENMPI/lib'
PYTHON_DEPS='pip==23.0'
