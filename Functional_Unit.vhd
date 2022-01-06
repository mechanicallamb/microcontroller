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
use ieee.std_logic_unsigned.all;
--use ieee.std_logic_arith.all;
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
            numFunctions : integer;
            comparatorLength : integer);
    
    port(
    
        valA : in std_logic_vector((operandLength - 1) downto 0);
        valB : in std_logic_vector((operandLength - 1) downto 0);
        opcode : in std_logic_vector((opcodeLength - 1) downto 0);
        
        outVal : out std_logic_vector((operandLength - 1) downto 0);
        poszeroneg : out std_logic_vector(2 downto 0)
    );
    
end Functional_Unit;

architecture Behavioral of Functional_Unit is

use work.mux_array_pkg.all;
component mux is

    generic(datalength : integer;
            selectorlength : integer);
    
    port(
        
        data_in : in mux_array(2** selectorlength - 1 downto 0)(datalength - 1 downto 0);--this line is required or mux outputs opposite value
                                                                                          --if you want data_in(0), it will give data_in(7)
                                                                                          --if there are 8 data in vectors and you try to access
                                                                                          --data_in(0) (and vice versa)
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

signal funct_to_mux : FUNCT_ARRAY := (others => (others => '0'));

signal funcConstIsZ : std_logic_vector(comparatorLength - 1 downto 0);

signal funcAisConst : std_logic_vector(comparatorLength - 1 downto 0);

signal zeroWire : std_logic := '0';

signal muxToOut : std_logic_vector((operandLength - 1) downto 0);

signal zeroVector : std_logic_vector(operandLength - 1 downto 0) := (others => '0');

signal hardWireOne : std_logic_vector(operandLength - 1 downto 0) := (0 => '1',
                                                                        others => '0'); 

--try implementation using an array of ints and converting to std_logic_vector
--type FUNCT_ARRAY_INT is array ((numFunctions - 1) downto 0) of 
--                        integer;
                        


begin
    
    FUNCT_MUX : mux generic map(datalength => operandLength,
                            selectorLength => opcodeLength)
                            
                    port map(
                        
                        --hardwire others to 0 later
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
                        
                        data_out => muxToOut
                        
                        
                    );
        
        
        --mux for function testing for equality of const and 0,
        --if const == 0, pass A, otherwise pass 0
        FUNC_B_EQ_ZERO_MUX : mux generic map(dataLength => operandLength,
                                             selectorLength => 1)
                                 port map(
                                 
                                    data_in(0) => zeroVector,
                                    data_in(1) => valA,
                                    
                                    selector(0) => funcConstisZ(1),
                                    
                                    data_out => funct_to_mux(7)
                                    
                                 );
                                 
         FUNC_B_EQ_ZERO_COMP : comparator 
                                generic map(operandBitLength => operandLength,
                                            outputBitLength => comparatorLength)
                                                      
                                port map(
                                          
                                         operandA => zeroVector,
                                         operandB => valB,
                                         output => funcConstisZ

                                     );
                                 
        
        
        --if A = C, pass 0. If not, pass 1 
        FUNC_A_EQ_B_MUX : mux generic map(dataLength => operandLength,
                                             selectorLength => 1)
                                 port map(
                                 
                                    data_in(0) => hardWireOne,
                                    data_in(1) => zeroVector,
                                 
                                    selector(0) => funcAisConst(1),
                                    
                                    data_out => funct_to_mux(8)
                                    
                                 );
        
        FUNC_A_EQ_B_COMP : comparator 
                            generic map(operandBitLength => operandLength,
                                        outputBitLength => comparatorLength)
                            port map(
                            
                                    operandA => valA,
                                    operandB => valB,
                                    
                                    output => funcAisConst
                                               
                                     );
                                                 
        RESULT_COMPARATOR : comparator 
                            generic map(operandBitLength => operandLength,
                                        outputBitLength => comparatorLength)
                            port map(
                                
                                operandA => muxToOut,
                                operandB => zeroVector,
                                
                                --cannot use aggrigates to set the rest of output to zero if output'length > poszeroneg'length(?)
                                output => poszeroneg
                            );
        
        
--        process(valA, valB)
--            --this could also be done without the mux and just use a case statement
--            --but thats no fun
            
--            --variable funcResults : FUNCT_ARRAY_INT;
            
--            variable valAInt : integer := to_integer(unsigned(valA));
--            variable constInt : integer := to_integer(unsigned(valB));
            
--            begin

            funct_to_mux(0) <= valA;
            funct_to_mux(1) <= valB;
            funct_to_mux(2) <= valA + valB;
            funct_to_mux(3) <= valA - valB;
--            funct_to_mux(4) <= valA(operandLength / 2 downto 0) * valB(operandLength / 2 downto 0); --//does not support result width large enough for multiplcation
            funct_to_mux(4) <= valA srl 1;
            funct_to_mux(5) <= not valA;
            funct_to_mux(6) <= valA and valB;
            
            
            outVal <= muxToOut;
            --should not be any need to map the last two functions
            --the result should be mapped in the comparator 
            --and mux instantiations
            
           
            
          
            
            
--        end process;     

end Behavioral;
