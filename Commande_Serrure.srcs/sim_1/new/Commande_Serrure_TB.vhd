----------------------------------------------------------------------------------
-- Company: 
-- Engineer: Salma Galaaoui & Abdessalem Achour
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
--use IEEE.NUMERIC_STD.ALL;

entity Commande_Serrure_TB is
--  Port ( );
end Commande_Serrure_TB;

architecture Behavioral of Commande_Serrure_TB is
    constant ClockFrequency : integer := 100e6; -- 100 MHz
    constant ClockPeriod    : time    := 1000 ms / ClockFrequency;
    component SourceCode
        port ( code, numero_tel : in string;
            code_debloc : in string;
            code_debloc_verif : buffer integer;
            cur_state, Ntries : out integer;
            CLK, enter : in std_logic;
            OP, VV, VR, AA: out std_logic);
    end component;

--function switching outputs depending on whether the input condition is verified
--used for the value of Ent signal    
function tern(cond : boolean; res_true, res_false : std_logic) return std_logic is
begin
  if cond then
    return res_true;
  else
    return res_false;
  end if;
end function;
    
    
    signal code_in : string(4 downto 1);
    signal code_d : string(4 downto 1);
    signal code_debloc_v : integer;
    signal num_tel : string(8 downto 1);
    signal current_state : integer;
    signal Tries_Remaining : integer;
    signal clock : std_logic := '0';
    signal Ent: std_logic := '0';
    signal Ouverture : std_logic;
    signal VoyantV : std_logic;
    signal VoyantR : std_logic;
    signal Alarme : std_logic;
        
begin
    -- e0e => entered_0, e1e => entered_1, e2e => entered_2, e3e => entered_3, e4e => entered_4,  e5e => entered_5, e6e => entered_6, e7e => entered_7, e8e => entered_8, e9e => entered_9, e10e => entered_10, e11e => entered_11, e12e => entered_12, e13e => entered_13, 
    UUT: SourceCode port map (code => code_in, numero_tel => num_tel, code_debloc => code_d, code_debloc_verif => code_debloc_v, cur_state => current_state, Ntries => Tries_Remaining, CLK => clock, enter => Ent, OP => Ouverture, VV => VoyantV, VR => VoyantR, AA => Alarme);
    
    clock <= not clock after ClockPeriod / 2;
    
    process(current_state,clock) is
    
    file buff_in : text open read_mode is "/home/salmag98/Vivado/Commande_Serrure/in.txt";
    file buff_out : text open write_mode is "/home/salmag98/Vivado/Commande_Serrure/out.txt";
    file buff_num : text open read_mode is "/home/salmag98/Vivado/Commande_Serrure/num.txt";
    file buff_codeout : text open write_mode is "/home/salmag98/Vivado/Commande_Serrure/codeVout.txt";
    file buff_codein : text open read_mode is "/home/salmag98/Vivado/Commande_Serrure/codeVin.txt";
    file log : text open write_mode is "/home/salmag98/Vivado/Commande_Serrure/log.txt";
    variable line_in, line_out, line_num, line_codeout, line_codein , line_log    :   line;
    --variable v_OLINE     :   line;
    variable codein : string(4 downto 1);
    variable debloc : string(4 downto 1);
    variable num : string(8 downto 1);
    variable v_TIME : time := 0ns;
    
    begin
        
        Ent <= tern((current_state = 1) or (current_state = 12), '1', '0');
        --Ent is HIGH only when state is E1 or E11 and LOW otherwise
        
        if(rising_edge(clock)) then
        
            case current_state is
            
                when 1 =>
                readline(buff_in,line_in);
                read(line_in, codein);
                code_in <= codein;
                
                when 3 =>
                --entered code is correct
                write(line_out, time'image(now - v_TIME) & string'(" ") & codein & string'(" matching code"));
                writeline(buff_out, line_out);
                
                when 5 =>
                --entered code does not match
                write(line_out, time'image(now - v_TIME) & string'(" ") & codein & string'(" uncorrect code"));
                writeline(buff_out, line_out);
                
                when 7 =>
                --Number of tries almost reached.
                write(line_log, time'image(now - v_TIME) & string'(" Dernière tentative!!"));
                writeline(log, line_log);
                
                when 9 =>
                write(line_log, time'image(now - v_TIME) & string'(" Entrer numéro de telephone de securité:"));
                writeline(log, line_log);
                readline(buff_num,line_num);
                read(line_num, num);
                num_tel <= num;
                
                when 10 =>
                write(line_log, time'image(now - v_TIME) & string'(" Alerte Intrusion!!"));
                writeline(log, line_log);
                
                when 11 =>
                --send verification code
                write(line_codeout, time'image(now - v_TIME) & string'(" ") & integer'image(code_debloc_v));
                writeline(buff_codeout, line_codeout);
                
                when 12 =>
                --prompt user for verification code sent on cellphone
                write(line_log, time'image(now - v_TIME) & string'(" Entrer code:"));
                writeline(log, line_log);
                -- "read" entered code
                readline(buff_codein,line_codein);
                read(line_codein, debloc);
                code_d <= debloc;
                
                when others =>
                null;
                
            end case;
        end if;
        
        --file_close(buff_in);
        --file_close(buff_out);
        
    end process;

end Behavioral;
