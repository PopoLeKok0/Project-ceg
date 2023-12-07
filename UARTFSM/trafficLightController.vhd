LIBRARY ieee;
USE  ieee.std_logic_1164.all;

ENTITY trafficLightController is
    PORT
    (
        MSC, SSC               : IN STD_LOGIC_VECTOR(3 downto 0);
        SSCS, GCLOCK, GReset   : IN STD_LOGIC;
        MSTL, SSTL            : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
        BCD1, BCD2             : OUT STD_LOGIC_VECTOR(3 downto 0);
        MSCL, SSCL             : OUT STD_LOGIC_VECTOR(7 downto 0)
    );
END trafficLightController;

ARCHITECTURE rtl of trafficLightController is

    SIGNAL TMROUT, TMRMUXOUT, SST, MST, SCOUT, COUNTMUXOUT   :   STD_LOGIC_VECTOR(3 downto 0);
    SIGNAL CLRTMR, CLRTMR_BAR, TMREXP, MSorSS, CLRC, CNTEXP, CLK, SSCS_CLEAN   :   STD_LOGIC;
    SIGNAL bcdOUT   :   STD_LOGIC_VECTOR(4 downto 0);

    COMPONENT FSMController is
        PORT
        (

            CNTEXP, TMREXP, SSCS, GReset, CLK    :   IN STD_LOGIC;
            CLRTMR, MSorSS, CLRC                 :   OUT STD_LOGIC;
            SST, MST                             :   OUT STD_LOGIC_VECTOR(3 downto 0);
            MSTL, SSTL                           :   OUT STD_LOGIC_VECTOR(2 downto 0);
            SSCL, MSCL                           :   OUT STD_LOGIC_VECTOR(7 downto 0)

        );
        END COMPONENT;

    COMPONENT FourBitIncrementer is
        PORT
        (
            i_resetBar, i_load, i_inc    : IN    STD_LOGIC;
            i_clock            : IN    STD_LOGIC;
            i_Value            : IN    STD_LOGIC_VECTOR(3 DOWNTO 0);
            o_Value            : OUT    STD_LOGIC_VECTOR(3 DOWNTO 0)
        );
        END COMPONENT;

    COMPONENT FourBitComparator IS
        PORT
        (
            i_Ai, i_Bi			: IN	STD_LOGIC_VECTOR(3 DOWNTO 0);
            o_GT, o_LT, o_EQ		: OUT	STD_LOGIC
        );
        END COMPONENT;

    COMPONENT Two_One_4BItMUX is
        PORT 
        ( 
            SEL : in  STD_LOGIC;
            A   : in  STD_LOGIC_VECTOR (3 downto 0);
            B   : in  STD_LOGIC_VECTOR (3 downto 0);
            X   : out STD_LOGIC_VECTOR (3 downto 0)
        );
        END COMPONENT;

    COMPONENT debouncer is
        PORT
        (
            i_raw			: IN	STD_LOGIC;
            i_clock			: IN	STD_LOGIC;
            o_clean			: OUT	STD_LOGIC
        );
        END COMPONENT;

    COMPONENT BCDDecoder is
        PORT
        (
            
            binaryIN    :   IN STD_LOGIC_VECTOR(3 downto 0);
            bcdOUT      :   OUT STD_LOGIC_VECTOR(4 downto 0)

        );
        END COMPONENT;
    
    COMPONENT clk_div IS
        PORT
        (
            clock_25Mhz				: IN	STD_LOGIC;
            clock_1MHz				: OUT	STD_LOGIC;
            clock_100KHz				: OUT	STD_LOGIC;
            clock_10KHz				: OUT	STD_LOGIC;
            clock_1KHz				: OUT	STD_LOGIC;
            clock_100Hz				: OUT	STD_LOGIC;
            clock_10Hz				: OUT	STD_LOGIC;
            clock_1Hz				: OUT	STD_LOGIC
            
        );
        END COMPONENT;

    BEGIN
    CLRTMR_BAR <= not CLRTMR; 

    controller : FSMController
        PORT MAP
        (

            CNTEXP => CNTEXP,
            TMREXP => TMREXP,
            SSCS => SSCS_CLEAN,
            GReset => GReset,
            CLK => CLK,
            CLRTMR => CLRTMR,
            MSorSS => MSorSS,
            CLRC => CLRC,
            SST => SST,
            MST => MST,
            MSTL => MSTL,
            SSTL => SSTL,
            SSCL => SSCL,
            MSCL => MSCL

        );


    timer : FourBitIncrementer
        PORT MAP
        (

            i_resetBar => GReset,
            i_load => CLRTMR,
            i_inc => CLRTMR_BAR,
            i_clock => CLK,
            i_Value => "0000",
            o_Value => TMROUT

        );

    timerComparator : FourBitComparator
        PORT MAP
        (

            i_Ai => TMRMUXOUT,
            i_Bi => TMROUT,
            o_GT => open,
            o_LT => TMREXP,
            o_EQ => open
            
        );
    
    timerMux : Two_One_4BItMUX
        PORT MAP
        ( 

            SEL => MSorSS,
            A => SST,
            B => MST,
            X => TMRMUXOUT
        
        );
    
    streetCounter : FourBitIncrementer
        PORT MAP
        (

            i_resetBar => GReset,
            i_load => CLRTMR_BAR,
            i_inc => CLRTMR,
            i_clock => CLK,
            i_Value => "0000",
            o_Value => SCOUT

        );
    
    counterComparator : FourBitComparator
        PORT MAP
        (

            i_Ai => COUNTMUXOUT,
            i_Bi => SCOUT,
            o_GT => open,
            o_LT => CNTEXP,
            o_EQ => open
            
        );

    counterMux : Two_One_4BItMUX
        PORT MAP
        ( 

            SEL => MSorSS,
            A => MSC,
            B => SSC,
            X => COUNTMUXOUT
        
        );
    
    debounce : debouncer
        PORT MAP
        (

            i_raw => SSCS,
            i_clock => CLK,
            o_clean => SSCS_CLEAN

        );
    
    decoder : BCDDecoder
    PORT MAP
        (
            binaryIN => TMROUT,
            bcdOUT => bcdOUT
        ); 
    
    -- divider : clk_div
    -- PORT MAP
    -- (

    --     clock_25Mhz => GCLOCK,
    --     clock_1MHz => open,
    --     clock_100KHz => open,
    --     clock_10KHz => open,
    --     clock_1KHz => open,
    --     clock_100Hz => open,
    --     clock_10Hz => open,
    --     clock_1Hz => CLK 
        
    -- );
    CLK <= GCLOCK;

    BCD1 <= (0 => bcdOUT(4), others => '0');
    BCD2 <= (3 => bcdOUT(3), 2 => bcdOUT(2), 1 => bcdOUT(1), 0 => bcdOUT(0));

END ARCHITECTURE;