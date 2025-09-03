#!/bin/sh

# 
# Vivado(TM)
# runme.sh: a Vivado-generated Runs Script for UNIX
# Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
# Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
# 

if [ -z "$PATH" ]; then
  PATH=/opt/VivadoXilinx/2025.1/Vitis/bin:/opt/VivadoXilinx/2025.1/Vivado/ids_lite/ISE/bin/lin64:/opt/VivadoXilinx/2025.1/Vivado/bin
else
  PATH=/opt/VivadoXilinx/2025.1/Vitis/bin:/opt/VivadoXilinx/2025.1/Vivado/ids_lite/ISE/bin/lin64:/opt/VivadoXilinx/2025.1/Vivado/bin:$PATH
fi
export PATH

if [ -z "$LD_LIBRARY_PATH" ]; then
  LD_LIBRARY_PATH=
else
  LD_LIBRARY_PATH=:$LD_LIBRARY_PATH
fi
export LD_LIBRARY_PATH

HD_PWD='/home/lorang/Documents/TFE4141_Design_av_Digitale_Systemer_1/oving/oving_2/oppgave_4/project_4/project_4.runs/impl_1'
cd "$HD_PWD"

HD_LOG=runme.log
/bin/touch $HD_LOG

ISEStep="./ISEWrap.sh"
EAStep()
{
     $ISEStep $HD_LOG "$@" >> $HD_LOG 2>&1
     if [ $? -ne 0 ]
     then
         exit
     fi
}

# pre-commands:
/bin/touch .init_design.begin.rst
EAStep vivado -log logic.vdi -applog -m64 -product Vivado -messageDb vivado.pb -mode batch -source logic.tcl -notrace


