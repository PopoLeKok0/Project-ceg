LIBRARY ieee;
USE  ieee.std_logic_1164.all;

ENTITY BCDDecoder is
    PORT 
    (
        
        binaryIN    :   IN STD_LOGIC_VECTOR(3 downto 0);
        bcdOUT      :   OUT STD_LOGIC_VECTOR(4 downto 0)

    );
END BCDDecoder;

ARCHITECTURE rtl of BCDDecoder is

    SIGNAL BIN      :   STD_LOGIC_VECTOR(3 downto 0);

    BEGIN
    BIN <= binaryIN;
    bcdOUT(4) <= (BIN(3) and BIN(2)) or (BIN(3) and BIN(1));
    bcdOUT(3) <= ((BIN(3) and not BIN(2)) and not BIN(1));
    bcdOUT(2) <= (not BIN(3) and BIN(2)) or (BIN(2) and BIN(1));
    bcdOUT(1) <= (not BIN(3) and BIN(1)) or (BIN(3) and BIN(2) and not BIN(1));
    bcdOUT(0) <= BIN(0);

END ARCHITECTURE;
