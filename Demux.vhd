----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/21/2021 04:24:24 AM
-- Design Name: 
-- Module Name: Demux - Behavioral
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


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.vector_array.all;
use IEEE.NUMERIC_STD.ALL;

entity demux is
    
    generic(datalength : integer;
            selectorlength : integer);
    
    port(
        data_in : in std_logic_vector((datalength - 1) downto 0);
        selector : in std_logic_vector((selectorlength - 1) downto 0);
        
        data_out : out array_of_vect
        
    );
    
    
end demux;

architecture Behavioral of demux is

begin
    
    process
        begin
        
        
        --set logic vector != selector to 0
        for i in (arraysize - 1) downto 0 loop
        
            if (i = to_integer(unsigned(selector))) then
                --the following line probably causes issues if data in is not the same length as data out
                --figure out how to incorporate others statement
                data_out(to_integer(unsigned(selector))) <= ( (bitlength - 1) downto 0 => data_in,
                                                              others => '0');
            else 
                data_out(i) <= (others => '0');  
            end if;
             
        end loop;
        
    end process;

end Behavioral;
