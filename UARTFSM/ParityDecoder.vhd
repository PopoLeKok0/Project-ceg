LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY ParityGenerator IS
    PORT (
        i_data : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        o_parity : OUT STD_LOGIC
    );
END ENTITY ParityGenerator;

ARCHITECTURE rtl OF ParityGenerator IS
    SIGNAL sum : STD_LOGIC;

BEGIN
    PROCESS(i_data)
    BEGIN
        sum <= i_data(7) XOR i_data(6) XOR i_data(5) XOR i_data(4) XOR i_data(3) XOR i_data(2) XOR i_data(1) XOR i_data(0);
    END PROCESS;

    o_parity <= sum;

END ARCHITECTURE rtl;
