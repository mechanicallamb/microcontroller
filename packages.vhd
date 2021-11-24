----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/21/2021 05:34:14 AM
-- Design Name: 
-- Module Name: packages - Behavioral
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

--i realize what is in this file is bad design (in my opinion)
--but it is being done just to get used to using generic packages

package array_of_vector_pkg is
    
 generic (arraysize, bitlength : integer);
 type array_of_vect is array ((arraysize - 1) downto 0) of std_logic_vector((bitlength - 1) downto 0);

end package;

package vector_array is new work.array_of_vector_pkg
    generic map(arraysize => 8, bitlength => 4);

--notation is vector_array with data size of 3 bits per vector, 8 vectors wide
package vector_array_d1w8 is new work.array_of_vector_pkg
    generic map(arraysize => 8, bitlength = 1);
   
package vector_array_d4w16 is new work.array_of_vector_pkg
    generic map(arraysize => 16, bitlength => 4);

package vector_array_d4w2 is new work.array_of_vector_pkg
    generic map(arraysize => 2, bitlength => 4)
