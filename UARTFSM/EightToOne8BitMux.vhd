LIBRARY ieee;
USE ieee.std_logic_1164.ALL;

ENTITY EightToOne8BitMux IS
    PORT (
        i_muxIn0, i_muxIn1, i_muxIn2, i_muxIn3, i_muxIn4, i_muxIn5, i_muxIn6, i_muxIn7: IN STD_LOGIC_VECTOR(7 DOWNTO 0);
        o_mux: OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
        sel0, sel1, sel2: IN STD_LOGIC
    );
END ENTITY EightToOne8BitMux;

ARCHITECTURE rtl OF EightToOne8BitMux IS
    SIGNAL out_mux : STD_LOGIC_VECTOR(7 DOWNTO 0);
BEGIN
    PROCESS(i_muxIn0, i_muxIn1, i_muxIn2, i_muxIn3, i_muxIn4, i_muxIn5, i_muxIn6, i_muxIn7, sel0, sel1, sel2)
    BEGIN
        out_mux(7) <= (NOT sel0 AND NOT sel1 AND NOT sel2 AND i_muxIn0(7)) OR
                      (sel0 AND NOT sel1 AND NOT sel2 AND i_muxIn1(7)) OR
                      (NOT sel0 AND sel1 AND NOT sel2 AND i_muxIn2(7)) OR
                      (sel0 AND sel1 AND NOT sel2 AND i_muxIn3(7)) OR
                      (NOT sel0 AND NOT sel1 AND sel2 AND i_muxIn4(7)) OR
                      (sel0 AND NOT sel1 AND sel2 AND i_muxIn5(7)) OR
                      (NOT sel0 AND sel1 AND sel2 AND i_muxIn6(7)) OR
                      (sel0 AND sel1 AND sel2 AND i_muxIn7(7));

        out_mux(6) <= (NOT sel0 AND NOT sel1 AND NOT sel2 AND i_muxIn0(6)) OR
                      (sel0 AND NOT sel1 AND NOT sel2 AND i_muxIn1(6)) OR
                      (NOT sel0 AND sel1 AND NOT sel2 AND i_muxIn2(6)) OR
                      (sel0 AND sel1 AND NOT sel2 AND i_muxIn3(6)) OR
                      (NOT sel0 AND NOT sel1 AND sel2 AND i_muxIn4(6)) OR
                      (sel0 AND NOT sel1 AND sel2 AND i_muxIn5(6)) OR
                      (NOT sel0 AND sel1 AND sel2 AND i_muxIn6(6)) OR
                      (sel0 AND sel1 AND sel2 AND i_muxIn7(6));

        out_mux(5) <= (NOT sel0 AND NOT sel1 AND NOT sel2 AND i_muxIn0(5)) OR
                      (sel0 AND NOT sel1 AND NOT sel2 AND i_muxIn1(5)) OR
                      (NOT sel0 AND sel1 AND NOT sel2 AND i_muxIn2(5)) OR
                      (sel0 AND sel1 AND NOT sel2 AND i_muxIn3(5)) OR
                      (NOT sel0 AND NOT sel1 AND sel2 AND i_muxIn4(5)) OR
                      (sel0 AND NOT sel1 AND sel2 AND i_muxIn5(5)) OR
                      (NOT sel0 AND sel1 AND sel2 AND i_muxIn6(5)) OR
                      (sel0 AND sel1 AND sel2 AND i_muxIn7(5));

        out_mux(4) <= (NOT sel0 AND NOT sel1 AND NOT sel2 AND i_muxIn0(4)) OR
                      (sel0 AND NOT sel1 AND NOT sel2 AND i_muxIn1(4)) OR
                      (NOT sel0 AND sel1 AND NOT sel2 AND i_muxIn2(4)) OR
                      (sel0 AND sel1 AND NOT sel2 AND i_muxIn3(4)) OR
                      (NOT sel0 AND NOT sel1 AND sel2 AND i_muxIn4(4)) OR
                      (sel0 AND NOT sel1 AND sel2 AND i_muxIn5(4)) OR
                      (NOT sel0 AND sel1 AND sel2 AND i_muxIn6(4)) OR
                      (sel0 AND sel1 AND sel2 AND i_muxIn7(4));

        out_mux(3) <= (NOT sel0 AND NOT sel1 AND NOT sel2 AND i_muxIn0(3)) OR
                      (sel0 AND NOT sel1 AND NOT sel2 AND i_muxIn1(3)) OR
                      (NOT sel0 AND sel1 AND NOT sel2 AND i_muxIn2(3)) OR
                      (sel0 AND sel1 AND NOT sel2 AND i_muxIn3(3)) OR
                      (NOT sel0 AND NOT sel1 AND sel2 AND i_muxIn4(3)) OR
                      (sel0 AND NOT sel1 AND sel2 AND i_muxIn5(3)) OR
                      (NOT sel0 AND sel1 AND sel2 AND i_muxIn6(3)) OR
                      (sel0 AND sel1 AND sel2 AND i_muxIn7(3));

        out_mux(2) <= (NOT sel0 AND NOT sel1 AND NOT sel2 AND i_muxIn0(2)) OR
                      (sel0 AND NOT sel1 AND NOT sel2 AND i_muxIn1(2)) OR
                      (NOT sel0 AND sel1 AND NOT sel2 AND i_muxIn2(2)) OR
                      (sel0 AND sel1 AND NOT sel2 AND i_muxIn3(2)) OR
                      (NOT sel0 AND NOT sel1 AND sel2 AND i_muxIn4(2)) OR
                      (sel0 AND NOT sel1 AND sel2 AND i_muxIn5(2)) OR
                      (NOT sel0 AND sel1 AND sel2 AND i_muxIn6(2)) OR
                      (sel0 AND sel1 AND sel2 AND i_muxIn7(2));

        out_mux(1) <= (NOT sel0 AND NOT sel1 AND NOT sel2 AND i_muxIn0(1)) OR
                      (sel0 AND NOT sel1 AND NOT sel2 AND i_muxIn1(1)) OR
                      (NOT sel0 AND sel1 AND NOT sel2 AND i_muxIn2(1)) OR
                      (sel0 AND sel1 AND NOT sel2 AND i_muxIn3(1)) OR
                      (NOT sel0 AND NOT sel1 AND sel2 AND i_muxIn4(1)) OR
                      (sel0 AND NOT sel1 AND sel2 AND i_muxIn5(1)) OR
                      (NOT sel0 AND sel1 AND sel2 AND i_muxIn6(1)) OR
                      (sel0 AND sel1 AND sel2 AND i_muxIn7(1));

        out_mux(0) <= (NOT sel0 AND NOT sel1 AND NOT sel2 AND i_muxIn0(0)) OR
                      (sel0 AND NOT sel1 AND NOT sel2 AND i_muxIn1(0)) OR
                      (NOT sel0 AND sel1 AND NOT sel2 AND i_muxIn2(0)) OR
                      (sel0 AND sel1 AND NOT sel2 AND i_muxIn3(0)) OR
                      (NOT sel0 AND NOT sel1 AND sel2 AND i_muxIn4(0)) OR
                      (sel0 AND NOT sel1 AND sel2 AND i_muxIn5(0)) OR
                      (NOT sel0 AND sel1 AND sel2 AND i_muxIn6(0)) OR
                      (sel0 AND sel1 AND sel2 AND i_muxIn7(0));
    END PROCESS;

    o_mux <= out_mux;

END rtl;
