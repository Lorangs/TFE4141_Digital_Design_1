-- Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
-- Copyright 2022-2024 Advanced Micro Devices, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2024.1 (win64) Build 5076996 Wed May 22 18:37:14 MDT 2024
-- Date        : Wed Oct  8 16:46:49 2025
-- Host        : SusannesPC running 64-bit major release  (build 9200)
-- Command     : write_vhdl -mode funcsim -nolib -force -file
--               C:/Users/susan/Documents/studiene/DDS1/TFE4141_Digital_Design_1/oving/oving_5/assignment_5/assignment_5/assignment_5/assignment_5.sim/sim_1/impl/func/xsim/assignment_5_tb_func_impl.vhd
-- Design      : assignment_5
-- Purpose     : This VHDL netlist is a functional simulation representation of the design and should not be modified or
--               synthesized. This netlist cannot be used for SDF annotated simulation.
-- Device      : xc7z020clg400-1
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity ALU is
  port (
    data2 : out STD_LOGIC_VECTOR ( 15 downto 0 );
    CO : out STD_LOGIC_VECTOR ( 0 to 0 );
    \reg0_reg[14]\ : out STD_LOGIC_VECTOR ( 0 to 0 );
    bus_a : in STD_LOGIC_VECTOR ( 14 downto 0 );
    S : in STD_LOGIC_VECTOR ( 3 downto 0 );
    \data_out_reg[7]\ : in STD_LOGIC_VECTOR ( 3 downto 0 );
    \data_out_reg[11]\ : in STD_LOGIC_VECTOR ( 3 downto 0 );
    \data_out_reg[15]\ : in STD_LOGIC_VECTOR ( 3 downto 0 );
    \input_equal0_carry__0_0\ : in STD_LOGIC_VECTOR ( 3 downto 0 );
    \FSM_sequential_state_reg[2]\ : in STD_LOGIC_VECTOR ( 1 downto 0 );
    DI : in STD_LOGIC_VECTOR ( 3 downto 0 );
    \input_greater0_carry__0_0\ : in STD_LOGIC_VECTOR ( 3 downto 0 );
    \FSM_sequential_state_reg[2]_0\ : in STD_LOGIC_VECTOR ( 3 downto 0 );
    \FSM_sequential_state_reg[2]_1\ : in STD_LOGIC_VECTOR ( 3 downto 0 )
  );
end ALU;

architecture STRUCTURE of ALU is
  signal \data_out0_inferred__0/i__carry__0_n_0\ : STD_LOGIC;
  signal \data_out0_inferred__0/i__carry__1_n_0\ : STD_LOGIC;
  signal \data_out0_inferred__0/i__carry_n_0\ : STD_LOGIC;
  signal input_equal0_carry_n_0 : STD_LOGIC;
  signal input_greater0_carry_n_0 : STD_LOGIC;
  signal \NLW_data_out0_inferred__0/i__carry_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal \NLW_data_out0_inferred__0/i__carry__0_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal \NLW_data_out0_inferred__0/i__carry__1_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal \NLW_data_out0_inferred__0/i__carry__2_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_input_equal0_carry_CO_UNCONNECTED : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal NLW_input_equal0_carry_O_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_input_equal0_carry__0_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_input_equal0_carry__0_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal NLW_input_greater0_carry_CO_UNCONNECTED : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal NLW_input_greater0_carry_O_UNCONNECTED : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \NLW_input_greater0_carry__0_CO_UNCONNECTED\ : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal \NLW_input_greater0_carry__0_O_UNCONNECTED\ : STD_LOGIC_VECTOR ( 3 downto 0 );
  attribute ADDER_THRESHOLD : integer;
  attribute ADDER_THRESHOLD of \data_out0_inferred__0/i__carry\ : label is 35;
  attribute ADDER_THRESHOLD of \data_out0_inferred__0/i__carry__0\ : label is 35;
  attribute ADDER_THRESHOLD of \data_out0_inferred__0/i__carry__1\ : label is 35;
  attribute ADDER_THRESHOLD of \data_out0_inferred__0/i__carry__2\ : label is 35;
  attribute COMPARATOR_THRESHOLD : integer;
  attribute COMPARATOR_THRESHOLD of input_greater0_carry : label is 11;
  attribute COMPARATOR_THRESHOLD of \input_greater0_carry__0\ : label is 11;
begin
\data_out0_inferred__0/i__carry\: unisim.vcomponents.CARRY4
     port map (
      CI => '0',
      CO(3) => \data_out0_inferred__0/i__carry_n_0\,
      CO(2 downto 0) => \NLW_data_out0_inferred__0/i__carry_CO_UNCONNECTED\(2 downto 0),
      CYINIT => '1',
      DI(3 downto 0) => bus_a(3 downto 0),
      O(3 downto 0) => data2(3 downto 0),
      S(3 downto 0) => S(3 downto 0)
    );
\data_out0_inferred__0/i__carry__0\: unisim.vcomponents.CARRY4
     port map (
      CI => \data_out0_inferred__0/i__carry_n_0\,
      CO(3) => \data_out0_inferred__0/i__carry__0_n_0\,
      CO(2 downto 0) => \NLW_data_out0_inferred__0/i__carry__0_CO_UNCONNECTED\(2 downto 0),
      CYINIT => '0',
      DI(3 downto 0) => bus_a(7 downto 4),
      O(3 downto 0) => data2(7 downto 4),
      S(3 downto 0) => \data_out_reg[7]\(3 downto 0)
    );
\data_out0_inferred__0/i__carry__1\: unisim.vcomponents.CARRY4
     port map (
      CI => \data_out0_inferred__0/i__carry__0_n_0\,
      CO(3) => \data_out0_inferred__0/i__carry__1_n_0\,
      CO(2 downto 0) => \NLW_data_out0_inferred__0/i__carry__1_CO_UNCONNECTED\(2 downto 0),
      CYINIT => '0',
      DI(3 downto 0) => bus_a(11 downto 8),
      O(3 downto 0) => data2(11 downto 8),
      S(3 downto 0) => \data_out_reg[11]\(3 downto 0)
    );
\data_out0_inferred__0/i__carry__2\: unisim.vcomponents.CARRY4
     port map (
      CI => \data_out0_inferred__0/i__carry__1_n_0\,
      CO(3 downto 0) => \NLW_data_out0_inferred__0/i__carry__2_CO_UNCONNECTED\(3 downto 0),
      CYINIT => '0',
      DI(3) => '0',
      DI(2 downto 0) => bus_a(14 downto 12),
      O(3 downto 0) => data2(15 downto 12),
      S(3 downto 0) => \data_out_reg[15]\(3 downto 0)
    );
input_equal0_carry: unisim.vcomponents.CARRY4
     port map (
      CI => '0',
      CO(3) => input_equal0_carry_n_0,
      CO(2 downto 0) => NLW_input_equal0_carry_CO_UNCONNECTED(2 downto 0),
      CYINIT => '1',
      DI(3 downto 0) => B"0000",
      O(3 downto 0) => NLW_input_equal0_carry_O_UNCONNECTED(3 downto 0),
      S(3 downto 0) => \input_equal0_carry__0_0\(3 downto 0)
    );
\input_equal0_carry__0\: unisim.vcomponents.CARRY4
     port map (
      CI => input_equal0_carry_n_0,
      CO(3 downto 2) => \NLW_input_equal0_carry__0_CO_UNCONNECTED\(3 downto 2),
      CO(1) => CO(0),
      CO(0) => \NLW_input_equal0_carry__0_CO_UNCONNECTED\(0),
      CYINIT => '0',
      DI(3 downto 0) => B"0000",
      O(3 downto 0) => \NLW_input_equal0_carry__0_O_UNCONNECTED\(3 downto 0),
      S(3 downto 2) => B"00",
      S(1 downto 0) => \FSM_sequential_state_reg[2]\(1 downto 0)
    );
input_greater0_carry: unisim.vcomponents.CARRY4
     port map (
      CI => '0',
      CO(3) => input_greater0_carry_n_0,
      CO(2 downto 0) => NLW_input_greater0_carry_CO_UNCONNECTED(2 downto 0),
      CYINIT => '0',
      DI(3 downto 0) => DI(3 downto 0),
      O(3 downto 0) => NLW_input_greater0_carry_O_UNCONNECTED(3 downto 0),
      S(3 downto 0) => \input_greater0_carry__0_0\(3 downto 0)
    );
