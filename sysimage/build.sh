#!/bin/bash
DEF_PATH=$(printf '%s' "unsafe_string(Base.JLOptions().image_file)" | julia)
JULIA_LIB_PATH=$(printf '%s' "abspath(Sys.BINDIR, Base.LIBDIR)" | julia)
julia --startup-file=no --output-o sys.o -J$DEF_PATH custom_sysimage.jl
gcc -shared -o sys.so -Wl,--whole-archive sys.o -Wl,--no-whole-archive -L$JULIA_LIB_PATH -ljulia
