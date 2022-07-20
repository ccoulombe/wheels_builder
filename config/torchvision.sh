PYTHON_DEPS="numpy>=1.21.2 six pillow-simd torch==1.10.0"
MODULE_BUILD_DEPS="gcc/9.3.0 cuda/11.4 cmake"
PACKAGE_DOWNLOAD_ARGUMENT="git+https://github.com/pytorch/vision.git@v${VERSION:?version required}"
PRE_BUILD_COMMANDS="export BUILD_VERSION=$VERSION; export TORCH_CUDA_ARCH_LIST='6.0;7.0;7.5;8.0'; export FORCE_CUDA=1; export MAX_JOBS=4; export PYTORCH_VERSION=1.10.0; export TORCHVISION_INCLUDE=$EBROOTGENTOO/include; export TORCHVISION_LIBRARY=$EBROOTGENTOO/lib64;"
UPDATE_REQUIREMENTS="'torch (==1.10.0)'"
