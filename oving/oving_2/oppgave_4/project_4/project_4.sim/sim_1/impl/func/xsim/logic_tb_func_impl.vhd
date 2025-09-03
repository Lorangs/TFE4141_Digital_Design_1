-- Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
-- Copyright 2022-2025 Advanced Micro Devices, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2025.1 (lin64) Build 6140274 Wed May 21 22:58:25 MDT 2025
-- Date        : Wed Sep  3 17:43:58 2025
-- Host        : laptop running 64-bit Ubuntu 24.04.3 LTS
-- Command     : write_vhdl -mode funcsim -nolib -force -file
--               /home/lorang/Documents/TFE4141_Design_av_Digitale_Systemer_1/oving/oving_2/oppgave_4/project_4/project_4.sim/sim_1/impl/func/xsim/logic_tb_func_impl.vhd
-- Design      : logic
-- Purpose     : This VHDL netlist is a functional simulation representation of the design and should not be modified or
--               synthesized. This netlist cannot be used for SDF annotated simulation.
-- Device      : xc7z020clg400-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity logic is
  port (
    A : in STD_LOGIC;
    B : in STD_LOGIC;
    Q : out STD_LOGIC;
    QN : out STD_LOGIC
  );
  attribute NotValidForBitStream : boolean;
  attribute NotValidForBitStream of logic : entity is true;
  attribute \DesignAttr:ENABLE_AIE_NETLIST_VIEW\ : boolean;
  attribute \DesignAttr:ENABLE_AIE_NETLIST_VIEW\ of logic : entity is std.standard.true;
  attribute \DesignAttr:ENABLE_NOC_NETLIST_VIEW\ : boolean;
  attribute \DesignAttr:ENABLE_NOC_NETLIST_VIEW\ of logic : entity is std.standard.true;
  attribute ECO_CHECKSUM : string;
  attribute ECO_CHECKSUM of logic : entity is "ad6dfcaf";
end logic;

architecture STRUCTURE of logic is
  signal A_IBUF : STD_LOGIC;
  signal B_IBUF : STD_LOGIC;
  signal QN_OBUF : STD_LOGIC;
  signal Q_OBUF : STD_LOGIC;
begin
A_IBUF_inst: unisim.vcomponents.IBUF
     port map (
      I => A,
      O => A_IBUF
    );
B_IBUF_inst: unisim.vcomponents.IBUF
     port map (
      I => B,
      O => B_IBUF
    );
QN_OBUF_inst: unisim.vcomponents.OBUF
     port map (
      I => QN_OBUF,
      O => QN
    );
QN_OBUF_inst_i_1: unisim.vcomponents.LUT2
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => B_IBUF,
      I1 => Q_OBUF,
      O => QN_OBUF
    );
Q_OBUF_inst: unisim.vcomponents.OBUF
     port map (
      I => Q_OBUF,
      O => Q
    );
Q_OBUF_inst_i_1: unisim.vcomponents.LUT3
    generic map(
      INIT => X"54"
    )
        port map (
      I0 => A_IBUF,
      I1 => Q_OBUF,
      I2 => B_IBUF,
      O => Q_OBUF
    );
end STRUCTURE;
