----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/21/2021 04:42:48 AM
-- Design Name: 
-- Module Name: Register_4bit - Behavioral
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

entity reg is 
    
    generic (bitlength : integer);
    
    port(
        
        data_in : in std_logic_vector((bitlength - 1) downto 0);
        data_out : out std_logic_vector((bitlength - 1) downto 0);
        
        asyn_reset : in std_logic;
        clk : in std_logic;
        enable : in std_logic
        
    );
    
end reg;


architecture Behavioral of reg is

signal reg_value : std_logic_vector((bitlength - 1) downto 0);


begin
    
    process(rising_edge(clk))
        begin
        
            if enable = '1' then
                
                reg_value <= data_in;
                data_out <= reg_value;
                
            end if;
            
    end process;
    
    process(asyn_reset)
        begin
            
            reg_value <= "0000";
            data_out <= reg_value;
            
    end process;


end Behavioral;
