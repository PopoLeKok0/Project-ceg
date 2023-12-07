LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY EightBitIncrementer IS
    PORT(
        i_resetBar, i_load, i_inc    : IN    STD_LOGIC;
        i_clock            : IN    STD_LOGIC;
        i_Value            : IN    STD_LOGIC_VECTOR(7 DOWNTO 0);
        o_Value            : OUT    STD_LOGIC_VECTOR(7 DOWNTO 0)
    );
END EightBitIncrementer;

ARCHITECTURE rtl OF EightBitIncrementer IS
    SIGNAL int_Value, int_notValue, o_driver, d_in, Adder_OUT :  STD_LOGIC_VECTOR(7 DOWNTO 0);
    SIGNAL d_en : STD_LOGIC;

    COMPONENT enARdFF_2
        PORT(
            i_resetBar    : IN    STD_LOGIC;
            i_d        : IN    STD_LOGIC;
            i_enable    : IN    STD_LOGIC;
            i_clock        : IN    STD_LOGIC;
            o_q, o_qBar    : OUT    STD_LOGIC
        );
    END COMPONENT;
    
    COMPONENT EightBitRippleAdder IS
        PORT (
            InputA, InputB : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
            CarryIN : IN STD_LOGIC;
            Sum : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
            CarryOUT : OUT STD_LOGIC
        );
    END COMPONENT;

BEGIN
    -- 8-bit Adder
    adder: EightBitRippleAdder
    PORT MAP (
        InputA =>  int_Value,
        InputB => "00000000",
        CarryIN => '1',
        Sum => Adder_OUT,
        CarryOUT => open
    );

    -- Data input selection and enable logic
    d_in(7) <= (Adder_OUT(7) and (not i_load) and i_inc) or (i_Value(7) and (not i_load) and i_inc);
    d_in(6) <= (Adder_OUT(6) and (not i_load) and i_inc) or (i_Value(6) and (not i_load) and i_inc);
    d_in(5) <= (Adder_OUT(5) and (not i_load) and i_inc) or (i_Value(5) and (not i_load) and i_inc);
    d_in(4) <= (Adder_OUT(4) and (not i_load) and i_inc) or (i_Value(4) and (not i_load) and i_inc);
    d_in(3) <= (Adder_OUT(3) and (not i_load) and i_inc) or (i_Value(3) and (not i_load) and i_inc);
    d_in(2) <= (Adder_OUT(2) and (not i_load) and i_inc) or (i_Value(2) and (not i_load) and i_inc);
    d_in(1) <= (Adder_OUT(1) and (not i_load) and i_inc) or (i_Value(1) and (not i_load) and i_inc);
    d_in(0) <= (Adder_OUT(0) and (not i_load) and i_inc) or (i_Value(0) and (not i_load) and i_inc);

    d_en <= i_load or i_inc;

    -- Flip-Flops
    b7: enARdFF_2
    PORT MAP (
        i_resetBar => i_resetBar,
        i_d => d_in(7),
        i_enable => d_en,
        i_clock => i_clock,
        o_q => int_Value(7),
        o_qBar => int_notValue(7)
    );
    
    b6: enARdFF_2
    PORT MAP (
        i_resetBar => i_resetBar,
        i_d => d_in(6),
        i_enable => d_en,
        i_clock => i_clock,
        o_q => int_Value(6),
        o_qBar => int_notValue(6)
    );
    
    b5: enARdFF_2
    PORT MAP (
        i_resetBar => i_resetBar,
        i_d => d_in(5),
        i_enable => d_en,
        i_clock => i_clock,
        o_q => int_Value(5),
        o_qBar => int_notValue(5)
    );
    
    b4: enARdFF_2
    PORT MAP (
        i_resetBar => i_resetBar,
        i_d => d_in(4),
        i_enable => d_en,
        i_clock => i_clock,
        o_q => int_Value(4),
        o_qBar => int_notValue(4)
    );

    b3: enARdFF_2
    PORT MAP (
        i_resetBar => i_resetBar,
        i_d => d_in(3),
        i_enable => d_en,
        i_clock => i_clock,
        o_q => int_Value(3),
        o_qBar => int_notValue(3)
    );
    
    b2: enARdFF_2
    PORT MAP (
        i_resetBar => i_resetBar,
        i_d => d_in(2),
        i_enable => d_en,
        i_clock => i_clock,
        o_q => int_Value(2),
        o_qBar => int_notValue(2)
    );
    
    b1: enARdFF_2
    PORT MAP (
        i_resetBar => i_resetBar,
        i_d => d_in(1),
        i_enable => d_en,
        i_clock => i_clock,
        o_q => int_Value(1),
        o_qBar => int_notValue(1)
    );

    b0: enARdFF_2
    PORT MAP (
        i_resetBar => i_resetBar,
        i_d => d_in(0),
        i_enable => d_en,
        i_clock => i_clock,
        o_q => int_Value(0),
        o_qBar => int_notValue(0)
    );

    -- Output Driver
    o_Value    <= int_Value;

END rtl;
