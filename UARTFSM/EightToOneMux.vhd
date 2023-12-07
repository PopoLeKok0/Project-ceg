-- Importing necessary VHDL libraries
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

-- Entity Declaration: Defines the inputs and outputs of the multiplexer
ENTITY EightToOneMux IS
    PORT (
        i_mux: IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        o_mux: OUT STD_LOGIC;
        sel0, sel1, sel2: IN STD_LOGIC
    );
END ENTITY EightToOneMux;

-- Architecture Definition for the multiplexer
ARCHITECTURE rtl OF EightToOneMux IS
    -- Signal declaration for the internal multiplexer output
    SIGNAL out_mux : STD_LOGIC;

BEGIN
    -- Multiplexer logic for the output

    out_mux <= ((not sel0) and (not sel1) and (not sel2) and i_mux(0)) or 
                ((sel0) and (not sel1) and (not sel2) and i_mux(1)) or 
                ((not sel0) and (sel1) and (not sel2) and i_mux(2)) or 
                ((sel0) and (sel1) and (not sel2) and i_mux(3)) or 
                ((not sel0) and (not sel1) and (sel2) and i_mux(4)) or 
                ((sel0) and (not sel1) and (sel2) and i_mux(5)) or 
                ((not sel0) and (sel1) and (sel2) and i_mux(6)) or 
                ((sel0) and (sel1) and (sel2) and i_mux(7));

    -- Assign the internal multiplexer output to the external output
    o_mux <= out_mux;	

END rtl;
