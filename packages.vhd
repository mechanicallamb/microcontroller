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

package array_of_vector_pkg is
    
 generic (arraysize, bitlength : integer);
 type array_of_vect is array ((arraysize - 1) downto 0) of std_logic_vector((bitlength - 1) downto 0);

end package;

