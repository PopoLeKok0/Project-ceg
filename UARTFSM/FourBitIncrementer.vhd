LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY FourBitIncrementer IS
    PORT(
        i_resetBar, i_load, i_inc    : IN    STD_LOGIC;
        i_clock            : IN    STD_LOGIC;
        i_Value            : IN    STD_LOGIC_VECTOR(3 DOWNTO 0);
        o_Value            : OUT    STD_LOGIC_VECTOR(3 DOWNTO 0)
    );
END FourBitIncrementer;

ARCHITECTURE rtl OF FourBitIncrementer IS
    SIGNAL int_Value, int_notValue, o_driver, d_in, Adder_OUT :  STD_LOGIC_VECTOR(3 DOWNTO 0);
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
    COMPONENT FourBitAdderSubtractor
        PORT
        (
            InputA, InputB  : IN STD_LOGIC_VECTOR(3 downto 0);
            Operation   :   IN STD_LOGIC;
            Result    :   OUT STD_LOGIC_VECTOR(3 downto 0);
            CarryOUT    :   OUT STD_LOGIC
        );
    END COMPONENT;

BEGIN

    adder: FourBitAdderSubtractor
    PORT MAP (

        InputA =>  int_Value,
        InputB => "0001",
        Operation => '0',
        Result => Adder_OUT       
        );

    d_in(3) <= (Adder_OUT(3) and (not i_load) and i_inc) or (i_Value(3) and i_load and (not i_inc));
    d_in(2) <= (Adder_OUT(2) and (not i_load) and i_inc) or (i_Value(2) and i_load and (not i_inc));
    d_in(1) <= (Adder_OUT(1) and (not i_load) and i_inc) or (i_Value(1) and i_load and (not i_inc));
    d_in(0) <= (Adder_OUT(0) and (not i_load) and i_inc) or (i_Value(0) and i_load and (not i_inc));
    d_en <= i_load or i_inc;

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
    o_Value    <= int_Value(3 downto 0);

END rtl;