\input_greater0_carry__0\: unisim.vcomponents.CARRY4
     port map (
      CI => input_greater0_carry_n_0,
      CO(3) => \reg0_reg[14]\(0),
      CO(2 downto 0) => \NLW_input_greater0_carry__0_CO_UNCONNECTED\(2 downto 0),
      CYINIT => '0',
      DI(3 downto 0) => \FSM_sequential_state_reg[2]_0\(3 downto 0),
      O(3 downto 0) => \NLW_input_greater0_carry__0_O_UNCONNECTED\(3 downto 0),
      S(3 downto 0) => \FSM_sequential_state_reg[2]_1\(3 downto 0)
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity controller is
  port (
    S : out STD_LOGIC_VECTOR ( 3 downto 0 );
    \reg1_reg[7]\ : out STD_LOGIC_VECTOR ( 3 downto 0 );
    \reg1_reg[15]\ : out STD_LOGIC_VECTOR ( 3 downto 0 );
    \reg1_reg[11]\ : out STD_LOGIC_VECTOR ( 3 downto 0 );
    reset_n : out STD_LOGIC;
    \reg1_reg[15]_0\ : out STD_LOGIC_VECTOR ( 1 downto 0 );
    \reg1_reg[10]\ : out STD_LOGIC_VECTOR ( 3 downto 0 );
    bus_a : out STD_LOGIC_VECTOR ( 14 downto 0 );
    \reg0_reg[6]\ : out STD_LOGIC_VECTOR ( 3 downto 0 );
    DI : out STD_LOGIC_VECTOR ( 3 downto 0 );
    \reg0_reg[14]\ : out STD_LOGIC_VECTOR ( 3 downto 0 );
    \reg0_reg[14]_0\ : out STD_LOGIC_VECTOR ( 3 downto 0 );
    D : out STD_LOGIC_VECTOR ( 15 downto 0 );
    write_select : out STD_LOGIC_VECTOR ( 2 downto 0 );
    valid_out_OBUF : out STD_LOGIC;
    ready_in_OBUF : out STD_LOGIC;
    data_in_IBUF : in STD_LOGIC_VECTOR ( 15 downto 0 );
    Q : in STD_LOGIC_VECTOR ( 15 downto 0 );
    \data_out_reg[15]\ : in STD_LOGIC_VECTOR ( 15 downto 0 );
    reset_n_IBUF : in STD_LOGIC;
    CLK : in STD_LOGIC;
    data2 : in STD_LOGIC_VECTOR ( 15 downto 0 );
    \FSM_sequential_state_reg[2]_0\ : in STD_LOGIC_VECTOR ( 0 to 0 );
    CO : in STD_LOGIC_VECTOR ( 0 to 0 );
    valid_in_IBUF : in STD_LOGIC;
    ready_out_IBUF : in STD_LOGIC
  );
end controller;

architecture STRUCTURE of controller is
  signal \FSM_sequential_state[2]_i_3_n_0\ : STD_LOGIC;
  signal \^bus_a\ : STD_LOGIC_VECTOR ( 14 downto 0 );
  signal \input_equal0_carry__0_i_3_n_0\ : STD_LOGIC;
  signal \input_equal0_carry__0_i_4_n_0\ : STD_LOGIC;
  signal input_equal0_carry_i_10_n_0 : STD_LOGIC;
  signal input_equal0_carry_i_11_n_0 : STD_LOGIC;
  signal input_equal0_carry_i_12_n_0 : STD_LOGIC;
  signal input_equal0_carry_i_5_n_0 : STD_LOGIC;
  signal input_equal0_carry_i_6_n_0 : STD_LOGIC;
  signal input_equal0_carry_i_7_n_0 : STD_LOGIC;
  signal input_equal0_carry_i_8_n_0 : STD_LOGIC;
  signal input_equal0_carry_i_9_n_0 : STD_LOGIC;
  signal \input_greater0_carry__0_i_10_n_0\ : STD_LOGIC;
  signal \input_greater0_carry__0_i_11_n_0\ : STD_LOGIC;
  signal \input_greater0_carry__0_i_12_n_0\ : STD_LOGIC;
  signal \input_greater0_carry__0_i_13_n_0\ : STD_LOGIC;
  signal \input_greater0_carry__0_i_14_n_0\ : STD_LOGIC;
  signal \input_greater0_carry__0_i_9_n_0\ : STD_LOGIC;
  signal input_greater0_carry_i_10_n_0 : STD_LOGIC;
  signal input_greater0_carry_i_11_n_0 : STD_LOGIC;
  signal input_greater0_carry_i_12_n_0 : STD_LOGIC;
  signal input_greater0_carry_i_9_n_0 : STD_LOGIC;
  signal \reg1[10]_i_2_n_0\ : STD_LOGIC;
  signal \reg1[13]_i_2_n_0\ : STD_LOGIC;
  signal \reg1[15]_i_3_n_0\ : STD_LOGIC;
  signal \reg1[15]_i_4_n_0\ : STD_LOGIC;
  signal \reg1[15]_i_5_n_0\ : STD_LOGIC;
  signal \reg1[1]_i_2_n_0\ : STD_LOGIC;
  signal \reg1[4]_i_2_n_0\ : STD_LOGIC;
  signal \reg1[7]_i_2_n_0\ : STD_LOGIC;
  signal \^reset_n\ : STD_LOGIC;
  signal state : STD_LOGIC_VECTOR ( 2 downto 0 );
  signal state_next : STD_LOGIC_VECTOR ( 2 downto 0 );
  attribute FSM_ENCODED_STATES : string;
  attribute FSM_ENCODED_STATES of \FSM_sequential_state_reg[0]\ : label is "read_b:010,sub_ba:100,sub_ab:011,wait_output:101,read_a:001,iSTATE:000";
  attribute FSM_ENCODED_STATES of \FSM_sequential_state_reg[1]\ : label is "read_b:010,sub_ba:100,sub_ab:011,wait_output:101,read_a:001,iSTATE:000";
  attribute FSM_ENCODED_STATES of \FSM_sequential_state_reg[2]\ : label is "read_b:010,sub_ba:100,sub_ab:011,wait_output:101,read_a:001,iSTATE:000";
begin
  bus_a(14 downto 0) <= \^bus_a\(14 downto 0);
  reset_n <= \^reset_n\;
\FSM_sequential_state[0]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFFFFFFF0FFEF0F"
    )
        port map (
      I0 => CO(0),
      I1 => \FSM_sequential_state_reg[2]_0\(0),
      I2 => state(1),
      I3 => valid_in_IBUF,
      I4 => state(0),
      I5 => state(2),
      O => state_next(0)
    );
\FSM_sequential_state[1]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000064646424"
    )
        port map (
      I0 => state(0),
      I1 => state(1),
      I2 => valid_in_IBUF,
      I3 => CO(0),
      I4 => \FSM_sequential_state_reg[2]_0\(0),
      I5 => state(2),
      O => state_next(1)
    );
\FSM_sequential_state[2]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"00000000FFFF10FF"
    )
        port map (
      I0 => \FSM_sequential_state_reg[2]_0\(0),
      I1 => CO(0),
      I2 => valid_in_IBUF,
      I3 => state(1),
      I4 => state(0),
      I5 => \FSM_sequential_state[2]_i_3_n_0\,
      O => state_next(2)
    );
\FSM_sequential_state[2]_i_2\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => reset_n_IBUF,
      O => \^reset_n\
    );
\FSM_sequential_state[2]_i_3\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"D999"
    )
        port map (
      I0 => state(1),
      I1 => state(2),
      I2 => state(0),
      I3 => ready_out_IBUF,
      O => \FSM_sequential_state[2]_i_3_n_0\
    );
\FSM_sequential_state_reg[0]\: unisim.vcomponents.FDPE
    generic map(
      INIT => '0'
    )
        port map (
      C => CLK,
      CE => '1',
      D => state_next(0),
      PRE => \^reset_n\,
      Q => state(0)
    );
\FSM_sequential_state_reg[1]\: unisim.vcomponents.FDCE
    generic map(
      INIT => '0'
    )
        port map (
      C => CLK,
      CE => '1',
      CLR => \^reset_n\,
      D => state_next(1),
      Q => state(1)
    );
\FSM_sequential_state_reg[2]\: unisim.vcomponents.FDCE
    generic map(
      INIT => '0'
    )
        port map (
      C => CLK,
      CE => '1',
      CLR => \^reset_n\,
      D => state_next(2),
      Q => state(2)
    );
\data_out[15]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"24"
    )
        port map (
      I0 => state(0),
      I1 => state(2),
      I2 => state(1),
      O => write_select(2)
    );
\i__carry__0_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"EFE44F44"
    )
        port map (
      I0 => \reg1[15]_i_5_n_0\,
      I1 => data_in_IBUF(7),
      I2 => \reg1[15]_i_4_n_0\,
      I3 => Q(7),
      I4 => \data_out_reg[15]\(7),
      O => \^bus_a\(7)
    );
\i__carry__0_i_2\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"F0AACCEE"
    )
        port map (
      I0 => Q(6),
      I1 => data_in_IBUF(6),
      I2 => \data_out_reg[15]\(6),
      I3 => \reg1[15]_i_4_n_0\,
      I4 => \reg1[15]_i_5_n_0\,
      O => \^bus_a\(6)
    );
\i__carry__0_i_3\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"F0AACCEE"
    )
        port map (
      I0 => Q(5),
      I1 => data_in_IBUF(5),
      I2 => \data_out_reg[15]\(5),
      I3 => \reg1[15]_i_4_n_0\,
      I4 => \reg1[15]_i_5_n_0\,
      O => \^bus_a\(5)
    );
\i__carry__0_i_4\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"EFE44F44"
    )
        port map (
      I0 => \reg1[15]_i_5_n_0\,
      I1 => data_in_IBUF(4),
      I2 => \reg1[15]_i_4_n_0\,
      I3 => Q(4),
      I4 => \data_out_reg[15]\(4),
      O => \^bus_a\(4)
    );
\i__carry__0_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"EF1BEFE44FBBB0BB"
    )
        port map (
      I0 => \reg1[15]_i_5_n_0\,
      I1 => data_in_IBUF(7),
      I2 => \reg1[15]_i_4_n_0\,
      I3 => Q(7),
      I4 => \reg1[15]_i_3_n_0\,
      I5 => \data_out_reg[15]\(7),
      O => \reg1_reg[7]\(3)
    );
\i__carry__0_i_6\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FB27FBD873AF8CAF"
    )
        port map (
      I0 => \reg1[15]_i_5_n_0\,
      I1 => \reg1[15]_i_4_n_0\,
      I2 => data_in_IBUF(6),
      I3 => Q(6),
      I4 => \reg1[15]_i_3_n_0\,
      I5 => \data_out_reg[15]\(6),
      O => \reg1_reg[7]\(2)
    );
\i__carry__0_i_7\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FB27FBD873AF8CAF"
    )
        port map (
      I0 => \reg1[15]_i_5_n_0\,
      I1 => \reg1[15]_i_4_n_0\,
      I2 => data_in_IBUF(5),
      I3 => Q(5),
      I4 => \reg1[15]_i_3_n_0\,
      I5 => \data_out_reg[15]\(5),
      O => \reg1_reg[7]\(1)
    );
\i__carry__0_i_8\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"EF1BEFE44FBBB0BB"
    )
        port map (
      I0 => \reg1[15]_i_5_n_0\,
      I1 => data_in_IBUF(4),
      I2 => \reg1[15]_i_4_n_0\,
      I3 => Q(4),
      I4 => \reg1[15]_i_3_n_0\,
      I5 => \data_out_reg[15]\(4),
      O => \reg1_reg[7]\(0)
    );
