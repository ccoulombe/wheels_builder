if [[ -z "$VERSION" ]]; then
	VERSION="0.4.0"
fi
PACKAGE_DOWNLOAD_ARGUMENT="https://github.com/ray-project/ray/archive/ray-$VERSION.tar.gz"
MODULE_BUILD_DEPS="gcc/5.4.0 qt/5.10.1"
PYTHON_DEPS="numpy scipy cython"
PACKAGE_FOLDER_NAME="ray-ray-*/python"
PRE_BUILD_COMMANDS="pwd; sed -i -e 's/-DPARQUET_BUILD_TESTS=off/-DPARQUET_BUILD_TESTS=off -DCMAKE_SKIP_RPATH=ON -DCMAKE_SKIP_INSTALL_RPATH=ON/g' ../thirdparty/scripts/build_parquet.sh && sed -i -e 's/-DARROW_WITH_ZSTD=off/-DARROW_WITH_ZSTD=off  -DCMAKE_SKIP_RPATH=ON -DCMAKE_SKIP_INSTALL_RPATH=ON/g' ../thirdparty/scripts/build_arrow.sh"

