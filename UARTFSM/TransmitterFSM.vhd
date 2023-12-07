LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY TransmitterFSM is
    PORT
    (
        GRESET      :   IN STD_LOGIC;
        TDRE        :   IN STD_LOGIC;
        TSFBIT      :   IN STD_LOGIC;
        DATA        :   IN STD_LOGIC_VECTOR(7 downto 0);
        BCLK        :   IN STD_LOGIC;
        TDX         :   OUT STD_LOGIC;
        TDXSTART    :   OUT STD_LOGIC;
        TDXDONE     :   OUT STD_LOGIC
        
    );
END ENTITY;

ARCHITECTURE rtl of TransmitterFSM is

    SIGNAL TSR_i, CTR_o    :   STD_LOGIC_VECTOR(7 downto 0);
    SIGNAL parityBit, tsrOUT, LDTDR, LDTSR, SHFTTSR, DATAnotParity, SETTDX, CLRTDX, CLRCTR : STD_LOGIC;
    SIGNAL SA_IN, SA_OUT, SB_IN, SB_OUT, SC_IN, SC_OUT, SD_IN, SD_OUT, SE_IN, SE_OUT, SF_IN, SF_OUT : STD_LOGIC;
    SIGNAL EndDATA, muxOUT : STD_LOGIC;

    COMPONENT EightBitRegister IS
        PORT 
        (
            i_resetBar, i_load, i_clock : IN    STD_LOGIC;
            i_Value            : IN    STD_LOGIC_VECTOR(7 DOWNTO 0);
            o_Value            : OUT   STD_LOGIC_VECTOR(7 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT EightBitIncrementer IS
        PORT
        (
            i_resetBar, i_load, i_inc    : IN    STD_LOGIC;
            i_clock            : IN    STD_LOGIC;
            i_Value            : IN    STD_LOGIC_VECTOR(7 DOWNTO 0);
            o_Value            : OUT    STD_LOGIC_VECTOR(7 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT mux_2to1_top IS
        PORT 
        ( 
            SEL : in  STD_LOGIC;
            A   : in  STD_LOGIC;
            B   : in  STD_LOGIC;
            X   : out STD_LOGIC
        );
    END COMPONENT;

    COMPONENT EightBitComparator IS
        PORT
        (
            i_Ai, i_Bi			: IN	STD_LOGIC_VECTOR(7 DOWNTO 0);
            o_GT, o_LT, o_EQ		: OUT	STD_LOGIC
        );
    END COMPONENT;

    COMPONENT EightBitRightShiftRegister IS
        PORT (
            i_resetBar, i_load, i_shift : IN STD_LOGIC;
            i_clock : IN STD_LOGIC;
            i_shift_entry : IN STD_LOGIC;
            o_shift_out   : OUT STD_LOGIC;
            i_Value : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
            o_Value : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)
        );
    END COMPONENT;

    COMPONENT ParityGenerator IS
        PORT 
        (
            i_data : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
            o_parity : OUT STD_LOGIC
        );
    END COMPONENT;

    COMPONENT tdxFF IS
        PORT
        (
            i_resetBar	: IN	STD_LOGIC;
            i_d		: IN	STD_LOGIC;
            i_enable	: IN	STD_LOGIC;
            i_set_sync  : IN STD_LOGIC;
            i_reset_sync: IN STD_LOGIC;
            i_clock		: IN	STD_LOGIC;
            o_q, o_qBar	: OUT	STD_LOGIC
        );
    END COMPONENT;

    COMPONENT enARdFF_2 IS
        PORT
        (
            i_resetBar	: IN	STD_LOGIC;
            i_d		: IN	STD_LOGIC;
            i_enable	: IN	STD_LOGIC;
            i_clock		: IN	STD_LOGIC;
            o_q, o_qBar	: OUT	STD_LOGIC
        );
    END COMPONENT;

    COMPONENT enARdFF_2_resetON IS
        PORT(
            i_resetBar	: IN	STD_LOGIC;
            i_d		: IN	STD_LOGIC;
            i_enable	: IN	STD_LOGIC;
            i_clock		: IN	STD_LOGIC;
            o_q, o_qBar	: OUT	STD_LOGIC);
    END COMPONENT;

    BEGIN

    TDR : EightBitRegister
        PORT MAP
        (
            i_resetBar => GRESET, 
            i_load => LDTDR, 
            i_clock => BCLK,
            i_Value => DATA,
            o_Value => TSR_i
        );

    TSR : EightBitRightShiftRegister
        PORT MAP
        (

        i_resetBar => GRESET,
        i_load => LDTSR,
        i_shift => SHFTTSR,
        i_clock => BCLK,
        i_shift_entry => '1',
        o_shift_out => tsrOUT,
        i_Value => TSR_i,
        o_Value => open
       
        );


    counter : EightBitIncrementer
        PORT MAP
        (
            i_resetBar => GRESET, 
            i_load => CLRCTR, 
            i_inc => SHFTTSR,
            i_clock => BCLK,
            i_Value => "00000000",
            o_Value => CTR_o
        ); 
    
    PADec : ParityGenerator
        PORT MAP
        (
            i_data => TSR_i,
            o_parity => parityBit
        );

    comp : EightBitComparator
        PORT MAP
        (
            i_Ai => CTR_o,
            i_Bi => "00000110",
            o_GT => open,
            o_LT => open,
            o_EQ => EndDATA
        );

    tdxBIT : tdxFF
        PORT MAP
        (
            i_resetBar => GRESET,
            i_d => muxOUT,
            i_enable => '1',
            i_set_sync => SETTDX,
            i_reset_sync => CLRTDX,
            i_clock => BCLK,
            o_q => TDX, 
            o_qBar => open
        );
    
    mux : mux_2to1_top
    PORT MAP
        ( 
            SEL => DATAnotParity,
            A => tsrOUT,
            B => parityBit,
            X => muxOUT
        );

    SA : enARdFF_2_resetON
        PORT MAP
        (
            i_resetBar => GRESET,
            i_d => SA_IN,
            i_enable => '1',
            i_clock => BCLK,
            o_q => SA_OUT, 
            o_qBar => open
        );
    
    SB : enARdFF_2
        PORT MAP
        (
            i_resetBar => GRESET,
            i_d => SB_IN,
            i_enable => '1',
            i_clock => BCLK,
            o_q => SB_OUT, 
            o_qBar => open
        );

    SC : enARdFF_2
        PORT MAP
        (
            i_resetBar => GRESET,
            i_d => SC_IN,
            i_enable => '1',
            i_clock => BCLK,
            o_q => SC_OUT, 
            o_qBar => open
        );
    
    SD : enARdFF_2
        PORT MAP
        (
            i_resetBar => GRESET,
            i_d => SD_IN,
            i_enable => '1',
            i_clock => BCLK,
            o_q => SD_OUT, 
            o_qBar => open
        );

    SE : enARdFF_2
        PORT MAP
        (
            i_resetBar => GRESET,
            i_d => SE_IN,
            i_enable => '1',
            i_clock => BCLK,
            o_q => SE_OUT, 
            o_qBar => open
        );

    SF : enARdFF_2
        PORT MAP
        (
            i_resetBar => GRESET,
            i_d => SF_IN,
            i_enable => '1',
            i_clock => BCLK,
            o_q => SF_OUT, 
            o_qBar => open
        );

    SA_IN <= (SA_OUT and not (TDRE and TSFBIT)) or SF_OUT;
    SB_IN <= (SA_OUT and (TDRE and TSFBIT));
    SC_IN <= (SB_OUT);
    SD_IN <= (SC_OUT);
    SE_IN <= (SD_OUT) or (SE_OUT and (not EndDATA));
    SF_IN <= (SE_OUT and EndDATA);

    LDTDR <= SB_OUT;
    LDTSR <= SC_OUT;
    SHFTTSR <= SE_OUT;
    DATAnotParity <= (SA_OUT or SB_OUT or SC_OUT or SD_OUT or SE_OUT);
    SETTDX <= (SA_OUT or SB_OUT or SC_OUT);
    CLRTDX <= SD_OUT;
    CLRCTR <= SC_OUT;
    TDXDONE <= SF_OUT;
    TDXSTART <= SB_OUT;



END ARCHITECTURE;


    