\i__carry__1_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"F0AACCEE"
    )
        port map (
      I0 => Q(11),
      I1 => data_in_IBUF(11),
      I2 => \data_out_reg[15]\(11),
      I3 => \reg1[15]_i_4_n_0\,
      I4 => \reg1[15]_i_5_n_0\,
      O => \^bus_a\(11)
    );
\i__carry__1_i_2\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"EFE44F44"
    )
        port map (
      I0 => \reg1[15]_i_5_n_0\,
      I1 => data_in_IBUF(10),
      I2 => \reg1[15]_i_4_n_0\,
      I3 => Q(10),
      I4 => \data_out_reg[15]\(10),
      O => \^bus_a\(10)
    );
\i__carry__1_i_3\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"ACACFF0C"
    )
        port map (
      I0 => \data_out_reg[15]\(9),
      I1 => Q(9),
      I2 => \reg1[15]_i_4_n_0\,
      I3 => data_in_IBUF(9),
      I4 => \reg1[15]_i_5_n_0\,
      O => \^bus_a\(9)
    );
\i__carry__1_i_4\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"B8B8FF30"
    )
        port map (
      I0 => \data_out_reg[15]\(8),
      I1 => \reg1[15]_i_5_n_0\,
      I2 => data_in_IBUF(8),
      I3 => Q(8),
      I4 => \reg1[15]_i_4_n_0\,
      O => \^bus_a\(8)
    );
\i__carry__1_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FB27FBD873AF8CAF"
    )
        port map (
      I0 => \reg1[15]_i_5_n_0\,
      I1 => \reg1[15]_i_4_n_0\,
      I2 => data_in_IBUF(11),
      I3 => Q(11),
      I4 => \reg1[15]_i_3_n_0\,
      I5 => \data_out_reg[15]\(11),
      O => \reg1_reg[11]\(3)
    );
\i__carry__1_i_6\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"B7EDB7EDE2E21DED"
    )
        port map (
      I0 => \data_out_reg[15]\(10),
      I1 => \reg1[15]_i_3_n_0\,
      I2 => Q(10),
      I3 => \reg1[15]_i_4_n_0\,
      I4 => data_in_IBUF(10),
      I5 => \reg1[15]_i_5_n_0\,
      O => \reg1_reg[11]\(2)
    );
\i__carry__1_i_7\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"EF4FEFB01BBBE4BB"
    )
        port map (
      I0 => \reg1[15]_i_5_n_0\,
      I1 => data_in_IBUF(9),
      I2 => \reg1[15]_i_4_n_0\,
      I3 => \data_out_reg[15]\(9),
      I4 => \reg1[15]_i_3_n_0\,
      I5 => Q(9),
      O => \reg1_reg[11]\(1)
    );
\i__carry__1_i_8\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"B7B8B747EDB8EDED"
    )
        port map (
      I0 => Q(8),
      I1 => \reg1[15]_i_3_n_0\,
      I2 => \data_out_reg[15]\(8),
      I3 => \reg1[15]_i_5_n_0\,
      I4 => data_in_IBUF(8),
      I5 => \reg1[15]_i_4_n_0\,
      O => \reg1_reg[11]\(0)
    );
\i__carry__2_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"CFAFC0AA"
    )
        port map (
      I0 => Q(14),
      I1 => \data_out_reg[15]\(14),
      I2 => \reg1[15]_i_5_n_0\,
      I3 => \reg1[15]_i_4_n_0\,
      I4 => data_in_IBUF(14),
      O => \^bus_a\(14)
    );
\i__carry__2_i_2\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"EFE44F44"
    )
        port map (
      I0 => \reg1[15]_i_5_n_0\,
      I1 => data_in_IBUF(13),
      I2 => \reg1[15]_i_4_n_0\,
      I3 => Q(13),
      I4 => \data_out_reg[15]\(13),
      O => \^bus_a\(13)
    );
\i__carry__2_i_3\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"F0AACCEE"
    )
        port map (
      I0 => Q(12),
      I1 => data_in_IBUF(12),
      I2 => \data_out_reg[15]\(12),
      I3 => \reg1[15]_i_4_n_0\,
      I4 => \reg1[15]_i_5_n_0\,
      O => \^bus_a\(12)
    );
\i__carry__2_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9AFA95FFFC9CF399"
    )
        port map (
      I0 => Q(15),
      I1 => \data_out_reg[15]\(15),
      I2 => \reg1[15]_i_5_n_0\,
      I3 => \reg1[15]_i_4_n_0\,
      I4 => data_in_IBUF(15),
      I5 => \reg1[15]_i_3_n_0\,
      O => \reg1_reg[15]\(3)
    );
\i__carry__2_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FB3BFBC435F5CAF5"
    )
        port map (
      I0 => data_in_IBUF(14),
      I1 => \reg1[15]_i_4_n_0\,
      I2 => \reg1[15]_i_5_n_0\,
      I3 => \data_out_reg[15]\(14),
      I4 => \reg1[15]_i_3_n_0\,
      I5 => Q(14),
      O => \reg1_reg[15]\(2)
    );
\i__carry__2_i_6\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"B7EDB7EDE2E21DED"
    )
        port map (
      I0 => \data_out_reg[15]\(13),
      I1 => \reg1[15]_i_3_n_0\,
      I2 => Q(13),
      I3 => \reg1[15]_i_4_n_0\,
      I4 => data_in_IBUF(13),
      I5 => \reg1[15]_i_5_n_0\,
      O => \reg1_reg[15]\(1)
    );
\i__carry__2_i_7\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FB27FBD873AF8CAF"
    )
        port map (
      I0 => \reg1[15]_i_5_n_0\,
      I1 => \reg1[15]_i_4_n_0\,
      I2 => data_in_IBUF(12),
      I3 => Q(12),
      I4 => \reg1[15]_i_3_n_0\,
      I5 => \data_out_reg[15]\(12),
      O => \reg1_reg[15]\(0)
    );
\i__carry_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"ACACFF0C"
    )
        port map (
      I0 => \data_out_reg[15]\(3),
      I1 => Q(3),
      I2 => \reg1[15]_i_4_n_0\,
      I3 => data_in_IBUF(3),
      I4 => \reg1[15]_i_5_n_0\,
      O => \^bus_a\(3)
    );
\i__carry_i_2\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"F0AACCEE"
    )
        port map (
      I0 => Q(2),
      I1 => data_in_IBUF(2),
      I2 => \data_out_reg[15]\(2),
      I3 => \reg1[15]_i_4_n_0\,
      I4 => \reg1[15]_i_5_n_0\,
      O => \^bus_a\(2)
    );
\i__carry_i_3\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"EFE44F44"
    )
        port map (
      I0 => \reg1[15]_i_5_n_0\,
      I1 => data_in_IBUF(1),
      I2 => \reg1[15]_i_4_n_0\,
      I3 => Q(1),
      I4 => \data_out_reg[15]\(1),
      O => \^bus_a\(1)
    );
\i__carry_i_4\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"F0AACCEE"
    )
        port map (
      I0 => Q(0),
      I1 => data_in_IBUF(0),
      I2 => \data_out_reg[15]\(0),
      I3 => \reg1[15]_i_4_n_0\,
      I4 => \reg1[15]_i_5_n_0\,
      O => \^bus_a\(0)
    );
\i__carry_i_5\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"EF4FEFB01BBBE4BB"
    )
        port map (
      I0 => \reg1[15]_i_5_n_0\,
      I1 => data_in_IBUF(3),
      I2 => \reg1[15]_i_4_n_0\,
      I3 => \data_out_reg[15]\(3),
      I4 => \reg1[15]_i_3_n_0\,
      I5 => Q(3),
      O => S(3)
    );
\i__carry_i_6\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FB27FBD873AF8CAF"
    )
        port map (
      I0 => \reg1[15]_i_5_n_0\,
      I1 => \reg1[15]_i_4_n_0\,
      I2 => data_in_IBUF(2),
      I3 => Q(2),
      I4 => \reg1[15]_i_3_n_0\,
      I5 => \data_out_reg[15]\(2),
      O => S(2)
    );
\i__carry_i_7\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"EF1BEFE44FBBB0BB"
    )
        port map (
      I0 => \reg1[15]_i_5_n_0\,
      I1 => data_in_IBUF(1),
      I2 => \reg1[15]_i_4_n_0\,
      I3 => Q(1),
      I4 => \reg1[15]_i_3_n_0\,
      I5 => \data_out_reg[15]\(1),
      O => S(1)
    );
\i__carry_i_8\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FB27FBD873AF8CAF"
    )
        port map (
      I0 => \reg1[15]_i_5_n_0\,
      I1 => \reg1[15]_i_4_n_0\,
      I2 => data_in_IBUF(0),
      I3 => Q(0),
      I4 => \reg1[15]_i_3_n_0\,
      I5 => \data_out_reg[15]\(0),
      O => S(0)
    );
\input_equal0_carry__0_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9AFA95FFFC9CF399"
    )
        port map (
      I0 => Q(15),
      I1 => \data_out_reg[15]\(15),
      I2 => \reg1[15]_i_5_n_0\,
      I3 => \reg1[15]_i_4_n_0\,
      I4 => data_in_IBUF(15),
      I5 => \reg1[15]_i_3_n_0\,
      O => \reg1_reg[15]_0\(1)
    );
\input_equal0_carry__0_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"2002202020020202"
    )
        port map (
      I0 => \input_equal0_carry__0_i_3_n_0\,
      I1 => \input_equal0_carry__0_i_4_n_0\,
      I2 => \^bus_a\(12),
      I3 => Q(12),
      I4 => \reg1[15]_i_3_n_0\,
      I5 => \data_out_reg[15]\(12),
      O => \reg1_reg[15]_0\(0)
    );
\input_equal0_carry__0_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FB3BFBC435F5CAF5"
    )
        port map (
      I0 => data_in_IBUF(14),
      I1 => \reg1[15]_i_4_n_0\,
      I2 => \reg1[15]_i_5_n_0\,
      I3 => \data_out_reg[15]\(14),
      I4 => \reg1[15]_i_3_n_0\,
      I5 => Q(14),
      O => \input_equal0_carry__0_i_3_n_0\
    );
