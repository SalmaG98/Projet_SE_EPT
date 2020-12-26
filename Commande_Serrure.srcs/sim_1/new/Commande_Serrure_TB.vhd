----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/23/2020 11:28:08 PM
-- Design Name: 
-- Module Name: Commande_Serrure_TB - Behavioral
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

entity Commande_Serrure_TB is
--  Port ( );
end Commande_Serrure_TB;

architecture Behavioral of Commande_Serrure_TB is
    constant ClockFrequency : integer := 100e6; -- 100 MHz
    constant ClockPeriod    : time    := 1000 ms / ClockFrequency;
    component SourceCode
        port ( code : in string;
            CLK, enter : in std_logic;
            e1e, e3e, e5e, OP, VV, VR, AA: out std_logic);
    end component;
    
    signal code_in : string(4 downto 1);
    signal entered_1 : std_logic;
    signal entered_3 : std_logic;
    signal entered_5 : std_logic;
    signal clock : std_logic := '0';
    signal Ent: std_logic;
    signal Ouverture : std_logic;
    signal VoyantV : std_logic;
    signal VoyantR : std_logic;
    signal Alarme : std_logic;
        
begin
    
    UUT: SourceCode port map (code => code_in, e1e => entered_1, e3e => entered_3, e5e => entered_5, CLK => clock, enter => Ent, OP => Ouverture, VV => VoyantV, VR => VoyantR, AA => Alarme);
    
    clock <= not clock after ClockPeriod / 2;
    
    process
    
    file buff_in : text open read_mode is "/home/salmag98/Vivado/Commande_Serrure/in.txt";
    file buff_out : text open write_mode is "/home/salmag98/Vivado/Commande_Serrure/out.txt";
    variable v_ILINE     :   line;
    variable v_OLINE     :   line;
    variable codein : string(4 downto 1);
    
    begin
        
        while not endfile(buff_in) loop
        wait until rising_edge(entered_1);
        readline(buff_in,V_ILINE);
        read(v_ILINE, codein);
        code_in <= codein;
        Ent <= '1';
        
        --wait for ClockPeriod;
        --Ent <= '0';
        
        wait until rising_edge(entered_3) or rising_edge(entered_5);
        Ent <= '0';
        
        if(entered_3 = '1') then
        write(V_OLINE, codein & string'(" matching code"));
        writeline(buff_out, V_OLINE);
        end if;
        
        if(entered_5 = '1') then
        --wait until rising_edge(entered_5);
        write(V_OLINE, codein & string'(" uncorrect code"));
        writeline(buff_out, V_OLINE);
        end if;
        
        end loop;
              
        
        file_close(buff_in);
        file_close(buff_out);
        
    end process;

end Behavioral;
