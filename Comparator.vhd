----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 11/15/2021 08:04:35 PM
-- Design Name: 
-- Module Name: Comparator - Behavioral
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

entity Comparator is

    generic(operandBitlength : integer;
            outputBitlength : integer);
            
    port(
        
        operandA : in std_logic_vector((operandBitlength - 1) downto 0);
        operandB : in std_logic_vector((operandBitlength - 1) downto 0);
        
        output : out std_logic_vector((outputBitlength - 1) downto 0)
        
        );
        
end Comparator;

architecture Behavioral of Comparator is

begin

    process(operandA, operandB)
        
        variable operandAInt : integer;
        variable operandBInt : integer;
        
        begin
        
        operandAInt := to_integer(unsigned(operandA));
        operandBInt := to_integer(unsigned(operandB));
        
        if operandAInt > operandBInt then
            output <= (0 => '1', others => '0');
        elsif operandAInt = operandBInt then
            output <= (1 => '1', others => '0');
        elsif operandAInt < operandBInt then
            output <= (2 => '1', others => '0');
        end if;
        
    end process;


end Behavioral;
