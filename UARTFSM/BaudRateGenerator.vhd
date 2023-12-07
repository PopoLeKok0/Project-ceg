LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY BaudRateGenerator is 
    PORT 
    (
        i_CLK   :   IN STD_LOGIC;
        GRESET  :   IN STD_LOGIC;
        SEL     :   IN STD_LOGIC_VECTOR(2 downto 0);
        BCLKx8  :   OUT STD_LOGIC;
        BCLK    :   OUT STD_LOGIC
    );
END ENTITY BaudRateGenerator;

ARCHITECTURE rtl of BaudRateGenerator is

    SIGNAL cnt1_o, cnt2_o, cnt3_o, cnt4_o   :   STD_LOGIC_VECTOR(7 downto 0);
    SIGNAL comp1_o, comp2_o, comp3_o, BCLKx8_SIG, comp3GT   :   STD_LOGIC;

    COMPONENT EightBitIncrementer is
        PORT
        (
            i_resetBar, i_load, i_inc    : IN    STD_LOGIC;
            i_clock            : IN    STD_LOGIC;
            i_Value            : IN    STD_LOGIC_VECTOR(7 DOWNTO 0);
            o_Value            : OUT    STD_LOGIC_VECTOR(7 DOWNTO 0)
        );
        END COMPONENT;

    COMPONENT EightBitComparator is
        PORT
        (
            i_Ai, i_Bi			: IN	STD_LOGIC_VECTOR(7 DOWNTO 0);
            o_GT, o_LT, o_EQ		: OUT	STD_LOGIC
        );
        END COMPONENT;
    
    COMPONENT EightToOneMux IS
        PORT (
            i_mux: IN STD_LOGIC_VECTOR(7 DOWNTO 0);
            o_mux: OUT STD_LOGIC;
            sel0, sel1, sel2: IN STD_LOGIC
        );
    END COMPONENT;

    BEGIN

        BCLKx8 <= BCLKx8_SIG;
        BCLK <= cnt4_o(3);


        cnt1    :   EightBitIncrementer
        PORT MAP
        (
            i_resetBar => GRESET,
            i_load => '0',
            i_inc => '1',
            i_clock => i_CLK,
            i_Value => "00000000",
            o_Value => cnt1_o
        );
        
        comp1   :   EightBitComparator
        PORT MAP
        (
            i_Ai => cnt1_o,
            i_Bi => "00101000",
            o_GT => open,
            o_LT => open,
            o_EQ => comp1_o
        );
    
        cnt2    :   EightBitIncrementer
        PORT MAP
        (
            i_resetBar => GRESET,
            i_load => '0',
            i_inc => comp1_o,
            i_clock => i_CLK,
            i_Value => "00000000",
            o_Value => cnt2_o
        );

        comp2   :   EightBitComparator
        PORT MAP
        (
            i_Ai => cnt1_o,
            i_Bi => "11111111",
            o_GT => open,
            o_LT => open,
            o_EQ => comp2_o
        );

        cnt3    :   EightBitIncrementer
        PORT MAP
        (
            i_resetBar => GRESET,
            i_load => '0',
            i_inc => comp2_o,
            i_clock => i_CLK,
            i_Value => "00000000",
            o_Value => cnt3_o
        );

        mux     :   EightToOneMux
        PORT MAP
        (
            i_mux => cnt3_o,
            o_mux => BCLKx8_SIG,
            sel2 => SEL(2),
            sel1 => SEL(1),
            sel0 => SEL(0)
        );

        cnt4    :   EightBitIncrementer
        PORT MAP
        (
            i_resetBar => GRESET,
            i_load => '0',
            i_inc => '1',
            i_clock => BCLKx8_SIG,
            i_Value => "00000000",
            o_Value => cnt4_o
        );


END rtl;
