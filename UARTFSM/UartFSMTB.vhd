LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY UartFSM_TB IS
END ENTITY UartFSM_TB;

ARCHITECTURE tb_arch OF UartFSM_TB IS
    SIGNAL MSC, SSC: STD_LOGIC_VECTOR(3 DOWNTO 0);
    SIGNAL SSCS, GRESET, ASK, CLK, TDX: STD_LOGIC;
    SIGNAL BaudSEL: STD_LOGIC_VECTOR(2 DOWNTO 0);

    COMPONENT UartFSM
        PORT
        (
            MSC         :   IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            SSC         :   IN STD_LOGIC_VECTOR(3 DOWNTO 0);
            SSCS        :   IN STD_LOGIC;
            GRESET      :   IN STD_LOGIC;
            ASK         :   IN STD_LOGIC;
            CLK         :   IN STD_LOGIC;
            TDX         :   OUT STD_LOGIC;
            MSTL, SSTL  :   OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
            BaudSEL     :   IN STD_LOGIC_VECTOR(2 DOWNTO 0)
        );
    END COMPONENT;

BEGIN
    UUT: UartFSM
    PORT MAP
    (
        MSC => MSC,
        SSC => SSC,
        SSCS => SSCS,
        GRESET => GRESET,
        ASK => ASK,
        CLK => CLK,
        TDX => TDX,
        MSTL => open,
        SSTL => open,
        BaudSEL => BaudSEL
    );

    PROCESS
    BEGIN
        CLK <= '0';
        WAIT FOR 5 ns;  -- Adjust this delay based on your design requirements
        CLK <= '1';
        WAIT FOR 5 ns;  -- Adjust this delay based on your design requirements
    END PROCESS;

    PROCESS
    BEGIN
        -- Initialize inputs
        GRESET <= '0';
        ASK <= '0';
        MSC <= "1111";
        SSC <= "1111";
        BaudSEL <= "000";
        WAIT FOR 10 ns;

        -- Release reset
        GRESET <= '1';

        -- Apply some stimulus (you can modify this as needed)
        ASK <= '1';

        WAIT FOR 5 ms;
        ASK <= '0';

        WAIT FOR 5 ms;
        assert false;   
        report "simulation finished successfully" severity FAILURE;
    END PROCESS;


END tb_arch;
