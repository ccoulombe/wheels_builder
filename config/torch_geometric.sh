PYTHON_DEPS="torch>=1.4.0 torch-scatter torch-sparse torch-cluster torch-spline-conv"
MODULE_BUILD_DEPS="gcc/7.3.0 cuda/10.1"
PRE_BUILD_COMMANDS="export TORCH_CUDA_ARCH_LIST='3.5;3.7;6.0;7.0'; export FORCE_CUDA=1"