\input_equal0_carry__0_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"10E4101BB0444F44"
    )
        port map (
      I0 => \reg1[15]_i_5_n_0\,
      I1 => data_in_IBUF(13),
      I2 => \reg1[15]_i_4_n_0\,
      I3 => Q(13),
      I4 => \reg1[15]_i_3_n_0\,
      I5 => \data_out_reg[15]\(13),
      O => \input_equal0_carry__0_i_4_n_0\
    );
input_equal0_carry_i_1: unisim.vcomponents.LUT6
    generic map(
      INIT => X"656A000000000000"
    )
        port map (
      I0 => \reg1[10]_i_2_n_0\,
      I1 => Q(10),
      I2 => \reg1[15]_i_3_n_0\,
      I3 => \data_out_reg[15]\(10),
      I4 => input_equal0_carry_i_5_n_0,
      I5 => input_equal0_carry_i_6_n_0,
      O => \reg1_reg[10]\(3)
    );
input_equal0_carry_i_10: unisim.vcomponents.LUT6
    generic map(
      INIT => X"EF4FEFB01BBBE4BB"
    )
        port map (
      I0 => \reg1[15]_i_5_n_0\,
      I1 => data_in_IBUF(3),
      I2 => \reg1[15]_i_4_n_0\,
      I3 => \data_out_reg[15]\(3),
      I4 => \reg1[15]_i_3_n_0\,
      I5 => Q(3),
      O => input_equal0_carry_i_10_n_0
    );
input_equal0_carry_i_11: unisim.vcomponents.LUT6
    generic map(
      INIT => X"EF1BEFE44FBBB0BB"
    )
        port map (
      I0 => \reg1[15]_i_5_n_0\,
      I1 => data_in_IBUF(1),
      I2 => \reg1[15]_i_4_n_0\,
      I3 => Q(1),
      I4 => \reg1[15]_i_3_n_0\,
      I5 => \data_out_reg[15]\(1),
      O => input_equal0_carry_i_11_n_0
    );
input_equal0_carry_i_12: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FB27FBD873AF8CAF"
    )
        port map (
      I0 => \reg1[15]_i_5_n_0\,
      I1 => \reg1[15]_i_4_n_0\,
      I2 => data_in_IBUF(2),
      I3 => Q(2),
      I4 => \reg1[15]_i_3_n_0\,
      I5 => \data_out_reg[15]\(2),
      O => input_equal0_carry_i_12_n_0
    );
input_equal0_carry_i_2: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000082888222"
    )
        port map (
      I0 => input_equal0_carry_i_7_n_0,
      I1 => \^bus_a\(6),
      I2 => Q(6),
      I3 => \reg1[15]_i_3_n_0\,
      I4 => \data_out_reg[15]\(6),
      I5 => input_equal0_carry_i_8_n_0,
      O => \reg1_reg[10]\(2)
    );
input_equal0_carry_i_3: unisim.vcomponents.LUT6
    generic map(
      INIT => X"1DE2000000000000"
    )
        port map (
      I0 => \data_out_reg[15]\(4),
      I1 => \reg1[15]_i_3_n_0\,
      I2 => Q(4),
      I3 => \reg1[4]_i_2_n_0\,
      I4 => input_equal0_carry_i_9_n_0,
      I5 => input_equal0_carry_i_10_n_0,
      O => \reg1_reg[10]\(1)
    );
input_equal0_carry_i_4: unisim.vcomponents.LUT6
    generic map(
      INIT => X"8288822200000000"
    )
        port map (
      I0 => input_equal0_carry_i_11_n_0,
      I1 => \^bus_a\(0),
      I2 => Q(0),
      I3 => \reg1[15]_i_3_n_0\,
      I4 => \data_out_reg[15]\(0),
      I5 => input_equal0_carry_i_12_n_0,
      O => \reg1_reg[10]\(0)
    );
input_equal0_carry_i_5: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FB27FBD873AF8CAF"
    )
        port map (
      I0 => \reg1[15]_i_5_n_0\,
      I1 => \reg1[15]_i_4_n_0\,
      I2 => data_in_IBUF(11),
      I3 => Q(11),
      I4 => \reg1[15]_i_3_n_0\,
      I5 => \data_out_reg[15]\(11),
      O => input_equal0_carry_i_5_n_0
    );
input_equal0_carry_i_6: unisim.vcomponents.LUT6
    generic map(
      INIT => X"EF4FEFB01BBBE4BB"
    )
        port map (
      I0 => \reg1[15]_i_5_n_0\,
      I1 => data_in_IBUF(9),
      I2 => \reg1[15]_i_4_n_0\,
      I3 => \data_out_reg[15]\(9),
      I4 => \reg1[15]_i_3_n_0\,
      I5 => Q(9),
      O => input_equal0_carry_i_6_n_0
    );
input_equal0_carry_i_7: unisim.vcomponents.LUT6
    generic map(
      INIT => X"EF1BEFE44FBBB0BB"
    )
        port map (
      I0 => \reg1[15]_i_5_n_0\,
      I1 => data_in_IBUF(7),
      I2 => \reg1[15]_i_4_n_0\,
      I3 => Q(7),
      I4 => \reg1[15]_i_3_n_0\,
      I5 => \data_out_reg[15]\(7),
      O => input_equal0_carry_i_7_n_0
    );
input_equal0_carry_i_8: unisim.vcomponents.LUT6
    generic map(
      INIT => X"02A2025DAC0C530C"
    )
        port map (
      I0 => \reg1[15]_i_4_n_0\,
      I1 => data_in_IBUF(8),
      I2 => \reg1[15]_i_5_n_0\,
      I3 => \data_out_reg[15]\(8),
      I4 => \reg1[15]_i_3_n_0\,
      I5 => Q(8),
      O => input_equal0_carry_i_8_n_0
    );
input_equal0_carry_i_9: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FB27FBD873AF8CAF"
    )
        port map (
      I0 => \reg1[15]_i_5_n_0\,
      I1 => \reg1[15]_i_4_n_0\,
      I2 => data_in_IBUF(5),
      I3 => Q(5),
      I4 => \reg1[15]_i_3_n_0\,
      I5 => \data_out_reg[15]\(5),
      O => input_equal0_carry_i_9_n_0
    );
\input_greater0_carry__0_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"222222B2B2B222B2"
    )
        port map (
      I0 => \input_greater0_carry__0_i_9_n_0\,
      I1 => \input_greater0_carry__0_i_10_n_0\,
      I2 => \^bus_a\(14),
      I3 => \data_out_reg[15]\(14),
      I4 => \reg1[15]_i_3_n_0\,
      I5 => Q(14),
      O => \reg0_reg[14]_0\(3)
    );
\input_greater0_carry__0_i_10\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"30503F55"
    )
        port map (
      I0 => Q(15),
      I1 => \data_out_reg[15]\(15),
      I2 => \reg1[15]_i_5_n_0\,
      I3 => \reg1[15]_i_4_n_0\,
      I4 => data_in_IBUF(15),
      O => \input_greater0_carry__0_i_10_n_0\
    );
\input_greater0_carry__0_i_11\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"55455575"
    )
        port map (
      I0 => \data_out_reg[15]\(13),
      I1 => state(0),
      I2 => state(2),
      I3 => state(1),
      I4 => Q(13),
      O => \input_greater0_carry__0_i_11_n_0\
    );
\input_greater0_carry__0_i_12\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"55455575"
    )
        port map (
      I0 => \data_out_reg[15]\(11),
      I1 => state(0),
      I2 => state(2),
      I3 => state(1),
      I4 => Q(11),
      O => \input_greater0_carry__0_i_12_n_0\
    );
\input_greater0_carry__0_i_13\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"0010FFDF"
    )
        port map (
      I0 => Q(9),
      I1 => state(0),
      I2 => state(2),
      I3 => state(1),
      I4 => \data_out_reg[15]\(9),
      O => \input_greater0_carry__0_i_13_n_0\
    );
\input_greater0_carry__0_i_14\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0030A565A59900CC"
    )
        port map (
      I0 => \reg1[15]_i_3_n_0\,
      I1 => data_in_IBUF(15),
      I2 => \reg1[15]_i_4_n_0\,
      I3 => \reg1[15]_i_5_n_0\,
      I4 => \data_out_reg[15]\(15),
      I5 => Q(15),
      O => \input_greater0_carry__0_i_14_n_0\
    );
\input_greater0_carry__0_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"44D4444444D4D4D4"
    )
        port map (
      I0 => \reg1[13]_i_2_n_0\,
      I1 => \input_greater0_carry__0_i_11_n_0\,
      I2 => \^bus_a\(12),
      I3 => Q(12),
      I4 => \reg1[15]_i_3_n_0\,
      I5 => \data_out_reg[15]\(12),
      O => \reg0_reg[14]_0\(2)
    );
\input_greater0_carry__0_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"888888888E888EEE"
    )
        port map (
      I0 => \^bus_a\(11),
      I1 => \input_greater0_carry__0_i_12_n_0\,
      I2 => Q(10),
      I3 => \reg1[15]_i_3_n_0\,
      I4 => \data_out_reg[15]\(10),
      I5 => \reg1[10]_i_2_n_0\,
      O => \reg0_reg[14]_0\(1)
    );
\input_greater0_carry__0_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFF02A202A20000"
    )
        port map (
      I0 => \^bus_a\(8),
      I1 => \data_out_reg[15]\(8),
      I2 => \reg1[15]_i_3_n_0\,
      I3 => Q(8),
      I4 => \^bus_a\(9),
      I5 => \input_greater0_carry__0_i_13_n_0\,
      O => \reg0_reg[14]_0\(0)
    );
\input_greater0_carry__0_i_5\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"2"
    )
        port map (
      I0 => \input_equal0_carry__0_i_3_n_0\,
      I1 => \input_greater0_carry__0_i_14_n_0\,
      O => \reg0_reg[14]\(3)
    );
