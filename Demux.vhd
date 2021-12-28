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
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;



use work.vector_array.all;

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
    
    
    process(selector, data_in, data_out)
    
        variable selectorInt : integer;
        begin
        
        selectorInt := to_integer(unsigned(selector));
         
         for I in 0 to 2**selectorLength - 1 loop
            
            if I = selectorInt then
                                 
                data_out(I)(datalength - 1 downto 0) <= data_in;
                data_out(I)(data_out(I)'length - 1 downto datalength) <= ( others => '0');
                
            else
              
                data_out(I) <= (others => '0');
             
            end if;
            
         end loop;
                     
        end process;

--        data_out(to_integer(unsigned(selector))) (datalength - 1 downto 0) <= data_in;
--        data_out(to_integer(unsigned(selector))) (data_out(to_integer(unsigned(selector)))'length - 1 downto datalength) <= (others => '0');
        

end Behavioral;
