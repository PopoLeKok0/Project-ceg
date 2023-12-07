LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY FourBitRippleAdder IS
    PORT (
        InputA, InputB : IN STD_LOGIC_VECTOR(3 DOWNTO 0);
        CarryIN : IN STD_LOGIC;
        Sum : OUT STD_LOGIC_VECTOR(3 DOWNTO 0);
        CarryOUT : OUT STD_LOGIC
    );
END ENTITY FourBitRippleAdder;

ARCHITECTURE rtl OF FourBitRippleAdder IS
    SIGNAL C : STD_LOGIC_VECTOR(3 DOWNTO 0);

    COMPONENT FullAdder IS
        PORT (
            A, B, Cin : IN STD_LOGIC;
            s, Cout : OUT STD_LOGIC
        );
    END COMPONENT;

BEGIN
    FA0: FullAdder 
    PORT MAP (
        A => InputA(0), B => InputB(0), Cin => CarryIN,
        s => Sum(0), Cout => C(0)
    );

    FA1: FullAdder 
    PORT MAP (
        A => InputA(1), B => InputB(1), Cin => C(0),
        s => Sum(1), Cout => C(1)
    );

    FA2: FullAdder 
    PORT MAP (
        A => InputA(2), B => InputB(2), Cin => C(1),
        s => Sum(2), Cout => C(2)
    );

    FA3: FullAdder 
    PORT MAP (
        A => InputA(3), B => InputB(3), Cin => C(2),
        s => Sum(3), Cout => CarryOUT
    );

END rtl;
