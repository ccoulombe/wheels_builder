PYTHON_DEPS="numpy six pillow-simd torch"
MODULE_BUILD_DEPS="cuda/11"
PACKAGE_DOWNLOAD_ARGUMENT="https://github.com/pytorch/vision/archive/v${VERSION}.tar.gz"
PACKAGE_DOWNLOAD_NAME="v${VERSION}.tar.gz"
PACKAGE_FOLDER_NAME="vision-${VERSION}"
PRE_BUILD_COMMANDS="export BUILD_VERSION=$VERSION"
