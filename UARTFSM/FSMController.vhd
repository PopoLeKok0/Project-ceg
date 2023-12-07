LIBRARY ieee;
USE  ieee.std_logic_1164.all;

ENTITY FSMController is
    PORT
    (

        CNTEXP, TMREXP, SSCS, GReset, CLK    :   IN STD_LOGIC;
        CLRTMR, MSorSS, CLRC                 :   OUT STD_LOGIC;
        SST, MST                             :   OUT STD_LOGIC_VECTOR(3 downto 0);
        MSTL, SSTL                           :   OUT STD_LOGIC_VECTOR(2 downto 0);
        SSCL, MSCL                           :   OUT STD_LOGIC_VECTOR(7 downto 0)

    );
    END FSMController;

ARCHITECTURE rtl of FSMController is

    SIGNAL SA, SB, SC, SD, DA, DB, DC, DD   :   STD_LOGIC;
    SIGNAL ssl, msl     :   STD_LOGIC_VECTOR(2 downto 0);

    COMPONENT enARdFF_2 is
        PORT
        (

            i_resetBar	: IN	STD_LOGIC;
            i_d		    : IN	STD_LOGIC;
            i_enable	: IN	STD_LOGIC;
            i_clock		: IN	STD_LOGIC;
            o_q, o_qBar	: OUT	STD_LOGIC

        );
        END COMPONENT;
    
    COMPONENT enARdFF_2_resetOn is
        PORT
        (

            i_resetBar	: IN	STD_LOGIC;
            i_d		    : IN	STD_LOGIC;
            i_enable	: IN	STD_LOGIC;
            i_clock		: IN	STD_LOGIC;
            o_q, o_qBar	: OUT	STD_LOGIC

        );
        END COMPONENT;

    COMPONENT ColorDecoder is
        PORT
        (
            TL      :   IN STD_LOGIC_VECTOR(2 downto 0);
            ASCII   :   OUT STD_LOGIC_VECTOR(7 downto 0)
        );
    END COMPONENT;
    
    BEGIN

        DA <= (TMREXP and SD) or ((CNTEXP nand SSCS) and SA);
        DB <= (CNTEXP and SSCS and SA) or (not TMREXP and SB);
        DC <= (TMREXP and SB) or (not CNTEXP and SC);
        DD <= (CNTEXP and SC) or (not TMREXP and SD);

        stateA :    enARdFF_2_resetOn
            PORT MAP
            (
                i_resetBar => GReset,
                i_d => DA,
                i_enable => '1',
                i_clock => CLK,
                o_q => SA,
                o_qBar => open
            );

        stateB :    enARdFF_2
            PORT MAP
            (

                i_resetBar => GReset,
                i_d => DB,
                i_enable => '1',
                i_clock => CLK,
                o_q => SB,
                o_qBar => open

            );

        stateC :    enARdFF_2
            PORT MAP
            (

                i_resetBar => GReset,
                i_d => DC,
                i_enable => '1',
                i_clock => CLK,
                o_q => SC,
                o_qBar => open

            );

        stateD :    enARdFF_2
            PORT MAP
            (

                i_resetBar => GReset,
                i_d => DD,
                i_enable => '1',
                i_clock => CLK,
                o_q => SD,
                o_qBar => open

            );

        MSColorDecoder  :   ColorDecoder
            PORT MAP
            (
                TL => msl,
                ASCII => MSCL
            );
        
        SSColorDecoder  :   ColorDecoder
            PORT MAP
            (
                TL => ssl,
                ASCII => SSCL
            );
    
    CLRTMR <= SA or SC;
    MSorSS <= SC or SD;
    CLRC <= SB or SD;

    SST <= "1010"; --Constant for the Side Street Timer, used to control the delay for the circuit
    MST <= "1101"; -- Constant for the other delay

    

    msl(2) <= SA;
    msl(1) <= SB;
    msl(0) <= SC or SD;
    ssl(2) <= SC;
    ssl(1) <= SD;
    ssl(0) <= SA or SB; 

    MSTL <= msl;
    SSTL <= ssl;

    END ARCHITECTURE;
