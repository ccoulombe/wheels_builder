MODULE_BUILD_DEPS="cmake cuda/11.4 hdf5 fftw boost"
MODULE_RUNTIMED_DEPS="hdf5"
PACKAGE_DOWNLOAD_ARGUMENT="https://github.com/prism-em/prismatic/archive/refs/tags/v$VERSION.tar.gz"
PACKAGE="PyPrismatic"
PACKAGE_SUFFIX="-gpu"
BDIST_WHEEL_ARGS="--enable-gpu"
PYTHON_IMPORT_NAME="pyprismatic.core"
PATCHES="PyPrismatic-fix_multiple_arch.patch"
PRE_BUILD_COMMANDS="sed -i -e 's/1.2.0/$VERSION/' setup.py"
