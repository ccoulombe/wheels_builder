#!/bin/bash

WHEELHOUSE_ROOT="/cvmfs/soft.computecanada.ca/custom/python/wheelhouse"

function print_usage
{
	echo "Usage: $0 [--wheel <wheel_file>] [--arch generic|<rsnt_arch>] [--remove] [--dry-run]"
}

TEMP=$(getopt -o h --longoptions help,remove,dry-run,arch:,wheel: --name $0 -- "$@")
if [ $? != 0 ] ; then print_usage; exit 1 ; fi
eval set -- "$TEMP"

ARG_WHEEL=""
ARC_ARCH=""
ARG_REMOVE=""
ARG_DRY_RUN=""
while true; do
	case "$1" in
		--wheel)
			ARG_WHEEL=$2; shift 2;;
		--arch)
			ARG_ARCH=$2; shift 2;;
		--remove)
			ARG_REMOVE=1; shift 1;;
		--dry-run)
			ARG_DRY_RUN=1; shift 1;;
		-h|--help)
			print_usage; exit 0 ;;
		--)
			shift; break ;;
		*) echo "Unknown parameter $1"; print_usage; exit 1 ;;
	esac
done


function cp_wheel {
	NAME=$1
	COMPAT=$2
	ARCHITECTURE=$3
	REMOVE=$4
	RESULT=1
	if [[ "$COMPAT" == "unknown" ]]; then
		echo "Error, wheel with unknown compatibility layer encountered. $NAME, $COMPAT, $ARCHITECTURE"
		echo "Run the following for more details: "
		echo "bash wheel_architecture.sh $NAME"
		exit
	fi
	if [[ "$ARG_ARCH" != "" ]]; then
		ARCHITECTURE="$ARG_ARCH"
	fi
	if [[ ! "$ARCHITECTURE" =~ ^(generic|sse3|avx|avx2|avx512)$ ]]; then
		echo "Error, unknown architecture: $ARCHITECTURE"
		exit
	fi
	if [[ "$ARCHITECTURE" == "generic" && "$ARG_ARCH" == "" ]]; then
		PKGNAME="${NAME%%-*}"
		ARCH_WHEELS="$(find $WHEELHOUSE_ROOT -not -wholename "*/generic/*" -name "$PKGNAME-*.whl" -printf "%P\n")"
		if [[ "$ARCH_WHEELS" != "" ]]; then
			echo "Error, the following arch-specific wheels already exist in the wheelhouse:"
			for w in $ARCH_WHEELS; do
				echo "  $w"
			done
			echo "$NAME cannot be copied as a generic wheel."
			echo "Use --arch <rsnt_arch> to specify the architecture."
			exit
		fi
	fi
	echo chmod ug+rw,o+r $1
	if [[ "$ARG_DRY_RUN" == "" ]]; then
		chmod ug+rw,o+r $1
	fi
	if [[ "$COMPAT" == "generic" ]]; then
		echo cp $1 $WHEELHOUSE_ROOT/generic
		if [[ "$ARG_DRY_RUN" == "" ]]; then
			cp $1 $WHEELHOUSE_ROOT/generic
			RESULT=$?
		fi
	elif [[ "$COMPAT" == "gentoo" || "$COMPAT" == "nix" ]]; then
		echo cp $1 $WHEELHOUSE_ROOT/$COMPAT/$ARCHITECTURE
		if [[ "$ARG_DRY_RUN" == "" ]]; then
			cp $1 $WHEELHOUSE_ROOT/$COMPAT/$ARCHITECTURE
			RESULT=$?
		fi
	fi
	if [[ "$REMOVE" == "1" && "$RESULT" == "0" ]]; then
		echo rm "$1"
		if [[ "$ARG_DRY_RUN" == "" ]]; then
			rm "$1"
		fi
	fi
}

if [[ "$ARG_DRY_RUN" == "1" ]]; then
	echo "Not doing operations (dry-run)"
fi

if [ -z "$ARG_WHEEL" ]
then
        WHEEL_LIST=*computecanada*.whl
else
        WHEEL_LIST=$ARG_WHEEL
fi

for w in $WHEEL_LIST; do
        cp_wheel $w $(bash wheel_architecture.sh $w 2>/dev/null) $ARG_REMOVE
done
