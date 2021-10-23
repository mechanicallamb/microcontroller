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

package One_To_Eight_Demux is new work.array_of_vector_pkg
    generic map(arraysize => 8, bitlength => 4);


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.One_To_Eight_Demux.all;

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
        for i in integer(arraysize - 1) downto 0 loop
        
            if (i = integer(selector)) then
                data_out(integer(selector)) <= data_in;
            else 
                data_out(i) <= "0000";  
            end if;
             
        end loop;
        
    end process;

end Behavioral;
