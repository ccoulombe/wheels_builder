#!/bin/bash

THIS_SCRIPT=$0
SCRIPT_DIR=$(dirname -- "$(readlink -f -- "$THIS_SCRIPT")")

function ls_pythons()
{
	ls -1d /cvmfs/soft.computecanada.ca/easybuild/software/20*/Core/python/3* /cvmfs/soft.computecanada.ca/easybuild/software/2020/avx*/Core/python/3* | grep -v "3.[56]" | grep -Po "\d\.\d" | sort -u | tr '\n' ','
}

function print_usage
{
	echo "Usage: $0 --package <package name> [--version <version>] [--python <comma separated list of python versions>] [--find_links https://index.url]"
}

TEMP=$(getopt -o h --longoptions help,package:,version:,python:,add_path:,find_links:,add_origin --name $0 -- "$@")
if [ $? != 0 ] ; then print_usage; exit 1 ; fi
eval set -- "$TEMP"
START_DIR=$(pwd)
ARG_PACKAGE=""
ARG_VERSION=""
ARG_ADD_PATH=""
ARG_ADD_ORIGIN=0
ARG_FIND_LINKS=""
while true; do
	case "$1" in
		--package)
			ARG_PACKAGE=$2; shift 2;;
		--version)
			ARG_VERSION=$2; shift 2;;
		--python)
			ARG_PYTHON_VERSIONS=$2; shift 2;;
		--add_path)
			ARG_ADD_PATH=$2; shift 2 ;;
		--add_origin)
			ARG_ADD_ORIGIN=1; shift 1;;
		--find_links)
			ARG_FIND_LINKS=$2; shift 2;;
		-h|--help)
			print_usage; exit 0 ;;
		--)
			shift; break ;;
		*) echo "Unknown parameter $1"; print_usage; exit 1 ;;
	esac
done

if [[ -z "$ARG_PACKAGE" ]]; then
	print_usage
	exit 1
fi

if [[ -n "$ARG_VERSION" ]]; then
	PACKAGE_DOWNLOAD_ARGUMENT="$ARG_PACKAGE==$ARG_VERSION"
else
	PACKAGE_DOWNLOAD_ARGUMENT="$ARG_PACKAGE"
fi

CONFIGDIR=$(dirname $0)/config
if [[ -e "$CONFIGDIR/${ARG_PACKAGE}-${ARG_VERSION}.sh" ]]; then
	source $CONFIGDIR/${ARG_PACKAGE}-${ARG_VERSION}.sh
elif [[ -e "$CONFIGDIR/${ARG_PACKAGE}.sh" ]]; then
	source $CONFIGDIR/${ARG_PACKAGE}.sh
fi

if [[ ! -z "$ARG_FIND_LINKS" ]]; then
	export PIP_FIND_LINKS=$ARG_FIND_LINKS
fi
#a
TEMP_DIR=tmp.$$
mkdir $TEMP_DIR
cd $TEMP_DIR
for pv in $(echo ${ARG_PYTHON_VERSIONS-$(ls_pythons)} | tr ',' ' '); do
	module load python/$pv
	python -m venv env-$pv && source env-$pv/bin/activate
	pip install -U pip
	PYTHONPATH= pip download --no-deps $PACKAGE_DOWNLOAD_ARGUMENT
	deactivate
done

setrpaths_cmd="setrpaths.sh --path \$ARCHNAME"
if [[ ! -z "$ARG_ADD_PATH" ]]; then
	setrpaths_cmd="${setrpaths_cmd} --add_path ${ARG_ADD_PATH} --any_interpreter"
fi
if [[ "$ARG_ADD_ORIGIN" == "1" ]]; then
	setrpaths_cmd="${setrpaths_cmd} --add_origin"
fi
for ARCHNAME in *.whl; do
	eval $setrpaths_cmd
	eval "$PATCH_WHEEL_COMMANDS"
	mv $ARCHNAME ${ARCHNAME//$(echo $ARCHNAME | grep -Po 'manylinux.*x86_64')/linux_x86_64}
done
for ARCHNAME in *.whl; do
	$SCRIPT_DIR/manipulate_wheels.py --insert_local_version --wheels $ARCHNAME --inplace && rm $ARCHNAME
done

# Ensure wheels are all readable!
chmod a+r *.whl
cp -vp *.whl ..
cd ..
rm -rf $TEMP_DIR
