#!/bin/bash
if [ ! -f "sysimage/sys.so" ] 
then
    DEF_PATH=$(printf '%s' "unsafe_string(Base.JLOptions().image_file)" | julia | tr -d '"')
    ln -s $DEF_PATH sysimage/sys.so
fi
if [ -L "sysimage/sys.so" ]
then
    echo -e "We recommend building a sysimage using 'sysimage/build.sh' for better performance!\n"
fi
if [ $# -eq 0 ] || [ $# -eq 1 ]
then
    echo "Launching the server with default arguments : 127.0.0.1 8080 glpk"
    echo -e "Prototype : $./run.sh [host] [port] [optimizer]"
else
    echo "Launching the server with arguments : $@"
fi
julia -Jsysimage/sys.so main.jl $@
