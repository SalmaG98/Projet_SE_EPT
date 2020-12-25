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
            OP, VV, VR, AA: out std_logic);
    end component;
    
    signal code_in : string(4 downto 1);
    signal clock : std_logic := '0';
    signal Ent: std_logic;
    signal Ouverture : std_logic;
    signal VoyantV : std_logic;
    signal VoyantR : std_logic;
    signal Alarme : std_logic;
        
begin
    
    UUT: SourceCode port map (code => code_in, CLK => clock, enter => Ent, OP => Ouverture, VV => VoyantV, VR => VoyantR, AA => Alarme);
    
    clock <= not clock after ClockPeriod / 2;
    
    process
    
    file buff_in : text open read_mode is "/home/salmag98/Vivado/Commande_Serrure/in.txt";
    file buff_out : text open write_mode is "/home/salmag98/Vivado/Commande_Serrure/out.txt";
    variable row : line;
    variable code_in : string(4 downto 1);
    
    begin
        
        readline(buff_in,row);
        read(row, code_in);
        wait for 50ns;
        readline(buff_in,row);
        read(row, code_in);
        wait for 50ns;    
        readline(buff_in,row);
        read(row, code_in);
        wait for 50ns;   
        readline(buff_in,row);
        read(row, code_in);
        wait for 50ns;   
        readline(buff_in,row);
        read(row, code_in);
        wait for 50ns;      
        
    end process;

end Behavioral;
