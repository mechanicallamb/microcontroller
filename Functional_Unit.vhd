----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 10/21/2021 12:32:12 AM
-- Design Name: 
-- Module Name: Functional_Unit - Behavioral
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

entity Functional_Unit is
    
    generic(operandLength : integer;
            opcodeLength : integer;
            numFunctions : integer);
    
    port(
    
        valA : in std_logic_vector((operandLength - 1) downto 0);
        const : in std_logic_vector((operandLength - 1) downto 0);
        opcode : in std_logic_vector((opcodeLength - 1) downto 0);
        
        outVal : out std_logic_vector((operandLength - 1) downto 0);
        poszeroneg : out std_logic_vector(2 downto 0)
    );
    
end Functional_Unit;

architecture Behavioral of Functional_Unit is

use work.vector_array_d4w16.all;
component mux is

    generic(datalength : integer;
            selectorlength : integer);
    
    port(
        
        data_in : in array_of_vect; --this is not defined(?)
        selector : in std_logic_vector((selectorlength - 1) downto 0);
        
        data_out : out std_logic_vector((datalength - 1) downto 0)
    
    );
    
end component;

type FUNCT_ARRAY is array ((numFunctions - 1) downto 0) of 
                        std_logic_vector((operandlength - 1) downto 0);

signal funct_to_mux : FUNCT_ARRAY;

--try implementation using an array of ints and converting to std_logic_vector
--type FUNCT_ARRAY_INT is array ((numFunctions - 1) downto 0) of 
--                        integer;
                        


begin
    
    FUNCT_MUX : mux generic map(datalength => operandLength,
                            selectorLength => opcodeLength)
                            
                    port map(
                        
                        data_in(0) => funct_to_mux(0),
                        data_in(1) => funct_to_mux(1),
                        data_in(2) => funct_to_mux(2),
                        data_in(3) => funct_to_mux(3),
                        data_in(4) => funct_to_mux(4),
                        data_in(5) => funct_to_mux(5),
                        data_in(6) => funct_to_mux(6),
                        data_in(7) => funct_to_mux(7),
                        data_in(8) => funct_to_mux(8),
                        data_in(9) => funct_to_mux(9),
                        
                        selector => opcode,
                        
                        data_out => outVal
                        
                        
                    );
                    
        process
            --this could also be done without the mux and just use a case statement
            --but thats no fun
            
            --variable funcResults : FUNCT_ARRAY_INT;
            
            variable valAInt : integer := to_integer(unsigned(valA));
            variable constInt : integer := to_integer(unsigned(const));
            
            begin
            
            funct_to_mux(2) <= std_logic_vector(unsigned(valAInt + constInt));
            funct_to_mux(3) <= std_logic_vector(unsigned(valAInt - constInt));
            funct_to_mux(4) <= std_logic_vector(unsigned(valAInt * constInt));
            funct_to_mux(5) <= valA srl 1;
            funct_to_mux(6) <= not valA;
            funct_to_mux(7) <= valA and const;
            
            --need muxes for these two operations
            --funct_to_mux(8)(0) <= std_logic_vector(unsigned(valAInt + constInt));
            --funct_to_mux(9) <= std_logic_vector(unsigned(valAInt + constInt));
            
            
        end process;     

end Behavioral;
