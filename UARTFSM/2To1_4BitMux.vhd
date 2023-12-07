library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Two_One_4BItMUX is
    Port ( SEL : in  STD_LOGIC;
           A   : in  STD_LOGIC_VECTOR (3 downto 0);
           B   : in  STD_LOGIC_VECTOR (3 downto 0);
           X   : out STD_LOGIC_VECTOR (3 downto 0));
end Two_One_4BItMUX;

architecture Behavioral of Two_One_4BItMUX is
begin
    X <= A when (SEL = '1') else B;
end Behavioral;