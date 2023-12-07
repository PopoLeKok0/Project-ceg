LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY UartFSM IS
        PORT
        (
            MSC         :   IN STD_LOGIC_VECTOR(3 downto 0);
            SSC         :   IN STD_LOGIC_VECTOR(3 downto 0);
            SSCS        :   IN STD_LOGIC;
            GRESET      :   IN STD_LOGIC;
            ASK         :   IN STD_LOGIC;
            CLK         :   IN STD_LOGIC;
            TDX         :   OUT STD_LOGIC;
            MSTL, SSTL  :   OUT STD_LOGIC_VECTOR(2 downto 0);
            BaudSEL     :   IN STD_LOGIC_VECTOR(2 downto 0)
        );
    END UartFSM;

ARCHITECTURE rtl of UartFSM IS

    SIGNAL MSCL, SSCL, TX_IN   :   STD_LOGIC_VECTOR(7 downto 0);
    SIGNAL CounterOUT          :   STD_LOGIC_VECTOR(7 downto 0);
    SIGNAL BCLK, TDXDONE       :   STD_LOGIC;
    SIGNAL SA_IN, SA_OUT, SB_IN, SB_OUT, SC_IN, SC_OUT, SD_IN, SD_OUT  :   STD_LOGIC; 
    SIGNAL CLRCTR, INCCTR, TSFBIT, LT6, TDXSTART:  STD_LOGIC;

    COMPONENT trafficLightController is
        PORT
        (
            MSC, SSC               : IN STD_LOGIC_VECTOR(3 downto 0);
            SSCS, GCLOCK, GReset   : IN STD_LOGIC;
            MSTL, SSTL             : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
            BCD1, BCD2             : OUT STD_LOGIC_VECTOR(3 downto 0);
            MSCL, SSCL             : OUT STD_LOGIC_VECTOR(7 downto 0)
        );
    END COMPONENT;

    COMPONENT EightToOne8BitMux IS
        PORT (
            i_muxIn0, i_muxIn1, i_muxIn2, i_muxIn3, i_muxIn4, i_muxIn5, i_muxIn6, i_muxIn7: IN STD_LOGIC_VECTOR(7 DOWNTO 0);
            o_mux: OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
            sel0, sel1, sel2: IN STD_LOGIC
        );
    END COMPONENT;

    COMPONENT EightBitComparator IS
        PORT
        (
            i_Ai, i_Bi			: IN	STD_LOGIC_VECTOR(7 DOWNTO 0);
            o_GT, o_LT, o_EQ		: OUT	STD_LOGIC
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

    COMPONENT TransmitterFSM is
        PORT
        (
            GRESET      :   IN STD_LOGIC;
            TDRE        :   IN STD_LOGIC;
            TSFBIT      :   IN STD_LOGIC;
            DATA        :   IN STD_LOGIC_VECTOR(7 downto 0);
            BCLK        :   IN STD_LOGIC;
            TDX         :   OUT STD_LOGIC;
            TDXDONE     :   OUT STD_LOGIC;
            TDXSTART    :   OUT STD_LOGIC
        );
    END COMPONENT;

    COMPONENT BaudRateGenerator is 
        PORT 
        (
            i_CLK   :   IN STD_LOGIC;
            GRESET  :   IN STD_LOGIC;
            SEL     :   IN STD_LOGIC_VECTOR(2 downto 0);
            BCLKx8  :   OUT STD_LOGIC;
            BCLK    :   OUT STD_LOGIC
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
        PORT
        (
            i_resetBar	: IN	STD_LOGIC;
            i_d		: IN	STD_LOGIC;
            i_enable	: IN	STD_LOGIC;
            i_clock		: IN	STD_LOGIC;
            o_q, o_qBar	: OUT	STD_LOGIC
        );
    END COMPONENT;

    BEGIN

    lab3    :   trafficLightController
        PORT MAP
        (

            MSC => MSC,
            SSC => SSC,
            SSCS => SSCS,
            GCLOCK => CLK,
            GReset => GRESET,
            MSTL => MSTL,
            SSTL => SSTL,
            BCD1 => open,
            BCD2 => open,
            MSCL => MSCL,
            SSCL => SSCL

        );

    mux     :   EightToOne8BitMux
        PORT MAP
        (
            i_muxIn1 => "01001101", --ASCII for M
            i_muxIn2 => MSCL,
            i_muxIn3 => "01011111", --ASCII for _
            i_muxIn4 => "01010011", --ASCII for S
            i_muxIn5 => SSCL,
            i_muxIn6 => "00001101",
            i_muxIn7 => "00000000",
            i_muxIn0 => "00000000",
            o_mux => TX_IN,
            sel0 => CounterOUT(0),
            sel1 => CounterOUT(1),
            sel2 => CounterOUT(2)
        );

    counter :   EightBitIncrementer
        PORT MAP
        (
            i_resetBar => GRESET,
            i_load => CLRCTR, 
            i_inc => INCCTR,
            i_clock => CLK,
            i_Value => "00000000",
            o_Value => CounterOUT
        );
    
    baudGenerator :     BaudRateGenerator
        PORT MAP
        (
            i_CLK => CLK,
            GRESET => GRESET,
            SEL => BaudSEL,
            BCLKx8 => open,
            BCLK => BCLK
        );
    
    txFSM:     TransmitterFSM
        PORT MAP
        (
            GRESET => GRESET,
            TDRE => '1',
            TSFBIT => TSFBIT,
            DATA => TX_IN,
            BCLK => BCLK,
            TDX => TDX,
            TDXDONE => TDXDONE,
            TDXSTART => TDXSTART
        );
    
    comp    :   EightBitComparator
        PORT MAP
        (
            i_Ai => CounterOUT,
            i_Bi => "00000110",
            o_GT => open, 
            o_LT => LT6, 
            o_EQ => open
        ); 
    
    SA      :   enARdFF_2_resetON
        PORT MAP
        (
            i_resetBar => GRESET,
            i_d => SA_IN,
            i_enable => '1',
            i_clock => CLK,
            o_q => SA_OUT, 
            o_qBar => open 
        );

    SB       :   enARdFF_2
        PORT MAP
        (
            i_resetBar => GRESET,
            i_d => SB_IN,
            i_enable => '1',
            i_clock => CLK,
            o_q => SB_OUT, 
            o_qBar => open 
        );

    SC      :   enARdFF_2
        PORT MAP
        (
            i_resetBar => GRESET,
            i_d => SC_IN,
            i_enable => '1',
            i_clock => CLK,
            o_q => SC_OUT, 
            o_qBar => open 
        );
            
    SD      :   enARdFF_2
        PORT MAP
        (
            i_resetBar => GRESET,
            i_d => SD_IN,
            i_enable => '1',
            i_clock => CLK,
            o_q => SD_OUT, 
            o_qBar => open 
        );

    SA_IN <= (not LT6 and SB_OUT) or (SA_OUT and not ASK);
    SB_IN <= (SA_OUT and ASK) or (SD_OUT and TDXDONE) or ((not LT6 or not TDXSTART) and SB_OUT );
    SC_IN <= (LT6 and TDXSTART and SB_OUT);
    SD_IN <= (SC_OUT) or (SD_OUT and not TDXDONE);

    CLRCTR <= SA_OUT;
    INCCTR <= SC_OUT;
    TSFBIT <= SB_OUT;

END ARCHITECTURE;
    
