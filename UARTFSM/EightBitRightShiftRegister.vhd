LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY EightBitRightShiftRegister IS
    PORT (
        i_resetBar, i_load, i_shift : IN STD_LOGIC;
        i_clock : IN STD_LOGIC;
        i_shift_entry : IN STD_LOGIC;
        o_shift_out   : OUT STD_LOGIC;
        i_Value : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        o_Value : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
    );
END EightBitRightShiftRegister;

ARCHITECTURE rtl OF EightBitRightShiftRegister IS
    SIGNAL int_Value, int_ValueBAR, d_in : STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL d_en : STD_LOGIC;
    COMPONENT enARdFF_2
        PORT (
            i_resetBar : IN STD_LOGIC;
            i_d : IN STD_LOGIC;
            i_enable : IN STD_LOGIC;
            i_clock : IN STD_LOGIC;
            o_q, o_qBar : OUT STD_LOGIC
        );
    END COMPONENT;

BEGIN
    d_en <= i_load OR i_shift;
    d_in(7) <= (i_shift_entry AND i_shift AND (NOT i_load)) OR (i_Value(7) AND (NOT i_shift) AND i_load);
    d_in(6) <= (int_value(7) AND i_shift AND (NOT i_load)) OR (i_Value(6) AND (NOT i_shift) AND i_load);
    d_in(5) <= (int_value(6) AND i_shift AND (NOT i_load)) OR (i_Value(5) AND (NOT i_shift) AND i_load);
    d_in(4) <= (int_value(5) AND i_shift AND (NOT i_load)) OR (i_Value(4) AND (NOT i_shift) AND i_load);
    d_in(3) <= (int_value(4) AND i_shift AND (NOT i_load)) OR (i_Value(3) AND (NOT i_shift) AND i_load);
    d_in(2) <= (int_value(3) AND i_shift AND (NOT i_load)) OR (i_Value(2) AND (NOT i_shift) AND i_load);
    d_in(1) <= (int_value(2) AND i_shift AND (NOT i_load)) OR (i_Value(1) AND (NOT i_shift) AND i_load);
    d_in(0) <= (int_value(1) AND i_shift AND (NOT i_load)) OR (i_Value(0) AND (NOT i_shift) AND i_load);
    o_shift_out <= (int_value(0) AND i_shift AND (NOT i_load));

    b7: enARdFF_2
    PORT MAP (
        i_resetBar => i_resetBar,
        i_d => d_in(7),
        i_enable => d_en,
        i_clock => i_clock,
        o_q => int_Value(7),
        o_qBar => int_ValueBAR(7)
    );

    b6: enARdFF_2
    PORT MAP (
        i_resetBar => i_resetBar,
        i_d => d_in(6),
        i_enable => d_en,
        i_clock => i_clock,
        o_q => int_Value(6),
        o_qBar => int_ValueBAR(6)
    );

    b5: enARdFF_2
    PORT MAP (
        i_resetBar => i_resetBar,
        i_d => d_in(5),
        i_enable => d_en,
        i_clock => i_clock,
        o_q => int_Value(5),
        o_qBar => int_ValueBAR(5)
    );

    b4: enARdFF_2
    PORT MAP (
        i_resetBar => i_resetBar,
        i_d => d_in(4),
        i_enable => d_en,
        i_clock => i_clock,
        o_q => int_Value(4),
        o_qBar => int_ValueBAR(4)
    );

    b3: enARdFF_2
    PORT MAP (
        i_resetBar => i_resetBar,
        i_d => d_in(3),
        i_enable => d_en,
        i_clock => i_clock,
        o_q => int_Value(3),
        o_qBar => int_ValueBAR(3)
    );

    b2: enARdFF_2
    PORT MAP (
        i_resetBar => i_resetBar,
        i_d => d_in(2),
        i_enable => d_en,
        i_clock => i_clock,
        o_q => int_Value(2),
        o_qBar => int_ValueBAR(2)
    );

    b1: enARdFF_2
    PORT MAP (
        i_resetBar => i_resetBar,
        i_d => d_in(1),
        i_enable => d_en,
        i_clock => i_clock,
        o_q => int_Value(1),
        o_qBar => int_ValueBAR(1)
    );

    b0: enARdFF_2
    PORT MAP (
        i_resetBar => i_resetBar,
        i_d => d_in(0),
        i_enable => d_en,
        i_clock => i_clock,
        o_q => int_Value(0),
        o_qBar => int_ValueBAR(0)
    );

    -- Output Driver
    o_Value <= int_Value;

END rtl;
