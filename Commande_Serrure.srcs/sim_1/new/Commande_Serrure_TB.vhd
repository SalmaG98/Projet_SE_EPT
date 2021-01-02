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
        port ( code, numero_tel : in string;
            code_debloc : in string;
            code_debloc_verif : inout integer;
            CLK, enter : in std_logic;
            e1e, e3e, e5e, e7e, e9e, e10e, e11e, e12e, OP, VV, VR, AA: out std_logic);
    end component;
    
    signal code_in : string(4 downto 1);
    signal code_d : string(4 downto 1);
    signal code_debloc_v : integer;
    signal num_tel : string(8 downto 1);
    signal entered_1 : std_logic;
    signal entered_3 : std_logic;
    signal entered_5 : std_logic;
    signal entered_7 : std_logic;
    signal entered_9 : std_logic;
    signal entered_10 : std_logic;
    signal entered_11 : std_logic;
    signal entered_12 : std_logic;
    signal clock : std_logic := '0';
    signal Ent: std_logic;
    signal Ouverture : std_logic;
    signal VoyantV : std_logic;
    signal VoyantR : std_logic;
    signal Alarme : std_logic;
        
begin
    
    UUT: SourceCode port map (code => code_in, e1e => entered_1, e3e => entered_3, e5e => entered_5, e7e => entered_7, e9e => entered_9, e10e => entered_10, e11e => entered_11, e12e => entered_12, numero_tel => num_tel, code_debloc => code_d, code_debloc_verif => code_debloc_v, CLK => clock, enter => Ent, OP => Ouverture, VV => VoyantV, VR => VoyantR, AA => Alarme);
    
    clock <= not clock after ClockPeriod / 2;
    
    process
    
    file buff_in : text open read_mode is "/home/salmag98/Vivado/Commande_Serrure/in.txt";
    file buff_out : text open write_mode is "/home/salmag98/Vivado/Commande_Serrure/out.txt";
    file buff_num : text open read_mode is "/home/salmag98/Vivado/Commande_Serrure/num.txt";
    file buff_codeout : text open write_mode is "/home/salmag98/Vivado/Commande_Serrure/codeVout.txt";
    file buff_codein : text open read_mode is "/home/salmag98/Vivado/Commande_Serrure/codeVin.txt";
    file log : text open write_mode is "/home/salmag98/Vivado/Commande_Serrure/log.txt";
    variable v_ILINE     :   line;
    variable v_OLINE     :   line;
    variable codein : string(4 downto 1);
    variable debloc : string(4 downto 1);
    
    begin
        
        while not endfile(buff_in) loop
        
        wait until rising_edge(entered_1);
        readline(buff_in,v_ILINE);
        read(v_ILINE, codein);
        code_in <= codein;
        Ent <= '1';
        
        --wait for ClockPeriod;
        --Ent <= '0';
        
        wait until rising_edge(entered_3) or rising_edge(entered_5);
        Ent <= '0';
        
        if(entered_3 = '1') then
        write(v_OLINE, codein & string'(" matching code"));
        writeline(buff_out, v_OLINE);
        end if;
        
        if(entered_5 = '1') then
        --wait until rising_edge(entered_5);
        write(v_OLINE, codein & string'(" uncorrect code"));
        writeline(buff_out, v_OLINE);
        
        wait until rising_edge(entered_7);
        write(v_OLINE, string'("Dernière tentative!!"));
        writeline(log, v_OLINE);
        
        wait until rising_edge(entered_9);
        write(v_OLINE, string'("Entrer numéro de telephone de securité:"));
        writeline(log, v_OLINE);
        
        wait until rising_edge(entered_10) or rising_edge(entered_11);
        
        if(entered_10 = '1') then
        write(v_OLINE, string'("Alerte Intrusion!!"));
        writeline(log, v_OLINE);
        end if;
        
        if(entered_11 = '1') then
        write(v_OLINE, string'("Entrer code:"));
        writeline(log, v_OLINE);
        readline(buff_codein,v_ILINE);
        read(v_ILINE, debloc);
        code_d <= debloc;
        Ent <= '1';
        end if;
        
        
        wait until rising_edge(entered_12);
        Ent <= '0';
        end if;
        end loop;
              
        
        file_close(buff_in);
        file_close(buff_out);
        
    end process;

end Behavioral;
