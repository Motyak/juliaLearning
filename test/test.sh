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
julia -Jsysimage/sys.so test/main.jl 