\input_greater0_carry__0_i_6\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"0000E21D"
    )
        port map (
      I0 => \data_out_reg[15]\(12),
      I1 => \reg1[15]_i_3_n_0\,
      I2 => Q(12),
      I3 => \^bus_a\(12),
      I4 => \input_equal0_carry__0_i_4_n_0\,
      O => \reg0_reg[14]\(2)
    );
\input_greater0_carry__0_i_7\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"02A2A808"
    )
        port map (
      I0 => input_equal0_carry_i_5_n_0,
      I1 => \data_out_reg[15]\(10),
      I2 => \reg1[15]_i_3_n_0\,
      I3 => Q(10),
      I4 => \reg1[10]_i_2_n_0\,
      O => \reg0_reg[14]\(1)
    );
\input_greater0_carry__0_i_8\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"2"
    )
        port map (
      I0 => input_equal0_carry_i_6_n_0,
      I1 => input_equal0_carry_i_8_n_0,
      O => \reg0_reg[14]\(0)
    );
\input_greater0_carry__0_i_9\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"0010FFDF"
    )
        port map (
      I0 => Q(15),
      I1 => state(0),
      I2 => state(2),
      I3 => state(1),
      I4 => \data_out_reg[15]\(15),
      O => \input_greater0_carry__0_i_9_n_0\
    );
input_greater0_carry_i_1: unisim.vcomponents.LUT6
    generic map(
      INIT => X"22B2222222B2B2B2"
    )
        port map (
      I0 => input_greater0_carry_i_9_n_0,
      I1 => \reg1[7]_i_2_n_0\,
      I2 => \^bus_a\(6),
      I3 => Q(6),
      I4 => \reg1[15]_i_3_n_0\,
      I5 => \data_out_reg[15]\(6),
      O => DI(3)
    );
input_greater0_carry_i_10: unisim.vcomponents.LUT5
    generic map(
      INIT => X"55455575"
    )
        port map (
      I0 => \data_out_reg[15]\(5),
      I1 => state(0),
      I2 => state(2),
      I3 => state(1),
      I4 => Q(5),
      O => input_greater0_carry_i_10_n_0
    );
input_greater0_carry_i_11: unisim.vcomponents.LUT5
    generic map(
      INIT => X"0010FFDF"
    )
        port map (
      I0 => Q(3),
      I1 => state(0),
      I2 => state(2),
      I3 => state(1),
      I4 => \data_out_reg[15]\(3),
      O => input_greater0_carry_i_11_n_0
    );
input_greater0_carry_i_12: unisim.vcomponents.LUT5
    generic map(
      INIT => X"55455575"
    )
        port map (
      I0 => \data_out_reg[15]\(1),
      I1 => state(0),
      I2 => state(2),
      I3 => state(1),
      I4 => Q(1),
      O => input_greater0_carry_i_12_n_0
    );
input_greater0_carry_i_2: unisim.vcomponents.LUT6
    generic map(
      INIT => X"888888888E888EEE"
    )
        port map (
      I0 => \^bus_a\(5),
      I1 => input_greater0_carry_i_10_n_0,
      I2 => Q(4),
      I3 => \reg1[15]_i_3_n_0\,
      I4 => \data_out_reg[15]\(4),
      I5 => \reg1[4]_i_2_n_0\,
      O => DI(2)
    );
input_greater0_carry_i_3: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFFF202A202A0000"
    )
        port map (
      I0 => \^bus_a\(2),
      I1 => Q(2),
      I2 => \reg1[15]_i_3_n_0\,
      I3 => \data_out_reg[15]\(2),
      I4 => \^bus_a\(3),
      I5 => input_greater0_carry_i_11_n_0,
      O => DI(1)
    );
input_greater0_carry_i_4: unisim.vcomponents.LUT6
    generic map(
      INIT => X"22B2222222B2B2B2"
    )
        port map (
      I0 => input_greater0_carry_i_12_n_0,
      I1 => \reg1[1]_i_2_n_0\,
      I2 => \^bus_a\(0),
      I3 => Q(0),
      I4 => \reg1[15]_i_3_n_0\,
      I5 => \data_out_reg[15]\(0),
      O => DI(0)
    );
input_greater0_carry_i_5: unisim.vcomponents.LUT5
    generic map(
      INIT => X"E21D0000"
    )
        port map (
      I0 => \data_out_reg[15]\(6),
      I1 => \reg1[15]_i_3_n_0\,
      I2 => Q(6),
      I3 => \^bus_a\(6),
      I4 => input_equal0_carry_i_7_n_0,
      O => \reg0_reg[6]\(3)
    );
input_greater0_carry_i_6: unisim.vcomponents.LUT5
    generic map(
      INIT => X"28222888"
    )
        port map (
      I0 => input_equal0_carry_i_9_n_0,
      I1 => \reg1[4]_i_2_n_0\,
      I2 => Q(4),
      I3 => \reg1[15]_i_3_n_0\,
      I4 => \data_out_reg[15]\(4),
      O => \reg0_reg[6]\(2)
    );
input_greater0_carry_i_7: unisim.vcomponents.LUT5
    generic map(
      INIT => X"82888222"
    )
        port map (
      I0 => input_equal0_carry_i_10_n_0,
      I1 => \^bus_a\(2),
      I2 => Q(2),
      I3 => \reg1[15]_i_3_n_0\,
      I4 => \data_out_reg[15]\(2),
      O => \reg0_reg[6]\(1)
    );
input_greater0_carry_i_8: unisim.vcomponents.LUT5
    generic map(
      INIT => X"E21D0000"
    )
        port map (
      I0 => \data_out_reg[15]\(0),
      I1 => \reg1[15]_i_3_n_0\,
      I2 => Q(0),
      I3 => \^bus_a\(0),
      I4 => input_equal0_carry_i_11_n_0,
      O => \reg0_reg[6]\(0)
    );
input_greater0_carry_i_9: unisim.vcomponents.LUT5
    generic map(
      INIT => X"55455575"
    )
        port map (
      I0 => \data_out_reg[15]\(7),
      I1 => state(0),
      I2 => state(2),
      I3 => state(1),
      I4 => Q(7),
      O => input_greater0_carry_i_9_n_0
    );
ready_in_OBUF_inst_i_1: unisim.vcomponents.LUT3
    generic map(
      INIT => X"06"
    )
        port map (
      I0 => state(0),
      I1 => state(1),
      I2 => state(2),
      O => ready_in_OBUF
    );
\reg0[15]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"0040"
    )
        port map (
      I0 => state(1),
      I1 => state(0),
      I2 => valid_in_IBUF,
      I3 => state(2),
      O => write_select(0)
    );
\reg1[0]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FBEF0820"
    )
        port map (
      I0 => data2(0),
      I1 => state(0),
      I2 => state(2),
      I3 => state(1),
      I4 => \^bus_a\(0),
      O => D(0)
    );
\reg1[10]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"0820FBEF"
    )
        port map (
      I0 => data2(10),
      I1 => state(0),
      I2 => state(2),
      I3 => state(1),
      I4 => \reg1[10]_i_2_n_0\,
      O => D(10)
    );
\reg1[10]_i_2\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"535300F3"
    )
        port map (
      I0 => \data_out_reg[15]\(10),
      I1 => Q(10),
      I2 => \reg1[15]_i_4_n_0\,
      I3 => data_in_IBUF(10),
      I4 => \reg1[15]_i_5_n_0\,
      O => \reg1[10]_i_2_n_0\
    );
\reg1[11]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FBEF0820"
    )
        port map (
      I0 => data2(11),
      I1 => state(0),
      I2 => state(2),
      I3 => state(1),
      I4 => \^bus_a\(11),
      O => D(11)
    );
\reg1[12]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FBEF0820"
    )
        port map (
      I0 => data2(12),
      I1 => state(0),
      I2 => state(2),
      I3 => state(1),
      I4 => \^bus_a\(12),
      O => D(12)
    );
\reg1[13]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"0820FBEF"
    )
        port map (
      I0 => data2(13),
      I1 => state(0),
      I2 => state(2),
      I3 => state(1),
      I4 => \reg1[13]_i_2_n_0\,
      O => D(13)
    );
\reg1[13]_i_2\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"535300F3"
    )
        port map (
      I0 => \data_out_reg[15]\(13),
      I1 => Q(13),
      I2 => \reg1[15]_i_4_n_0\,
      I3 => data_in_IBUF(13),
      I4 => \reg1[15]_i_5_n_0\,
      O => \reg1[13]_i_2_n_0\
    );
\reg1[14]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"BABABA8A8A8ABA8A"
    )
        port map (
      I0 => data2(14),
      I1 => \reg1[15]_i_3_n_0\,
      I2 => \reg1[15]_i_4_n_0\,
      I3 => data_in_IBUF(14),
      I4 => \reg1[15]_i_5_n_0\,
      I5 => \data_out_reg[15]\(14),
      O => D(14)
    );
\reg1[15]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"0040"
    )
        port map (
      I0 => state(0),
      I1 => state(1),
      I2 => valid_in_IBUF,
      I3 => state(2),
      O => write_select(1)
    );
\reg1[15]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"BABABA8A8A8ABA8A"
    )
        port map (
      I0 => data2(15),
      I1 => \reg1[15]_i_3_n_0\,
      I2 => \reg1[15]_i_4_n_0\,
      I3 => data_in_IBUF(15),
      I4 => \reg1[15]_i_5_n_0\,
      I5 => \data_out_reg[15]\(15),
      O => D(15)
    );
\reg1[15]_i_3\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"04"
    )
        port map (
      I0 => state(0),
      I1 => state(2),
      I2 => state(1),
      O => \reg1[15]_i_3_n_0\
    );
\reg1[15]_i_4\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"DF"
    )
        port map (
      I0 => state(1),
      I1 => state(2),
      I2 => state(0),
      O => \reg1[15]_i_4_n_0\
    );
\reg1[15]_i_5\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FDDF"
    )
        port map (
      I0 => valid_in_IBUF,
      I1 => state(2),
      I2 => state(0),
      I3 => state(1),
      O => \reg1[15]_i_5_n_0\
    );
