module load cuda cudnn
module load imkl

TARGET_WHEEL=$(realpath $1)
WORKDIR=$(mktemp -d)
cd $WORKDIR

unzip $TARGET_WHEEL

chmod -R +rwx *.data

setrpaths.sh --path *.data --add_path $EBROOTNCCL/lib
setrpaths.sh --path *.data --add_path $EBROOTIMKL/compilers_and_libraries/linux/lib/intel64_lin
setrpaths.sh --path *.data --add_path $EBROOTCUDNN/lib64
for path in $(find $EBROOTCUDA -name lib64)
do
   setrpaths.sh --path *.data --add_path $path
done

rm $TARGET_WHEEL
zip -r $TARGET_WHEEL *.data/ *.dist-info/
