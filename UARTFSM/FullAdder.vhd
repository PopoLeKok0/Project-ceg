LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY FullAdder is
    PORT
    (
        a, b, cin   :   IN STD_LOGIC;
        cout, s     :   OUT STD_LOGIC
    );
    END FullAdder;

ARCHITECTURE rtl of FullAdder is
    COMPONENT HalfAdder is
        PORT
        (
            a, b : IN STD_LOGIC;
            s, c : OUT STD_LOGIC

        );
    END COMPONENT;
    SIGNAL sum_low, c_high, c_low  : STD_LOGIC;
    BEGIN
        HA_HIGH: HalfAdder 
                PORT MAP
                (
                    a => cin, b => sum_low, s => s, c => c_high
                );
        HA_LOW : HalfAdder
                PORT MAP
                (
                    a => a, b => b, s => sum_low, c => c_low
                );
        cout <= c_high or c_low;
    END rtl;