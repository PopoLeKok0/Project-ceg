LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY HalfAdder IS
    PORT
    (
        a, b : IN STD_LOGIC;
        s, c : OUT STD_LOGIC

    );
    END HalfAdder;

ARCHITECTURE rtl of HalfAdder IS
    BEGIN
        c <= a and b;
        s <= a xor b;
    end ARCHITECTURE;
     