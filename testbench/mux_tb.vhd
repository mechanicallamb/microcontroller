----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 12/30/2021 05:57:17 AM
-- Design Name: 
-- Module Name: mux_tb - Behavioral
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

entity mux_tb is
--  Port ( );
end mux_tb;

architecture Behavioral of mux_tb is

use work.mux_array_pkg.all;
component mux is
    
    generic(datalength : integer;
            selectorlength : integer);
    
    port(
    
        data_out : out std_logic_vector((datalength - 1) downto 0);
        selector : in std_logic_vector((selectorlength - 1) downto 0);
        
        data_in : out mux_array(2**selectorlength - 1 downto 0)(datalength - 1 downto 0)
        
    );
    
    
end component;

signal data_out_tb : std_logic_vector(3 downto 0);

type tb_array_type is array (7 downto 0) of std_logic_vector(3 downto 0);
signal data_in_tb : tb_array_type;

signal select_tb : std_logic_vector(2 downto 0);


begin

data_in_tb(0) <= "1001";
data_in_tb(1) <= "1111";
data_in_tb(2) <= "0001";
data_in_tb(3) <= "1101";
data_in_tb(4) <= "0011";
data_in_tb(5) <= "0101";
data_in_tb(6) <= "1000";
data_in_tb(7) <= "1100";

    DEMUX_TB : mux generic map(
                           datalength => 4,
                           selectorlength => 3
                            )
                            
                 port map(
                 
                    data_in(0) => data_in_tb(0),
                    data_in(1) => data_in_tb(1),
                    data_in(2) => data_in_tb(2),
                    data_in(3) => data_in_tb(3),
                    data_in(4) => data_in_tb(4),
                    data_in(5) => data_in_tb(5),
                    data_in(6) => data_in_tb(6),
                    data_in(7) => data_in_tb(7),
                    
                    data_out => data_out_tb,
                    
                    selector => select_tb
                    
                 
                 );
                 
                 
     process 
     
        begin
        
            select_tb <= "000";
            wait for 5 ns;
            
            select_tb <= "001";
            wait for 5 ns;
            
            select_tb <= "010";
            wait for 5 ns;
            
            select_tb <= "011";
            wait for 5 ns;
            
            select_tb <= "100";
            wait for 5 ns;
            
            select_tb <= "101";
            wait for 5 ns;
            
            select_tb <= "110";
            wait for 5 ns;
            
            select_tb <= "111";
            wait for 5 ns;
            
            select_tb <= "110";
            wait for 5 ns;
            
            select_tb <= "101";
            wait for 5 ns;
            
            select_tb <= "100";
            wait for 5 ns;
            
            select_tb <= "011";
            wait for 5 ns;
            
            select_tb <= "010";
            wait for 5 ns;
            
            select_tb <= "001";
            wait for 5 ns;
            
            select_tb <= "000";
            wait for 5 ns;
            
            select_tb <= "111";
            wait for 5 ns;
            
            select_tb <= "010";
            wait for 5 ns;
         
        
        
     end process;


end Behavioral;
