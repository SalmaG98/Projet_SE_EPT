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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity SourceCode is
    Port ( code : in string;
           numero_tel : in string;
           code_debloc : in string;
           code_debloc_verif : inout integer;
           e1e : out STD_LOGIC := '0';
           e3e : out STD_LOGIC := '0';
           e5e : out STD_LOGIC := '0';
           e7e : out STD_LOGIC := '0';
           e9e : out STD_LOGIC := '0';
           e10e : out STD_LOGIC := '0';
           e11e : out STD_LOGIC := '0';
           e12e : out STD_LOGIC := '0';
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

type type_etat is (E0, E1, E2, E3, E4, E5, E6, E7, E8, E9, E10, E11, E12, E13);
--, E3, E4, E5, E6, E7, E8, E9, E10, E11, E12, E13
signal etat : type_etat := E0;
signal delay : integer := 3;
signal delay_prec : integer := 0;
signal cnt : integer := 0;
signal code_verification : integer := 9988;

begin
    process(CLK) is
    
    
    --variable count : integer := 4;
    variable limite_tentatives : integer := 5;
    variable code_correct : string(4 downto 1) := "AF10"; 
    variable numero_correct : string(8 downto 1) := "22222222";
    
    
    begin
    
--    file_open(buff_in,"STD_INPUT", read_mode);
--    file_open(buff_out,"STD_OUTPUT", write_mode);
    
        if(rising_edge(CLK)) then
            --delay <= delay + 1;
            
            case etat is
                when E0 =>
                    etat <= E1;
                when E1 =>
                    if(enter = '1') then
                    etat <= E2;
                    end if;
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
                    else etat <= E8;
                    end if;
                when E6 =>
                    if(cnt = limite_tentatives-1) then etat <= E7;
                    else etat <= E1;
                    end if;
                when E7 =>
                    etat <= E1;
                when E8 => 
                    etat <= E9;
                when E9 =>
                    if(numero_tel = numero_correct) then etat <= E11;
                    else etat <= E10;
                    end if;
                when E10 =>
                    etat <= E11;
                when E11 =>
                    if(enter = '1') then etat <= E12;
                    end if;
                when E12 =>
                    if(code_debloc = integer'image(code_debloc_verif)) then etat <= E13;
                    else etat <= E12;
                    end if;
                when E13 =>
                    etat <= E0;
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
        when E1 =>
            e7e <= '0';
            e1e <= '1';
        when E2 =>
            e1e <= '0';
        when E3 => 
            e3e <= '1';
            VV <= '1';
            VR <= '0';
            OP <= '1';
        when E4 =>
            e3e <= '0';
        when E5 =>
            e5e <= '1';
            VR <= '1';
            cnt <= cnt+1; 
        when E6 =>
            e5e <= '0';
        when E7 =>
            e7e <= '1';
        when E8 =>
            e5e <= '0';
            AA <= '1';
        when E9 =>
            e9e <= '1';
        when E10 =>
            e10e <= '1';
            e9e <= '0';
        when E11 =>
            code_debloc_verif <= code_verification;
            e9e <= '0';
            e10e <= '0';
            e11e <= '1';
        when E12 =>
            e11e <= '0';
            e12e <= '1';
        when E13 =>
            e12e <= '0';
            AA <= '0';
        when others =>
        end case;
    end process;

end Behavioral;
