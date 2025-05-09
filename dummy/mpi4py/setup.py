import os,sys
from setuptools import setup


class bcolors:
    HEADER = '\033[95m'
    OKBLUE = '\033[94m'
    OKCYAN = '\033[96m'
    OKGREEN = '\033[92m'
    WARNING = '\033[93m'
    FAIL = '\033[91m'
    ENDC = '\033[0m'
    BOLD = '\033[1m'
    UNDERLINE = '\033[4m'

msg = f"""



        {bcolors.OKGREEN}This is a normal error generated by this dummy wheel.{bcolors.ENDC}


        mpi4py is available from the mpi4py module, please see https://docs.alliancecan.ca/wiki/MPI4py

        {bcolors.BOLD}{bcolors.WARNING}IMPORTANT{bcolors.ENDC}: the module {bcolors.BOLD}must{bcolors.ENDC} be loaded {bcolors.BOLD}before{bcolors.ENDC} activating your virtual environment.

        1. Deactivate your virtual environment : deactivate
        2. Load the mpi4py module : module load mpi4py/x.y.z
        3. Activate your virtual env. : source <env>/bin/activate
        4. And re-run your pip install command.



        """

if __name__ == "__main__":
    # We allow python setup.py sdist to always work to be able to create the sdist
    sdist_mode = len(sys.argv) == 2 and sys.argv[1] == "sdist"
    bdist_mode = len(sys.argv) == 2 and sys.argv[1] == "bdist_wheel"

    if not sdist_mode and not bdist_mode:
        raise SystemExit(msg)

    setup(
        description="Dummy mpi4py wheels to inform users to load the module instead.",
        name="mpi4py-noinstall" if sdist_mode else "mpi4py",
        version=f"{os.environ.get('DUMMY_VERSION',9999)}+dummy.computecanada",
        install_requires = ["mpi4py-noinstall==9999+dummy.computecanada"] if bdist_mode else [],
    )
