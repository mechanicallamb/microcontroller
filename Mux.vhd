----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/21/2021 04:29:55 AM
-- Design Name: 
-- Module Name: Mux - Behavioral
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


package Eight_To_One_Mux is new work.array_of_vector_pkg
    generic map(arraysize => 8, bitlength => 4);
    
-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.Eight_To_One_Mux.all;


entity mux is

    generic(datalength : integer;
            selectorlength : integer);
    
    port(
        
        data_in : in array_of_vect;
        selector : in std_logic_vector((selectorlength - 1) downto 0);
        
        data_out : out std_logic_vector((datalength - 1) downto 0)
    
    );
    
end mux;

architecture Behavioral of mux is
 
begin
    process
        begin 
        
            data_out <= data_in(integer(selector));
            
    end process;

end Behavioral;