\reg1[1]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"0820FBEF"
    )
        port map (
      I0 => data2(1),
      I1 => state(0),
      I2 => state(2),
      I3 => state(1),
      I4 => \reg1[1]_i_2_n_0\,
      O => D(1)
    );
\reg1[1]_i_2\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"535300F3"
    )
        port map (
      I0 => \data_out_reg[15]\(1),
      I1 => Q(1),
      I2 => \reg1[15]_i_4_n_0\,
      I3 => data_in_IBUF(1),
      I4 => \reg1[15]_i_5_n_0\,
      O => \reg1[1]_i_2_n_0\
    );
\reg1[2]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FBEF0820"
    )
        port map (
      I0 => data2(2),
      I1 => state(0),
      I2 => state(2),
      I3 => state(1),
      I4 => \^bus_a\(2),
      O => D(2)
    );
\reg1[3]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FBEF0820"
    )
        port map (
      I0 => data2(3),
      I1 => state(0),
      I2 => state(2),
      I3 => state(1),
      I4 => \^bus_a\(3),
      O => D(3)
    );
\reg1[4]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"0820FBEF"
    )
        port map (
      I0 => data2(4),
      I1 => state(0),
      I2 => state(2),
      I3 => state(1),
      I4 => \reg1[4]_i_2_n_0\,
      O => D(4)
    );
\reg1[4]_i_2\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"535300F3"
    )
        port map (
      I0 => \data_out_reg[15]\(4),
      I1 => Q(4),
      I2 => \reg1[15]_i_4_n_0\,
      I3 => data_in_IBUF(4),
      I4 => \reg1[15]_i_5_n_0\,
      O => \reg1[4]_i_2_n_0\
    );
\reg1[5]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FBEF0820"
    )
        port map (
      I0 => data2(5),
      I1 => state(0),
      I2 => state(2),
      I3 => state(1),
      I4 => \^bus_a\(5),
      O => D(5)
    );
\reg1[6]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FBEF0820"
    )
        port map (
      I0 => data2(6),
      I1 => state(0),
      I2 => state(2),
      I3 => state(1),
      I4 => \^bus_a\(6),
      O => D(6)
    );
\reg1[7]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"0820FBEF"
    )
        port map (
      I0 => data2(7),
      I1 => state(0),
      I2 => state(2),
      I3 => state(1),
      I4 => \reg1[7]_i_2_n_0\,
      O => D(7)
    );
\reg1[7]_i_2\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"535300F3"
    )
        port map (
      I0 => \data_out_reg[15]\(7),
      I1 => Q(7),
      I2 => \reg1[15]_i_4_n_0\,
      I3 => data_in_IBUF(7),
      I4 => \reg1[15]_i_5_n_0\,
      O => \reg1[7]_i_2_n_0\
    );
\reg1[8]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"BABABA8A8A8ABA8A"
    )
        port map (
      I0 => data2(8),
      I1 => \reg1[15]_i_3_n_0\,
      I2 => \reg1[15]_i_4_n_0\,
      I3 => data_in_IBUF(8),
      I4 => \reg1[15]_i_5_n_0\,
      I5 => \data_out_reg[15]\(8),
      O => D(8)
    );
\reg1[9]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FBEF0820"
    )
        port map (
      I0 => data2(9),
      I1 => state(0),
      I2 => state(2),
      I3 => state(1),
      I4 => \^bus_a\(9),
      O => D(9)
    );
valid_out_OBUF_inst_i_1: unisim.vcomponents.LUT3
    generic map(
      INIT => X"08"
    )
        port map (
      I0 => state(0),
      I1 => state(2),
      I2 => state(1),
      O => valid_out_OBUF
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity assignment_5 is
  port (
    clk : in STD_LOGIC;
    reset_n : in STD_LOGIC;
    data_in : in STD_LOGIC_VECTOR ( 15 downto 0 );
    ready_in : out STD_LOGIC;
    valid_in : in STD_LOGIC;
    data_out : out STD_LOGIC_VECTOR ( 15 downto 0 );
    ready_out : in STD_LOGIC;
    valid_out : out STD_LOGIC
  );
  attribute NotValidForBitStream : boolean;
  attribute NotValidForBitStream of assignment_5 : entity is true;
  attribute \DesignAttr:ENABLE_AIE_NETLIST_VIEW\ : boolean;
  attribute \DesignAttr:ENABLE_AIE_NETLIST_VIEW\ of assignment_5 : entity is std.standard.true;
  attribute \DesignAttr:ENABLE_NOC_NETLIST_VIEW\ : boolean;
  attribute \DesignAttr:ENABLE_NOC_NETLIST_VIEW\ of assignment_5 : entity is std.standard.true;
  attribute ECO_CHECKSUM : string;
  attribute ECO_CHECKSUM of assignment_5 : entity is "ae7e1b28";
  attribute bit_width : integer;
  attribute bit_width of assignment_5 : entity is 16;
end assignment_5;

architecture STRUCTURE of assignment_5 is
  signal bus_a : STD_LOGIC_VECTOR ( 14 downto 0 );
  signal clk_IBUF : STD_LOGIC;
  signal clk_IBUF_BUFG : STD_LOGIC;
  signal data2 : STD_LOGIC_VECTOR ( 15 downto 0 );
  signal data_in_IBUF : STD_LOGIC_VECTOR ( 15 downto 0 );
  signal data_out_0 : STD_LOGIC_VECTOR ( 15 downto 0 );
  signal data_out_OBUF : STD_LOGIC_VECTOR ( 15 downto 0 );
  signal i_controller_n_0 : STD_LOGIC;
  signal i_controller_n_1 : STD_LOGIC;
  signal i_controller_n_10 : STD_LOGIC;
  signal i_controller_n_11 : STD_LOGIC;
  signal i_controller_n_12 : STD_LOGIC;
  signal i_controller_n_13 : STD_LOGIC;
  signal i_controller_n_14 : STD_LOGIC;
  signal i_controller_n_15 : STD_LOGIC;
  signal i_controller_n_16 : STD_LOGIC;
  signal i_controller_n_17 : STD_LOGIC;
  signal i_controller_n_18 : STD_LOGIC;
  signal i_controller_n_19 : STD_LOGIC;
  signal i_controller_n_2 : STD_LOGIC;
  signal i_controller_n_20 : STD_LOGIC;
  signal i_controller_n_21 : STD_LOGIC;
  signal i_controller_n_22 : STD_LOGIC;
  signal i_controller_n_3 : STD_LOGIC;
  signal i_controller_n_38 : STD_LOGIC;
  signal i_controller_n_39 : STD_LOGIC;
  signal i_controller_n_4 : STD_LOGIC;
  signal i_controller_n_40 : STD_LOGIC;
  signal i_controller_n_41 : STD_LOGIC;
  signal i_controller_n_42 : STD_LOGIC;
  signal i_controller_n_43 : STD_LOGIC;
  signal i_controller_n_44 : STD_LOGIC;
  signal i_controller_n_45 : STD_LOGIC;
  signal i_controller_n_46 : STD_LOGIC;
  signal i_controller_n_47 : STD_LOGIC;
  signal i_controller_n_48 : STD_LOGIC;
  signal i_controller_n_49 : STD_LOGIC;
  signal i_controller_n_5 : STD_LOGIC;
  signal i_controller_n_50 : STD_LOGIC;
  signal i_controller_n_51 : STD_LOGIC;
  signal i_controller_n_52 : STD_LOGIC;
  signal i_controller_n_53 : STD_LOGIC;
  signal i_controller_n_6 : STD_LOGIC;
  signal i_controller_n_7 : STD_LOGIC;
  signal i_controller_n_8 : STD_LOGIC;
  signal i_controller_n_9 : STD_LOGIC;
  signal input_equal : STD_LOGIC;
  signal input_greater : STD_LOGIC;
  signal ready_in_OBUF : STD_LOGIC;
  signal ready_out_IBUF : STD_LOGIC;
  signal reg0 : STD_LOGIC_VECTOR ( 15 downto 0 );
  signal reg1 : STD_LOGIC_VECTOR ( 15 downto 0 );
  signal reset_n_IBUF : STD_LOGIC;
  signal valid_in_IBUF : STD_LOGIC;
  signal valid_out_OBUF : STD_LOGIC;
  signal write_select : STD_LOGIC_VECTOR ( 4 downto 0 );
begin
clk_IBUF_BUFG_inst: unisim.vcomponents.BUFG
     port map (
      I => clk_IBUF,
      O => clk_IBUF_BUFG
    );
clk_IBUF_inst: unisim.vcomponents.IBUF
     port map (
      I => clk,
      O => clk_IBUF
    );
\data_in_IBUF[0]_inst\: unisim.vcomponents.IBUF
     port map (
      I => data_in(0),
      O => data_in_IBUF(0)
    );
\data_in_IBUF[10]_inst\: unisim.vcomponents.IBUF
     port map (
      I => data_in(10),
      O => data_in_IBUF(10)
    );
\data_in_IBUF[11]_inst\: unisim.vcomponents.IBUF
     port map (
      I => data_in(11),
      O => data_in_IBUF(11)
    );
\data_in_IBUF[12]_inst\: unisim.vcomponents.IBUF
     port map (
      I => data_in(12),
      O => data_in_IBUF(12)
    );
\data_in_IBUF[13]_inst\: unisim.vcomponents.IBUF
     port map (
      I => data_in(13),
      O => data_in_IBUF(13)
    );
\data_in_IBUF[14]_inst\: unisim.vcomponents.IBUF
     port map (
      I => data_in(14),
      O => data_in_IBUF(14)
    );
\data_in_IBUF[15]_inst\: unisim.vcomponents.IBUF
     port map (
      I => data_in(15),
      O => data_in_IBUF(15)
    );
\data_in_IBUF[1]_inst\: unisim.vcomponents.IBUF
     port map (
      I => data_in(1),
      O => data_in_IBUF(1)
    );
\data_in_IBUF[2]_inst\: unisim.vcomponents.IBUF
     port map (
      I => data_in(2),
      O => data_in_IBUF(2)
    );
\data_in_IBUF[3]_inst\: unisim.vcomponents.IBUF
     port map (
      I => data_in(3),
      O => data_in_IBUF(3)
    );
\data_in_IBUF[4]_inst\: unisim.vcomponents.IBUF
     port map (
      I => data_in(4),
      O => data_in_IBUF(4)
    );
\data_in_IBUF[5]_inst\: unisim.vcomponents.IBUF
     port map (
      I => data_in(5),
      O => data_in_IBUF(5)
    );
\data_in_IBUF[6]_inst\: unisim.vcomponents.IBUF
     port map (
      I => data_in(6),
      O => data_in_IBUF(6)
    );
\data_in_IBUF[7]_inst\: unisim.vcomponents.IBUF
     port map (
      I => data_in(7),
      O => data_in_IBUF(7)
    );
\data_in_IBUF[8]_inst\: unisim.vcomponents.IBUF
     port map (
      I => data_in(8),
      O => data_in_IBUF(8)
    );
\data_in_IBUF[9]_inst\: unisim.vcomponents.IBUF
     port map (
      I => data_in(9),
      O => data_in_IBUF(9)
    );
\data_out_OBUF[0]_inst\: unisim.vcomponents.OBUF
     port map (
      I => data_out_OBUF(0),
      O => data_out(0)
    );
\data_out_OBUF[10]_inst\: unisim.vcomponents.OBUF
     port map (
      I => data_out_OBUF(10),
      O => data_out(10)
    );
\data_out_OBUF[11]_inst\: unisim.vcomponents.OBUF
     port map (
      I => data_out_OBUF(11),
      O => data_out(11)
    );
\data_out_OBUF[12]_inst\: unisim.vcomponents.OBUF
     port map (
      I => data_out_OBUF(12),
      O => data_out(12)
    );
\data_out_OBUF[13]_inst\: unisim.vcomponents.OBUF
     port map (
      I => data_out_OBUF(13),
      O => data_out(13)
    );
\data_out_OBUF[14]_inst\: unisim.vcomponents.OBUF
     port map (
      I => data_out_OBUF(14),
      O => data_out(14)
    );
\data_out_OBUF[15]_inst\: unisim.vcomponents.OBUF
     port map (
      I => data_out_OBUF(15),
      O => data_out(15)
    );
\data_out_OBUF[1]_inst\: unisim.vcomponents.OBUF
     port map (
      I => data_out_OBUF(1),
      O => data_out(1)
    );
\data_out_OBUF[2]_inst\: unisim.vcomponents.OBUF
     port map (
      I => data_out_OBUF(2),
      O => data_out(2)
    );
\data_out_OBUF[3]_inst\: unisim.vcomponents.OBUF
     port map (
      I => data_out_OBUF(3),
      O => data_out(3)
    );
\data_out_OBUF[4]_inst\: unisim.vcomponents.OBUF
     port map (
      I => data_out_OBUF(4),
      O => data_out(4)
    );
\data_out_OBUF[5]_inst\: unisim.vcomponents.OBUF
     port map (
      I => data_out_OBUF(5),
      O => data_out(5)
    );
\data_out_OBUF[6]_inst\: unisim.vcomponents.OBUF
     port map (
      I => data_out_OBUF(6),
      O => data_out(6)
    );
\data_out_OBUF[7]_inst\: unisim.vcomponents.OBUF
     port map (
      I => data_out_OBUF(7),
      O => data_out(7)
    );
\data_out_OBUF[8]_inst\: unisim.vcomponents.OBUF
     port map (
      I => data_out_OBUF(8),
      O => data_out(8)
    );
\data_out_OBUF[9]_inst\: unisim.vcomponents.OBUF
     port map (
      I => data_out_OBUF(9),
      O => data_out(9)
    );
\data_out_reg[0]\: unisim.vcomponents.FDCE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => write_select(4),
      CLR => i_controller_n_16,
      D => data_out_0(0),
      Q => data_out_OBUF(0)
    );
