----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/11/2021 02:16:34 AM
-- Design Name: 
-- Module Name: Counter - Behavioral
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
use IEEE.NUMERIC_STD.ALL;
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Counter is
    
    generic(bitlength : integer);
    
    port(
    
        data_in : in std_logic_vector((bitlength - 1) downto 0);
        data_out : out std_logic_vector((bitlength - 1) downto 0);
        carry_out : out std_logic;
        
        asyn_reset : in std_logic;
        clk : in std_logic;
        load : in std_logic;
        count : in std_logic
        
            
    );
end Counter;

architecture Behavioral of Counter is

begin

    process(clk, asyn_reset)
    
        variable liminalcount : integer := 0;
        
        begin
    
        --incrememnt if load = 0 and count = 1
        --decrememnt if load = 1 and count = 1
        --load if load = 1 and count = 0
        --no-op if load = 0 and count = 0
        
        if asyn_reset = '1' then
            data_out <= (others => '0');
        
        elsif rising_edge(clk) and load = '1' and count = '0' then
            data_out <= data_in;
     
        elsif rising_edge(clk) and load = '0' and count = '1' then
            --add
            liminalcount := to_integer(unsigned(data_out));
            liminalcount := liminalcount + 1;
            data_out <= std_logic_vector(to_unsigned(liminalcount, data_out'length));
        
        elsif rising_edge(clk) and load = '1' and count = '1' then
            --subtract
            liminalcount := to_integer(unsigned(data_out));
            liminalcount := liminalcount - 1;
            data_out <= std_logic_vector(to_unsigned(liminalcount, data_out'length));
        
        elsif rising_edge(clk) and load = '0' and count = '0' then
            --no-op
        end if;
    
    end process;


end Behavioral;
