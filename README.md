Mochi Conda Packages
====================

This repository contains recipes to build conda packages for Mochi using `conda-build`.
Note that Mochi components are also available with spack, which is the preferred
method for installing them.

The point of Conda is that packages are distributed as already compiled binaries.
This is convenient if building the packages is particularly cumbersome in some platform,
but keep in mind that these binaries have fixed configuration options that you cannot
change, contrary to a Spack build.

Building the channel
--------------------

Note that you don't have to build the channel yourself if someone has provided a build
for you already (such build may be provided as releases in this repository in the future).

If you wish to build the channel yourself, make sure you have
[miniconda](https://www.anaconda.com/docs/getting-started/miniconda/main) installed on
your system, and that you have cloned the present repository.
Make sure to install the `conda-build` package by running `conda install conda-build`.
You can then run `./build-all.sh` to start the build process.

Here is an overview of the packages that this script will build, along with their options.

- argobots (standard build)
- diaspora-stream-api (python enabled, benchmarks disabled)
- gdbm (standard build)
- mercury-hpc (with ofi and hwloc enabled, ucx and checksums disabled)
- mochi-abt-io (with liburing enabled)
- mochi-bedrock (with MPI, flock, and python support)
- mochi-bedrock-module-api (with python enabled)
- mochi-flock (with bedrock, MPI, and python support)
- mochi-margo (plumber enabled)
- mochi-thallium (standard build)
- mochi-warabi (with bedrock and python support)
- mochi-yokan (with lua and  bedrock support, no backend database support)
- mofka (with python support)
- nlohmann-json-schema-validator (standard build)
- pmdk (standard build)
- py-mochi-margo (standard build)
- sol2 (standard build)
- tclap (standard build)
- tkrzw (standard build)
- unqlite-c (standard build)

Note that some of the packages above (e.g. tclap) are available on the conda-forge channel.
This repository provides them as well because the conda-forge versions have some issues
(e.g. architectures not provided, or header files missing).

Using the channel
-----------------

Assuming that you have a channel ready (built yourself or provided by someone) in the
folder `/path/to/mochi-conda-channel`, you may use it as follows.

```bash
# Create the environment (change the name as desired)
conda create --name my-env
# Note: use the following if your installation of conda uses a version of python that is not 3.13:
#    conda create --name my-env python=3.13

# Activate the environment
conda activate my-env

# Install a Mochi package, e.g. mofka
conda install mofka -c /path/to/mochi-conda-channel
```

You can then test your installation:

```
python -c "import mochi.mofka"
```

Dealing with system-provided libfabric
--------------------------------------

Mercury depends on libfabric; as a result conda will pull a libfabric package from the conda-forge
channel when building the channel or when using it. On a supercomputer, the system may provide
a build of libfabric adapted to the high performance network used. To be able to use it,
(1) make sure that its path is somewhere in `LD_LIBRARY_PATH` (this is usually achieved by
loading a module), and (2) remove or rename the libfabric libraries from your conda environment
as they will otherwise be picked up in priority.

For instance on [Polaris](https://www.alcf.anl.gov/polaris), `module load conda` will allow you to use
conda; `module load libfabric` will load the system-provided libfabric. After installing an environment
`my-env`, look into `~/.conda/envs/my-env/lib` and you will find libfabric.so.1.30.0 and libfabric.so.1,
which you should remove (or rename so that they are not found by mercury).

You can check that mercury will load the correct library by running `ldd ~/.conda/envs/my-env/lib/libmercury.so`
and verifying that libfabric points to the system-provided library.

Note that the system-provided library should be ABI-compatible with the one used to build the channel (1.30.0).