\data_out_reg[10]\: unisim.vcomponents.FDCE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => write_select(4),
      CLR => i_controller_n_16,
      D => data_out_0(10),
      Q => data_out_OBUF(10)
    );
\data_out_reg[11]\: unisim.vcomponents.FDCE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => write_select(4),
      CLR => i_controller_n_16,
      D => data_out_0(11),
      Q => data_out_OBUF(11)
    );
\data_out_reg[12]\: unisim.vcomponents.FDCE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => write_select(4),
      CLR => i_controller_n_16,
      D => data_out_0(12),
      Q => data_out_OBUF(12)
    );
\data_out_reg[13]\: unisim.vcomponents.FDCE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => write_select(4),
      CLR => i_controller_n_16,
      D => data_out_0(13),
      Q => data_out_OBUF(13)
    );
\data_out_reg[14]\: unisim.vcomponents.FDCE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => write_select(4),
      CLR => i_controller_n_16,
      D => data_out_0(14),
      Q => data_out_OBUF(14)
    );
\data_out_reg[15]\: unisim.vcomponents.FDCE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => write_select(4),
      CLR => i_controller_n_16,
      D => data_out_0(15),
      Q => data_out_OBUF(15)
    );
\data_out_reg[1]\: unisim.vcomponents.FDCE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => write_select(4),
      CLR => i_controller_n_16,
      D => data_out_0(1),
      Q => data_out_OBUF(1)
    );
\data_out_reg[2]\: unisim.vcomponents.FDCE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => write_select(4),
      CLR => i_controller_n_16,
      D => data_out_0(2),
      Q => data_out_OBUF(2)
    );
\data_out_reg[3]\: unisim.vcomponents.FDCE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => write_select(4),
      CLR => i_controller_n_16,
      D => data_out_0(3),
      Q => data_out_OBUF(3)
    );
\data_out_reg[4]\: unisim.vcomponents.FDCE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => write_select(4),
      CLR => i_controller_n_16,
      D => data_out_0(4),
      Q => data_out_OBUF(4)
    );
\data_out_reg[5]\: unisim.vcomponents.FDCE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => write_select(4),
      CLR => i_controller_n_16,
      D => data_out_0(5),
      Q => data_out_OBUF(5)
    );
\data_out_reg[6]\: unisim.vcomponents.FDCE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => write_select(4),
      CLR => i_controller_n_16,
      D => data_out_0(6),
      Q => data_out_OBUF(6)
    );
\data_out_reg[7]\: unisim.vcomponents.FDCE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => write_select(4),
      CLR => i_controller_n_16,
      D => data_out_0(7),
      Q => data_out_OBUF(7)
    );
\data_out_reg[8]\: unisim.vcomponents.FDCE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => write_select(4),
      CLR => i_controller_n_16,
      D => data_out_0(8),
      Q => data_out_OBUF(8)
    );
\data_out_reg[9]\: unisim.vcomponents.FDCE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => write_select(4),
      CLR => i_controller_n_16,
      D => data_out_0(9),
      Q => data_out_OBUF(9)
    );
i_ALU: entity work.ALU
     port map (
      CO(0) => input_equal,
      DI(3) => i_controller_n_42,
      DI(2) => i_controller_n_43,
      DI(1) => i_controller_n_44,
      DI(0) => i_controller_n_45,
      \FSM_sequential_state_reg[2]\(1) => i_controller_n_17,
      \FSM_sequential_state_reg[2]\(0) => i_controller_n_18,
      \FSM_sequential_state_reg[2]_0\(3) => i_controller_n_50,
      \FSM_sequential_state_reg[2]_0\(2) => i_controller_n_51,
      \FSM_sequential_state_reg[2]_0\(1) => i_controller_n_52,
      \FSM_sequential_state_reg[2]_0\(0) => i_controller_n_53,
      \FSM_sequential_state_reg[2]_1\(3) => i_controller_n_46,
      \FSM_sequential_state_reg[2]_1\(2) => i_controller_n_47,
      \FSM_sequential_state_reg[2]_1\(1) => i_controller_n_48,
      \FSM_sequential_state_reg[2]_1\(0) => i_controller_n_49,
      S(3) => i_controller_n_0,
      S(2) => i_controller_n_1,
      S(1) => i_controller_n_2,
      S(0) => i_controller_n_3,
      bus_a(14 downto 0) => bus_a(14 downto 0),
      data2(15 downto 0) => data2(15 downto 0),
      \data_out_reg[11]\(3) => i_controller_n_12,
      \data_out_reg[11]\(2) => i_controller_n_13,
      \data_out_reg[11]\(1) => i_controller_n_14,
      \data_out_reg[11]\(0) => i_controller_n_15,
      \data_out_reg[15]\(3) => i_controller_n_8,
      \data_out_reg[15]\(2) => i_controller_n_9,
      \data_out_reg[15]\(1) => i_controller_n_10,
      \data_out_reg[15]\(0) => i_controller_n_11,
      \data_out_reg[7]\(3) => i_controller_n_4,
      \data_out_reg[7]\(2) => i_controller_n_5,
      \data_out_reg[7]\(1) => i_controller_n_6,
      \data_out_reg[7]\(0) => i_controller_n_7,
      \input_equal0_carry__0_0\(3) => i_controller_n_19,
      \input_equal0_carry__0_0\(2) => i_controller_n_20,
      \input_equal0_carry__0_0\(1) => i_controller_n_21,
      \input_equal0_carry__0_0\(0) => i_controller_n_22,
      \input_greater0_carry__0_0\(3) => i_controller_n_38,
      \input_greater0_carry__0_0\(2) => i_controller_n_39,
      \input_greater0_carry__0_0\(1) => i_controller_n_40,
      \input_greater0_carry__0_0\(0) => i_controller_n_41,
      \reg0_reg[14]\(0) => input_greater
    );
