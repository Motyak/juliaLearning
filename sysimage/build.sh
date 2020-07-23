#!/bin/sh
echo "Searching for julia's paths"
DEF_PATH=$(printf '%s' "unsafe_string(Base.JLOptions().image_file)" | julia | tr -d '"')
JULIA_LIB_PATH=$(printf '%s' "abspath(Sys.BINDIR, Base.LIBDIR)" | julia | tr -d '"')
STDLIB_PATH=$(printf '%s' "Base.load_path()" | julia | grep stdlib | tr -d '"')
# julia --startup-file=no --trace-compile=sysimage/precompile.jl sysimage/generate_precompile.jl
echo "Creating sysimage object file.."
julia --startup-file=no --output-o sysimage/sys.o -J$DEF_PATH sysimage/custom_sysimage.jl $STDLIB_PATH
echo "Creating sysimage shared library.."
gcc -shared -o sysimage/sys.so -Wl,--whole-archive sysimage/sys.o -Wl,--no-whole-archive -L$JULIA_LIB_PATH -ljulia
rm sysimage/sys.o
