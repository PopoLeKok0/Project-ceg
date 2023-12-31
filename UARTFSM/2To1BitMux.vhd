library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity mux_2to1_top is
    Port ( SEL : in  STD_LOGIC;
           A   : in  STD_LOGIC;
           B   : in  STD_LOGIC;
           X   : out STD_LOGIC);
end mux_2to1_top;

architecture Behavioral of mux_2to1_top is
begin
    X <= A when (SEL = '1') else B;
end Behavioral;