i_controller: entity work.controller
     port map (
      CLK => clk_IBUF_BUFG,
      CO(0) => input_equal,
      D(15 downto 0) => data_out_0(15 downto 0),
      DI(3) => i_controller_n_42,
      DI(2) => i_controller_n_43,
      DI(1) => i_controller_n_44,
      DI(0) => i_controller_n_45,
      \FSM_sequential_state_reg[2]_0\(0) => input_greater,
      Q(15 downto 0) => reg1(15 downto 0),
      S(3) => i_controller_n_0,
      S(2) => i_controller_n_1,
      S(1) => i_controller_n_2,
      S(0) => i_controller_n_3,
      bus_a(14 downto 0) => bus_a(14 downto 0),
      data2(15 downto 0) => data2(15 downto 0),
      data_in_IBUF(15 downto 0) => data_in_IBUF(15 downto 0),
      \data_out_reg[15]\(15 downto 0) => reg0(15 downto 0),
      ready_in_OBUF => ready_in_OBUF,
      ready_out_IBUF => ready_out_IBUF,
      \reg0_reg[14]\(3) => i_controller_n_46,
      \reg0_reg[14]\(2) => i_controller_n_47,
      \reg0_reg[14]\(1) => i_controller_n_48,
      \reg0_reg[14]\(0) => i_controller_n_49,
      \reg0_reg[14]_0\(3) => i_controller_n_50,
      \reg0_reg[14]_0\(2) => i_controller_n_51,
      \reg0_reg[14]_0\(1) => i_controller_n_52,
      \reg0_reg[14]_0\(0) => i_controller_n_53,
      \reg0_reg[6]\(3) => i_controller_n_38,
      \reg0_reg[6]\(2) => i_controller_n_39,
      \reg0_reg[6]\(1) => i_controller_n_40,
      \reg0_reg[6]\(0) => i_controller_n_41,
      \reg1_reg[10]\(3) => i_controller_n_19,
      \reg1_reg[10]\(2) => i_controller_n_20,
      \reg1_reg[10]\(1) => i_controller_n_21,
      \reg1_reg[10]\(0) => i_controller_n_22,
      \reg1_reg[11]\(3) => i_controller_n_12,
      \reg1_reg[11]\(2) => i_controller_n_13,
      \reg1_reg[11]\(1) => i_controller_n_14,
      \reg1_reg[11]\(0) => i_controller_n_15,
      \reg1_reg[15]\(3) => i_controller_n_8,
      \reg1_reg[15]\(2) => i_controller_n_9,
      \reg1_reg[15]\(1) => i_controller_n_10,
      \reg1_reg[15]\(0) => i_controller_n_11,
      \reg1_reg[15]_0\(1) => i_controller_n_17,
      \reg1_reg[15]_0\(0) => i_controller_n_18,
      \reg1_reg[7]\(3) => i_controller_n_4,
      \reg1_reg[7]\(2) => i_controller_n_5,
      \reg1_reg[7]\(1) => i_controller_n_6,
      \reg1_reg[7]\(0) => i_controller_n_7,
      reset_n => i_controller_n_16,
      reset_n_IBUF => reset_n_IBUF,
      valid_in_IBUF => valid_in_IBUF,
      valid_out_OBUF => valid_out_OBUF,
      write_select(2) => write_select(4),
      write_select(1 downto 0) => write_select(1 downto 0)
    );
ready_in_OBUF_inst: unisim.vcomponents.OBUF
     port map (
      I => ready_in_OBUF,
      O => ready_in
    );
ready_out_IBUF_inst: unisim.vcomponents.IBUF
     port map (
      I => ready_out,
      O => ready_out_IBUF
    );
\reg0_reg[0]\: unisim.vcomponents.FDCE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => write_select(0),
      CLR => i_controller_n_16,
      D => data_out_0(0),
      Q => reg0(0)
    );
\reg0_reg[10]\: unisim.vcomponents.FDCE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => write_select(0),
      CLR => i_controller_n_16,
      D => data_out_0(10),
      Q => reg0(10)
    );
\reg0_reg[11]\: unisim.vcomponents.FDCE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => write_select(0),
      CLR => i_controller_n_16,
      D => data_out_0(11),
      Q => reg0(11)
    );
\reg0_reg[12]\: unisim.vcomponents.FDCE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => write_select(0),
      CLR => i_controller_n_16,
      D => data_out_0(12),
      Q => reg0(12)
    );
\reg0_reg[13]\: unisim.vcomponents.FDCE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => write_select(0),
      CLR => i_controller_n_16,
      D => data_out_0(13),
      Q => reg0(13)
    );
\reg0_reg[14]\: unisim.vcomponents.FDCE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => write_select(0),
      CLR => i_controller_n_16,
      D => data_out_0(14),
      Q => reg0(14)
    );
\reg0_reg[15]\: unisim.vcomponents.FDCE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => write_select(0),
      CLR => i_controller_n_16,
      D => data_out_0(15),
      Q => reg0(15)
    );
\reg0_reg[1]\: unisim.vcomponents.FDCE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => write_select(0),
      CLR => i_controller_n_16,
      D => data_out_0(1),
      Q => reg0(1)
    );
\reg0_reg[2]\: unisim.vcomponents.FDCE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => write_select(0),
      CLR => i_controller_n_16,
      D => data_out_0(2),
      Q => reg0(2)
    );
\reg0_reg[3]\: unisim.vcomponents.FDCE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => write_select(0),
      CLR => i_controller_n_16,
      D => data_out_0(3),
      Q => reg0(3)
    );
\reg0_reg[4]\: unisim.vcomponents.FDCE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => write_select(0),
      CLR => i_controller_n_16,
      D => data_out_0(4),
      Q => reg0(4)
    );
\reg0_reg[5]\: unisim.vcomponents.FDCE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => write_select(0),
      CLR => i_controller_n_16,
      D => data_out_0(5),
      Q => reg0(5)
    );
\reg0_reg[6]\: unisim.vcomponents.FDCE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => write_select(0),
      CLR => i_controller_n_16,
      D => data_out_0(6),
      Q => reg0(6)
    );
\reg0_reg[7]\: unisim.vcomponents.FDCE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => write_select(0),
      CLR => i_controller_n_16,
      D => data_out_0(7),
      Q => reg0(7)
    );
\reg0_reg[8]\: unisim.vcomponents.FDCE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => write_select(0),
      CLR => i_controller_n_16,
      D => data_out_0(8),
      Q => reg0(8)
    );
\reg0_reg[9]\: unisim.vcomponents.FDCE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => write_select(0),
      CLR => i_controller_n_16,
      D => data_out_0(9),
      Q => reg0(9)
    );
\reg1_reg[0]\: unisim.vcomponents.FDCE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => write_select(1),
      CLR => i_controller_n_16,
      D => data_out_0(0),
      Q => reg1(0)
    );
\reg1_reg[10]\: unisim.vcomponents.FDCE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => write_select(1),
      CLR => i_controller_n_16,
      D => data_out_0(10),
      Q => reg1(10)
    );
\reg1_reg[11]\: unisim.vcomponents.FDCE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => write_select(1),
      CLR => i_controller_n_16,
      D => data_out_0(11),
      Q => reg1(11)
    );
\reg1_reg[12]\: unisim.vcomponents.FDCE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => write_select(1),
      CLR => i_controller_n_16,
      D => data_out_0(12),
      Q => reg1(12)
    );
\reg1_reg[13]\: unisim.vcomponents.FDCE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => write_select(1),
      CLR => i_controller_n_16,
      D => data_out_0(13),
      Q => reg1(13)
    );
\reg1_reg[14]\: unisim.vcomponents.FDCE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => write_select(1),
      CLR => i_controller_n_16,
      D => data_out_0(14),
      Q => reg1(14)
    );
\reg1_reg[15]\: unisim.vcomponents.FDCE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => write_select(1),
      CLR => i_controller_n_16,
      D => data_out_0(15),
      Q => reg1(15)
    );
\reg1_reg[1]\: unisim.vcomponents.FDCE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => write_select(1),
      CLR => i_controller_n_16,
      D => data_out_0(1),
      Q => reg1(1)
    );
\reg1_reg[2]\: unisim.vcomponents.FDCE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => write_select(1),
      CLR => i_controller_n_16,
      D => data_out_0(2),
      Q => reg1(2)
    );
\reg1_reg[3]\: unisim.vcomponents.FDCE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => write_select(1),
      CLR => i_controller_n_16,
      D => data_out_0(3),
      Q => reg1(3)
    );
\reg1_reg[4]\: unisim.vcomponents.FDCE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => write_select(1),
      CLR => i_controller_n_16,
      D => data_out_0(4),
      Q => reg1(4)
    );
\reg1_reg[5]\: unisim.vcomponents.FDCE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => write_select(1),
      CLR => i_controller_n_16,
      D => data_out_0(5),
      Q => reg1(5)
    );
\reg1_reg[6]\: unisim.vcomponents.FDCE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => write_select(1),
      CLR => i_controller_n_16,
      D => data_out_0(6),
      Q => reg1(6)
    );
\reg1_reg[7]\: unisim.vcomponents.FDCE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => write_select(1),
      CLR => i_controller_n_16,
      D => data_out_0(7),
      Q => reg1(7)
    );
\reg1_reg[8]\: unisim.vcomponents.FDCE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => write_select(1),
      CLR => i_controller_n_16,
      D => data_out_0(8),
      Q => reg1(8)
    );
\reg1_reg[9]\: unisim.vcomponents.FDCE
    generic map(
      INIT => '0'
    )
        port map (
      C => clk_IBUF_BUFG,
      CE => write_select(1),
      CLR => i_controller_n_16,
      D => data_out_0(9),
      Q => reg1(9)
    );
reset_n_IBUF_inst: unisim.vcomponents.IBUF
     port map (
      I => reset_n,
      O => reset_n_IBUF
    );
valid_in_IBUF_inst: unisim.vcomponents.IBUF
     port map (
      I => valid_in,
      O => valid_in_IBUF
    );
valid_out_OBUF_inst: unisim.vcomponents.OBUF
     port map (
      I => valid_out_OBUF,
      O => valid_out
    );
end STRUCTURE;
