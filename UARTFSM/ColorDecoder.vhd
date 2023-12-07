LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY ColorDecoder is
    PORT
    (
        TL      :   IN STD_LOGIC_VECTOR(2 downto 0);
        ASCII   :   OUT STD_LOGIC_VECTOR(7 downto 0)
    );
END ColorDecoder;

ARCHITECTURE rtl of ColorDecoder is
    BEGIN
        ASCII <= ('0', '1', '1', not TL(2), TL(1), TL(2), not TL(1), TL(1) or TL(2));
    END ARCHITECTURE;
