----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/23/2020 09:53:19 PM
-- Design Name: 
-- Module Name: SourceCode - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use std.textio.all;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity SourceCode is
    Port ( code : in string;
           CLK : in STD_LOGIC;
           enter : in STD_LOGIC;
           OP : out STD_LOGIC;
           VV : out STD_LOGIC;
           VR : out STD_LOGIC;
           AA : out STD_LOGIC);
end SourceCode;

architecture Behavioral of SourceCode is

--constant clock_period : time := 1000 ns; 
--WARNING : Synplicity has a bug : by default it rounds to nanoseconds!
--constant longest_delay : time := 1 ms;
--subtype delay_type is natural range 0 to longest_delay / clock_period;

--constant reset_delay : delay_type := 100 ms / clock_period - 1;

type type_etat is (E0, E1, E2, E3, E4, E5, E6, E7);
--, E3, E4, E5, E6, E7, E8, E9, E10, E11, E12, E13
signal etat : type_etat := E0;
signal delay : integer := 3;
signal delay_prec : integer := 0;
signal cnt : integer := 0;

begin
    process(CLK) is
    
    
    --variable count : integer := 4;
    variable limite_tentatives : integer := 3;
    variable code_correct : string(4 downto 1) := "AF10"; 
    
    begin
    
--    file_open(buff_in,"STD_INPUT", read_mode);
--    file_open(buff_out,"STD_OUTPUT", write_mode);
    
        if(rising_edge(CLK)) then
            --delay <= delay + 1;
            
            case etat is
                when E0 =>
                    etat <= E1;
                when E1 =>
                    etat <= E2;
                when E2 =>
                    if(code = code_correct) then etat <= E3;
                    else etat <= E5;
                    end if;
                when E3 =>
                    etat <= E4;
                when E4 =>
                    --delay_prec <= delay;
                    --if (delay - delay_prec = 5) then
                    --delay <= 0;
                    etat <= E0;
                    --end if;
                when E5 =>
                    if(cnt < limite_tentatives) then etat <= E6;
                    else etat <= E0;
                    end if;
                when E6 =>
                    if(cnt = limite_tentatives-1) then etat <= E7;
                    else etat <= E1;
                    end if;
                when E7 =>
                    etat <= E1;         
            end case;
        end if;
    end process;
    
    process(etat)
    begin
        case etat is
        
        when E0 =>
            VV <= '0';
            VR <= '0';
            cnt <= 0;
            OP <= '0';
        when E3 => 
            VV <= '1';
            VR <= '0';
            OP <= '1';
        when E5 =>
            VR <= '1';
            cnt <= cnt+1;    
        when others =>
        end case;
    end process;

end Behavioral;
