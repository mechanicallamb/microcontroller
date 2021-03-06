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
        valB : in std_logic_vector((operandLength - 1) downto 0);
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


component comparator is 
                generic(operandBitLength : integer;
                        outputBitLength : integer);
                
                port(
                    
                    operandA : in std_logic_vector((operandBitLength - 1) downto 0);
                    operandB : in std_logic_vector((operandBitLength - 1) downto 0);
                    
                    output : out std_logic_vector((outputBitLength - 1) downto 0)
                
                );        
                         
end component;


type FUNCT_ARRAY is array ((numFunctions - 1) downto 0) of 
                        std_logic_vector((operandlength - 1) downto 0);

signal funct_to_mux : FUNCT_ARRAY;

signal funcConstIsZ : std_logic;

signal funcAisConst : std_logic;

signal muxToOut : std_logic_vector((operandLength - 1) downto 0);

--try implementation using an array of ints and converting to std_logic_vector
--type FUNCT_ARRAY_INT is array ((numFunctions - 1) downto 0) of 
--                        integer;
                        


begin
    
    FUNCT_MUX : mux generic map(datalength => operandLength,
                            selectorLength => opcodeLength)
                            
                    port map(
                        
                        --hardwire others to 0 later
                        data_in(1) => funct_to_mux(0),
                        data_in(2) => funct_to_mux(1),
                        data_in(3) => funct_to_mux(2),
                        data_in(4) => funct_to_mux(3),
                        data_in(5) => funct_to_mux(4),
                        data_in(6) => funct_to_mux(5),
                        data_in(7) => funct_to_mux(6),
                        data_in(8) => funct_to_mux(7),
                        data_in(9) => funct_to_mux(8),
                        data_in(10) => funct_to_mux(9),
                        
                        selector => opcode,
                        
                        data_out => muxToOut
                        
                        
                    );
        
        
        --mux for function testing for equality of const and 0,
        --if oonst == 0, pass A, otherwise pass 0
        FUNC_C_EQ_ZERO_MUX : mux generic map(dataLength => operandLength,
                                             selectorLength => 1)
                                 port map(
                                 
                                    data_in(0) => "0000",
                                    data_in(1) => valA,
                                    
                                    selector => (0 => funcConstisZ,
                                                 others => '0'),
                                    
                                    data_out => funct_to_mux(8)
                                    
                                 );
                                 
         FUNC_C_EQ_ZERO_COMP : comparator 
                                generic map(operandBitLength => 4,
                                            outputBitLength => 1)
                                                      
                                port map(
                                          
                                         operandA => "0000",
                                         operandB => valB,
                                         output => (0=> funcConstisZ,
                                                    others => '0')

                                     );
                                 
        
        
        --if A = C, pass 0. If not, pass 1 
        FUNC_A_EQ_C_MUX : mux generic map(dataLength => operandLength,
                                             selectorLength => 1)
                                 port map(
                                 
                                    data_in(0) => "0001",
                                    data_in(1) => "0000",
                                 
                                    selector => (0 => funcAisConst,
                                                 others => '0'),
                                    
                                    data_out => funct_to_mux(9)
                                    
                                 );
        
        FUNC_A_EQ_C_COMP : comparator 
                            generic map(operandBitLength => operandLength,
                                        outputBitLength => 1)
                            port map(
                            
                                    operandA => valA,
                                    operandB => valB,
                                    
                                    output => (0 => funcAisConst,
                                               others => '0')
                                               
                                     );
                                                 
        RESULT_COMPARATOR : comparator 
                            generic map(operandBitLength => 4,
                                        outputBitLength => 3)
                            port map(
                                
                                operandA => muxToOut,
                                operandB => "0000",
                                
                                --what a dumb way to have to assign things
                                output => ((2 downto 0) => poszeroneg,
                                           others => '0') 
                            
                            );
        
        
        process
            --this could also be done without the mux and just use a case statement
            --but thats no fun
            
            --variable funcResults : FUNCT_ARRAY_INT;
            
            variable valAInt : integer := to_integer(unsigned(valA));
            variable constInt : integer := to_integer(unsigned(valB));
            
            begin
            funct_to_mux(0) <= valA;
            funct_to_mux(1) <= valB;
            funct_to_mux(2) <= std_logic_vector(unsigned(valAInt + constInt));
            funct_to_mux(3) <= std_logic_vector(unsigned(valAInt - constInt));
            funct_to_mux(4) <= std_logic_vector(unsigned(valAInt * constInt));
            funct_to_mux(5) <= valA srl 1;
            funct_to_mux(6) <= not valA;
            funct_to_mux(7) <= valA and valB;
            
            
            outVal <= muxToOut;
            --should not be any need to map the last two functions
            --the result should be mapped in the comparator 
            --and mux instantiations
            
            
            
        end process;     

end Behavioral;
