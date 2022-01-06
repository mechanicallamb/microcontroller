----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 01/03/2022 11:38:03 AM
-- Design Name: 
-- Module Name: functionalUnit_tb - Behavioral
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

entity functionalUnit_tb is
--  Port ( );
end functionalUnit_tb;

architecture Behavioral of functionalUnit_tb is


component Functional_Unit is
    
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
    
end component;


signal valA_tb : std_logic_vector(16 downto 0) := (others => '0');
signal valB_tb : std_logic_vector(16 downto 0) := (others => '0');
signal opcode_tb : std_logic_vector(3 downto 0) := "0000";

signal outVal_tb : std_logic_vector(16 downto 0);
signal poszeroneg_tb : std_logic_vector(2 downto 0);


begin

    FUNC_UNIT_TB : Functional_Unit generic map(
                                    operandLength => 17,
                                    opcodeLength => 4,
                                    numFunctions => 10,
                                    comparatorLength => 3
                                )
                                port map(
                                
                                    valA => valA_tb,
                                    valB => valB_tb,
                                    opcode => opcode_tb,
                                    
                                    outVal => outVal_tb,
                                    poszeroneg => poszeroneg_tb
                                
                                );

    process
    
        begin
        
        valA_tb  <= "01100000011110010";
        valB_tb <= "00000000011111111";
            --pass A
            
            opcode_tb <= "0000";
            wait for 20 ns;
            
            opcode_tb <= "0001";
            wait for 20 ns;
            
            --pass B
            opcode_tb <= "0010";
            wait for 20 ns;
            
            --add A and B
            opcode_tb <= "0011";
            wait for 20 ns;
            
            --subtract A and B
            opcode_tb <= "0100";
            wait for 20 ns;
            
--            --multiply A and B
            opcode_tb <= "0101";
            wait for 20 ns;
            
            --logical right shift A
            opcode_tb <= "0110";
            wait for 20 ns;
            
            --not A
            opcode_tb <= "0111";
            wait for 20 ns;
            
            --A and B
            opcode_tb <= "1000";
            wait for 20 ns;
            
            --if B = 0, pass A
            opcode_tb <= "1001";
            wait for 20 ns;
            
            --if A != B, pass 1 / else pass 0
           
        
        
        
   end process;


end Behavioral;
