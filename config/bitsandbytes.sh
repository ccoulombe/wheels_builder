# Used ac5550a0238286377ee3f58a85aeba1c40493e17 for v0.39.0 as it contains bug fixes

PACKAGE_DOWNLOAD_ARGUMENT="https://github.com/TimDettmers/bitsandbytes"
PACKAGE_DOWNLOAD_NAME="$PACKAGE-$VERSION.tar.gz"
PACKAGE_DOWNLOAD_METHOD="Git"
PACKAGE_DOWNLOAD_CMD="git clone --jobs 16 --recursive $PACKAGE_DOWNLOAD_ARGUMENT $PACKAGE_FOLDER_NAME && cd $PACKAGE_FOLDER_NAME && git checkout ${VERSION:?version required} && cd .."
POST_DOWNLOAD_COMMANDS="tar -zcf ${PACKAGE}-${VERSION}.tar.gz $PACKAGE_FOLDER_NAME"
# Build cpu, cuda 11.4 and 11.7 libs. Override compute capability to ignore arch we do not have and compilation issues related to older compute capability.
# COMPUTE_CAPABILITY is only a base set, 7.5 and up are added automatically
PRE_BUILD_COMMANDS='
	CUDA_VERSION=CPU make cpuonly GPP=$(which g++) -j 4;
	module load cuda/11.4 && make cuda11x cuda11x_nomatmul -j 4 CUDA_VERSION=114 GPP=$(which g++) COMPUTE_CAPABILITY="-gencode arch=compute_60,code=sm_60 -gencode arch=compute_70,code=sm_70" CC_KEPLER=;
	module load cuda/11.7 && make cuda11x cuda11x_nomatmul -j 4 CUDA_VERSION=117 GPP=$(which g++) COMPUTE_CAPABILITY="-gencode arch=compute_60,code=sm_60 -gencode arch=compute_70,code=sm_70" CC_KEPLER=;
	module load cuda/11.8 && make cuda11x cuda11x_nomatmul -j 4 CUDA_VERSION=117 GPP=$(which g++) COMPUTE_CAPABILITY="-gencode arch=compute_60,code=sm_60 -gencode arch=compute_70,code=sm_70" CC_KEPLER=;
	sed -i "/setup(/a install_requires=[\"torch\", \"numpy\", \"scipy\"]," setup.py;
'
MODULE_RUNTIME_DEPS='cuda/11.4'
