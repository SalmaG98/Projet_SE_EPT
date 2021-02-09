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
    Port ( code : in string(4 downto 1);
           numero_tel : in string(8 downto 1);
           code_debloc : in string(4 downto 1);
           code_debloc_verif : buffer integer := 0;
           cur_state : out integer := 0; --state id raging from 0 to 13 included
           Ntries : out integer := 3;
           CLK : in STD_LOGIC := '0';
           enter : in STD_LOGIC := '0';
           OP : out STD_LOGIC := '0';
           VV : out STD_LOGIC := '0';
           VR : out STD_LOGIC := '0';
           AA : out STD_LOGIC := '0');
end SourceCode;

architecture Behavioral of SourceCode is

type type_etat is (E0, E1, E2, E3, E4, E5, E6, E7, E8, E9, E10, E11, E12, E13);
signal etat : type_etat := E0;
signal delay : integer := 0;
signal cnt : integer := 0;
signal limite_tentatives : integer := 3;
signal code_verification : integer := 9988;

begin
    process(etat,CLK) is
    
    
    variable code_correct : string(4 downto 1) := "AF10"; 
    variable numero_correct : string(8 downto 1) := "22222222";
    
    
    begin
    
        if(rising_edge(CLK)) then
            
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
                    --hold lock open for 5 clk periods
                    if (delay < 4) then
                    delay <= delay + 1;
                    else
                    delay <= 0;
                    etat <= E0;
                    end if;
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
                    etat <= E12;
                when E12 =>
                    if(enter = '1') then 
                    etat <= E13;
                    end if;
                when E13 =>
                    if(code_debloc = integer'image(code_debloc_verif)) then etat <= E0;
                    else etat <= E8;
                    end if;
                    
            end case;
        end if;
    end process;
    
    process(etat)
    begin
    
        cur_state <= type_etat'pos(etat);
        Ntries <= limite_tentatives - cnt;
        
        case etat is
        
            when E0 =>
                VV <= '0';
                VR <= '0';
                cnt <= 0;
                limite_tentatives <= 3;
                OP <= '0';
                AA <= '0';
                
            when E3 => 
                VV <= '1';
                VR <= '0';
                OP <= '1';
                
            when E5 =>
                VR <= '1';
                cnt <= cnt+1; 
                
            when E8 =>
                AA <= '1';
                
            when E11 =>
                code_debloc_verif <= code_verification;
                
            when others => null;
            
        end case;
    end process;

end Behavioral;
